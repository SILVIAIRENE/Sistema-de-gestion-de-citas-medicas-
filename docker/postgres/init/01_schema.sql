--
-- PostgreSQL database dump
--


-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: vida_salud; Type: SCHEMA; Schema: -; Owner: -
--

DROP SCHEMA IF EXISTS vida_salud CASCADE;
CREATE SCHEMA vida_salud;


--
-- Name: estado_cita; Type: TYPE; Schema: vida_salud; Owner: -
--

CREATE TYPE vida_salud.estado_cita AS ENUM (
    'PROGRAMADA',
    'CONFIRMADA',
    'EN_ESPERA',
    'EN_ATENCION',
    'ATENDIDA',
    'CANCELADA',
    'INASISTENCIA'
);


--
-- Name: estado_notificacion; Type: TYPE; Schema: vida_salud; Owner: -
--

CREATE TYPE vida_salud.estado_notificacion AS ENUM (
    'PENDIENTE',
    'ENVIADA',
    'FALLIDA'
);


--
-- Name: estado_usuario; Type: TYPE; Schema: vida_salud; Owner: -
--

CREATE TYPE vida_salud.estado_usuario AS ENUM (
    'ACTIVO',
    'INACTIVO',
    'BLOQUEADO'
);


--
-- Name: tipo_accion; Type: TYPE; Schema: vida_salud; Owner: -
--

CREATE TYPE vida_salud.tipo_accion AS ENUM (
    'CREAR',
    'MODIFICAR',
    'ELIMINAR',
    'LOGIN',
    'LOGOUT',
    'BLOQUEO',
    'INACTIVAR',
    'REGISTRAR',
    'RENOVAR',
    'REACTIVAR'
);


--
-- Name: tipo_bloqueo; Type: TYPE; Schema: vida_salud; Owner: -
--

CREATE TYPE vida_salud.tipo_bloqueo AS ENUM (
    'FERIADO',
    'LICENCIA',
    'OTRO'
);


--
-- Name: tipo_reporte; Type: TYPE; Schema: vida_salud; Owner: -
--

CREATE TYPE vida_salud.tipo_reporte AS ENUM (
    'CITAS_PERIODO',
    'ATENCIONES_MEDICO_ESPECIALIDAD',
    'CONTROL_ASISTENCIA',
    'PACIENTES_REGISTRADOS',
    'INGRESOS_FINANCIEROS'
);


--
-- Name: fn_bitacora_cita(); Type: FUNCTION; Schema: vida_salud; Owner: -
--

CREATE FUNCTION vida_salud.fn_bitacora_cita() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE v_id bigint; v_accion tipo_accion;
BEGIN
  v_accion := CASE TG_OP WHEN 'INSERT' THEN 'CREAR' WHEN 'UPDATE' THEN 'MODIFICAR'
                         ELSE 'ELIMINAR' END;
  v_id := CASE WHEN TG_OP = 'DELETE' THEN OLD.id_cita ELSE NEW.id_cita END;
  INSERT INTO bitacora (id_usuario, modulo, tipo_accion, tabla_afectada, id_registro_afectado, detalle)
  VALUES (NULLIF(current_setting('app.id_usuario', true), '')::bigint, 'P6 Gestión de Citas',
          v_accion, 'cita', v_id, TG_OP || ' cita ' ||
          CASE WHEN TG_OP = 'DELETE' THEN OLD.codigo ELSE NEW.codigo END);
  RETURN NULL;
END $$;


--
-- Name: fn_cita_atendida_inmutable(); Type: FUNCTION; Schema: vida_salud; Owner: -
--

CREATE FUNCTION vida_salud.fn_cita_atendida_inmutable() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF OLD.estado = 'ATENDIDA' THEN
    RAISE EXCEPTION 'La cita % ya fue ATENDIDA y no puede modificarse', OLD.codigo;
  END IF;
  RETURN CASE WHEN TG_OP = 'DELETE' THEN OLD ELSE NEW END;
END $$;


--
-- Name: fn_cita_bloqueo_agenda(); Type: FUNCTION; Schema: vida_salud; Owner: -
--

CREATE FUNCTION vida_salud.fn_cita_bloqueo_agenda() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.estado <> 'CANCELADA' AND EXISTS (
       SELECT 1 FROM bloqueo_agenda b
       WHERE NEW.fecha BETWEEN b.fecha_inicio AND b.fecha_fin
         AND (b.aplica_a_todos OR b.id_medico = NEW.id_medico)) THEN
    RAISE EXCEPTION 'No se puede agendar el %: la agenda está bloqueada', NEW.fecha;
  END IF;
  RETURN NEW;
END $$;


--
-- Name: fn_cita_crear_notificacion(); Type: FUNCTION; Schema: vida_salud; Owner: -
--

CREATE FUNCTION vida_salud.fn_cita_crear_notificacion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO notificacion (id_cita, mensaje, fecha_programada)
  VALUES (NEW.id_cita,
          'Recordatorio: cita ' || NEW.codigo || ' el ' || to_char(NEW.fecha, 'DD/MM/YYYY')
          || ' a las ' || to_char(NEW.hora_inicio, 'HH24:MI'),
          (NEW.fecha - 1) + TIME '09:00');
  RETURN NULL;
END $$;


--
-- Name: fn_cita_dentro_horario(); Type: FUNCTION; Schema: vida_salud; Owner: -
--

CREATE FUNCTION vida_salud.fn_cita_dentro_horario() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM horario h
                 WHERE h.id_medico = NEW.id_medico AND h.activo
                   AND h.dia_semana = EXTRACT(ISODOW FROM NEW.fecha)
                   AND NEW.hora_inicio >= h.hora_inicio AND NEW.hora_fin <= h.hora_fin) THEN
    RAISE EXCEPTION 'La cita (% %) está fuera del horario del médico %',
      NEW.fecha, NEW.hora_inicio, NEW.id_medico;
  END IF;
  RETURN NEW;
END $$;


--
-- Name: fn_cita_historial_estado(); Type: FUNCTION; Schema: vida_salud; Owner: -
--

CREATE FUNCTION vida_salud.fn_cita_historial_estado() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO historial_estado_cita (id_cita, id_usuario, estado_anterior, estado_nuevo,
                                     fecha_anterior, hora_anterior, motivo)
  VALUES (NEW.id_cita,
          COALESCE(NULLIF(current_setting('app.id_usuario', true), '')::bigint, NEW.id_usuario_registro),
          OLD.estado, NEW.estado, OLD.fecha, OLD.hora_inicio,
          COALESCE(NEW.motivo_cancelacion, 'Cambio de ' || OLD.estado || ' a ' || NEW.estado));
  RETURN NEW;
END $$;


--
-- Name: fn_cita_persona_activa(); Type: FUNCTION; Schema: vida_salud; Owner: -
--

CREATE FUNCTION vida_salud.fn_cita_persona_activa() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (SELECT 1 FROM persona WHERE id_persona IN (NEW.id_medico, NEW.id_paciente)
             AND NOT activo) THEN
    RAISE EXCEPTION 'El médico o el paciente de la cita está inactivo';
  END IF;
  RETURN NEW;
END $$;


--
-- Name: fn_cita_sin_solapamiento(); Type: FUNCTION; Schema: vida_salud; Owner: -
--

CREATE FUNCTION vida_salud.fn_cita_sin_solapamiento() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.estado <> 'CANCELADA' AND EXISTS (
       SELECT 1 FROM cita c
       WHERE c.id_cita <> NEW.id_cita AND c.estado <> 'CANCELADA' AND c.fecha = NEW.fecha
         AND (c.id_medico = NEW.id_medico OR c.id_paciente = NEW.id_paciente)
         AND c.hora_inicio < NEW.hora_fin AND c.hora_fin > NEW.hora_inicio) THEN
    RAISE EXCEPTION 'La cita se cruza con otra del mismo médico o paciente el %', NEW.fecha;
  END IF;
  RETURN NEW;
END $$;


--
-- Name: fn_info_medica_fecha_actualizacion(); Type: FUNCTION; Schema: vida_salud; Owner: -
--

CREATE FUNCTION vida_salud.fn_info_medica_fecha_actualizacion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.fecha_actualizacion := now();
  RETURN NEW;
END $$;


--
-- Name: fn_paciente_no_eliminar(); Type: FUNCTION; Schema: vida_salud; Owner: -
--

CREATE FUNCTION vida_salud.fn_paciente_no_eliminar() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (SELECT 1 FROM cita WHERE id_paciente = OLD.id_persona) THEN
    RAISE EXCEPTION 'El paciente % tiene citas registradas: use sp_desactivar_paciente', OLD.codigo;
  END IF;
  RETURN OLD;
END $$;


--
-- Name: sp_asignar_permiso_rol(bigint, bigint, bigint); Type: PROCEDURE; Schema: vida_salud; Owner: -
--

CREATE PROCEDURE vida_salud.sp_asignar_permiso_rol(IN p_rol bigint, IN p_permiso bigint, IN p_usuario bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO rol_permiso (id_rol, id_permiso) VALUES (p_rol, p_permiso)
  ON CONFLICT DO NOTHING;
  IF FOUND THEN
    INSERT INTO bitacora (id_usuario, modulo, tipo_accion, tabla_afectada, id_registro_afectado, detalle)
    VALUES (p_usuario, 'P2 Administración de Usuarios RBAC', 'CREAR', 'rol_permiso', p_rol,
            'Permiso ' || p_permiso || ' asignado al rol ' || p_rol);
  ELSE
    RAISE NOTICE 'El rol % ya tenía el permiso %', p_rol, p_permiso;
  END IF;
END $$;


--
-- Name: sp_cancelar_cita(bigint, bigint, character varying); Type: PROCEDURE; Schema: vida_salud; Owner: -
--

CREATE PROCEDURE vida_salud.sp_cancelar_cita(IN p_cita bigint, IN p_usuario bigint, IN p_motivo character varying)
    LANGUAGE plpgsql
    SET search_path TO 'vida_salud'
    AS $$
DECLARE
  v_estado_anterior estado_cita;
  v_codigo varchar(12);
BEGIN
  -- 1. Validar que el motivo no sea nulo ni vacío (CU24)
  IF p_motivo IS NULL OR btrim(p_motivo) = '' THEN
    RAISE EXCEPTION 'El motivo de cancelación es obligatorio';
  END IF;

  -- Guardar variable de sesión (por si tienes triggers de auditoría adicionales)
  PERFORM set_config('app.id_usuario', p_usuario::text, true);

  -- 2. Obtener estado actual y bloquear la fila para evitar concurrencia
  SELECT estado, codigo
    INTO v_estado_anterior, v_codigo
    FROM cita
   WHERE id_cita = p_cita
     AND estado IN ('PROGRAMADA', 'CONFIRMADA')
     FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'La cita % no existe o no puede cancelarse (solo citas PROGRAMADAS o CONFIRMADAS)', p_cita;
  END IF;

  -- 3. Actualizar la cita a CANCELADA (libera el cupo automáticamente gracias al índice parcial)
  UPDATE cita
     SET estado = 'CANCELADA',
         motivo_cancelacion = btrim(p_motivo)
   WHERE id_cita = p_cita;

  -- 4. Registrar el cambio en el historial de estados (CU24, CU25)
  INSERT INTO historial_estado_cita (
    id_cita, id_usuario, estado_anterior, estado_nuevo, motivo
  )
  VALUES (
    p_cita, p_usuario, v_estado_anterior, 'CANCELADA', btrim(p_motivo)
  );

  -- 5. Si tenía recordatorios telefónicos PENDIENTES, eliminarlos para que recepción no llame (CU34)
  DELETE FROM notificacion
   WHERE id_cita = p_cita
     AND estado = 'PENDIENTE';

  -- 6. Registrar en bitácora (CU10)
  INSERT INTO bitacora (
    id_usuario, modulo, tipo_accion, tabla_afectada, id_registro_afectado, detalle
  )
  VALUES (
    p_usuario, 'P6 Gestión de Citas', 'MODIFICAR', 'cita', p_cita,
    'Cancelación de cita ' || v_codigo || '. Motivo: ' || btrim(p_motivo)
  );
END $$;


--
-- Name: sp_confirmar_por_llamada(bigint, bigint, boolean); Type: PROCEDURE; Schema: vida_salud; Owner: -
--

CREATE PROCEDURE vida_salud.sp_confirmar_por_llamada(IN p_notificacion bigint, IN p_usuario bigint, IN p_exito boolean)
    LANGUAGE plpgsql
    AS $$
DECLARE v_cita bigint;
BEGIN
  UPDATE notificacion
     SET estado = CASE WHEN p_exito THEN 'ENVIADA' ELSE 'FALLIDA' END::estado_notificacion,
         id_usuario_gestion = p_usuario, fecha_envio = now(), intentos = intentos + 1
   WHERE id_notificacion = p_notificacion
  RETURNING id_cita INTO v_cita;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Notificación % inexistente', p_notificacion;
  END IF;
  IF p_exito THEN
    PERFORM set_config('app.id_usuario', p_usuario::text, true);
    UPDATE cita SET estado = 'CONFIRMADA' WHERE id_cita = v_cita AND estado = 'PROGRAMADA';
  END IF;
END $$;


--
-- Name: sp_desactivar_paciente(bigint, bigint); Type: FUNCTION; Schema: vida_salud; Owner: -
--

CREATE FUNCTION vida_salud.sp_desactivar_paciente(p_paciente bigint, p_usuario bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE v_n integer;
BEGIN
  PERFORM set_config('app.id_usuario', p_usuario::text, true);
  UPDATE persona SET activo = false WHERE id_persona = p_paciente;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Paciente % inexistente', p_paciente;
  END IF;
  UPDATE cita SET estado = 'CANCELADA', motivo_cancelacion = 'Paciente dado de baja'
   WHERE id_paciente = p_paciente AND fecha >= CURRENT_DATE
     AND estado IN ('PROGRAMADA', 'CONFIRMADA');
  GET DIAGNOSTICS v_n = ROW_COUNT;
  INSERT INTO bitacora (id_usuario, modulo, tipo_accion, tabla_afectada, id_registro_afectado, detalle)
  VALUES (p_usuario, 'P4 Gestión de Pacientes', 'MODIFICAR', 'persona', p_paciente,
          'Paciente desactivado; citas canceladas: ' || v_n);
  RETURN v_n;
END $$;


--
-- Name: sp_disponibilidad_medico(bigint, date); Type: FUNCTION; Schema: vida_salud; Owner: -
--

CREATE FUNCTION vida_salud.sp_disponibilidad_medico(p_medico bigint, p_fecha date) RETURNS TABLE(hora_inicio time without time zone, hora_fin time without time zone)
    LANGUAGE sql
    AS $$
  SELECT s::time, (s + make_interval(mins => h.duracion_bloque_min))::time
  FROM horario h
  CROSS JOIN LATERAL generate_series(p_fecha + h.hora_inicio,
        p_fecha + h.hora_fin - make_interval(mins => h.duracion_bloque_min),
        make_interval(mins => h.duracion_bloque_min)) AS s
  WHERE h.id_medico = p_medico AND h.activo
    AND h.dia_semana = EXTRACT(ISODOW FROM p_fecha)
    AND NOT EXISTS (SELECT 1 FROM bloqueo_agenda b
                    WHERE p_fecha BETWEEN b.fecha_inicio AND b.fecha_fin
                      AND (b.aplica_a_todos OR b.id_medico = p_medico))
    AND NOT EXISTS (SELECT 1 FROM cita c
                    WHERE c.id_medico = p_medico AND c.fecha = p_fecha
                      AND c.estado <> 'CANCELADA' AND c.hora_inicio = s::time)
  ORDER BY 1;
$$;


--
-- Name: sp_generar_lista_llamadas(date); Type: FUNCTION; Schema: vida_salud; Owner: -
--

CREATE FUNCTION vida_salud.sp_generar_lista_llamadas(p_fecha date) RETURNS TABLE(codigo character varying, paciente text, telefono character varying, medico text, hora time without time zone)
    LANGUAGE sql
    AS $$
  SELECT c.codigo, pp.nombres || ' ' || pp.apellidos, pp.telefono,
         pm.nombres || ' ' || pm.apellidos, c.hora_inicio
  FROM cita c
  JOIN persona pp ON pp.id_persona = c.id_paciente
  JOIN persona pm ON pm.id_persona = c.id_medico
  WHERE c.fecha = p_fecha AND c.estado = 'PROGRAMADA'
  ORDER BY c.hora_inicio;
$$;


--
-- Name: sp_programar_cita(bigint, bigint, bigint, bigint, date, time without time zone, character varying); Type: FUNCTION; Schema: vida_salud; Owner: -
--

CREATE FUNCTION vida_salud.sp_programar_cita(p_paciente bigint, p_medico bigint, p_especialidad bigint, p_usuario bigint, p_fecha date, p_hora time without time zone, p_motivo character varying) RETURNS character varying
    LANGUAGE plpgsql
    SET search_path TO 'vida_salud'
    AS $$
DECLARE
  v_dur smallint;
  v_fin time;
  v_codigo varchar(12);
  v_id bigint;
BEGIN
  -- 1. Validar que el paciente exista y esté activo (CU15)
  IF NOT EXISTS (
    SELECT 1 FROM paciente pac
    JOIN persona per ON per.id_persona = pac.id_persona
    WHERE pac.id_persona = p_paciente AND per.activo = true
  ) THEN
    RAISE EXCEPTION 'El paciente % no existe o se encuentra inactivo', p_paciente;
  END IF;

  -- 2. Validar que el médico esté activo (CU19) y atienda la especialidad (CU17)
  IF NOT EXISTS (
    SELECT 1 FROM medico_especialidad me
    JOIN persona per ON per.id_persona = me.id_medico
    WHERE me.id_medico = p_medico
      AND me.id_especialidad = p_especialidad
      AND per.activo = true
  ) THEN
    RAISE EXCEPTION 'El médico % no está activo o no atiende la especialidad %', p_medico, p_especialidad;
  END IF;

  -- 3. Validar horario del médico y que la cita entera quepa dentro del turno (CU18, CU20)
  SELECT duracion_bloque_min, p_hora + make_interval(mins => duracion_bloque_min)
    INTO v_dur, v_fin
    FROM horario
   WHERE id_medico = p_medico
     AND activo = true
     AND dia_semana = EXTRACT(ISODOW FROM p_fecha)
     AND p_hora >= hora_inicio
     AND (p_hora + make_interval(mins => duracion_bloque_min)) <= hora_fin
   LIMIT 1;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'La hora % del % está fuera del horario de atención del médico', p_hora, p_fecha;
  END IF;

  -- 4. Validar bloqueos de agenda por feriados o licencias (CU33)
  IF EXISTS (
    SELECT 1 FROM bloqueo_agenda
     WHERE p_fecha BETWEEN fecha_inicio AND fecha_fin
       AND (aplica_a_todos = true OR id_medico = p_medico)
  ) THEN
    RAISE EXCEPTION 'La agenda está bloqueada en la fecha %', p_fecha;
  END IF;

  -- 5. Validar superposición de citas para el médico o el paciente (CU22)
  IF EXISTS (
    SELECT 1 FROM cita
     WHERE estado <> 'CANCELADA'
       AND fecha = p_fecha
       AND (id_medico = p_medico OR id_paciente = p_paciente)
       AND hora_inicio < v_fin
       AND hora_fin > p_hora
  ) THEN
    RAISE EXCEPTION 'Cita duplicada: el médico o el paciente ya tiene una cita en ese horario';
  END IF;

  -- 6. Generar código correlativo CM-XXXX evitando condiciones de carrera
  LOCK TABLE cita IN SHARE ROW EXCLUSIVE MODE;
  SELECT 'CM-' || lpad((COALESCE(MAX(substr(codigo, 4)::int), 0) + 1)::text, 4, '0')
    INTO v_codigo
    FROM cita;

  -- 7. Insertar la cita (CU21)
  INSERT INTO cita (
    codigo, id_paciente, id_medico, id_especialidad, id_usuario_registro,
    fecha, hora_inicio, hora_fin, motivo_consulta
  )
  VALUES (
    v_codigo, p_paciente, p_medico, p_especialidad, p_usuario,
    p_fecha, p_hora, v_fin, p_motivo
  )
  RETURNING id_cita INTO v_id;

  -- 8. Registrar estado inicial en el historial (CU25)
  INSERT INTO historial_estado_cita (
    id_cita, id_usuario, estado_anterior, estado_nuevo, motivo
  )
  VALUES (
    v_id, p_usuario, NULL, 'PROGRAMADA', 'Registro de la cita (CU21)'
  );

  -- 9. Registrar acción en bitácora (CU10)
  INSERT INTO bitacora (
    id_usuario, modulo, tipo_accion, tabla_afectada, id_registro_afectado, detalle
  )
  VALUES (
    p_usuario, 'P6 Gestión de Citas', 'CREAR', 'cita', v_id,
    'Programación de cita ' || v_codigo || ' para fecha ' || p_fecha || ' ' || p_hora
  );

  RETURN v_codigo;
END $$;


--
-- Name: sp_registrar_atencion(bigint, bigint, text); Type: PROCEDURE; Schema: vida_salud; Owner: -
--

CREATE PROCEDURE vida_salud.sp_registrar_atencion(IN p_cita bigint, IN p_usuario bigint, IN p_observacion text)
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.id_usuario', p_usuario::text, true);
  UPDATE cita SET estado = 'ATENDIDA', observacion_atencion = p_observacion,
                  fecha_hora_atencion = now()
   WHERE id_cita = p_cita AND estado IN ('PROGRAMADA', 'CONFIRMADA');
  IF NOT FOUND THEN
    RAISE EXCEPTION 'La cita % no está pendiente de atención', p_cita;
  END IF;
END $$;


--
-- Name: sp_reprogramar_cita(bigint, bigint, date, time without time zone); Type: FUNCTION; Schema: vida_salud; Owner: -
--

CREATE FUNCTION vida_salud.sp_reprogramar_cita(p_cita bigint, p_usuario bigint, p_fecha date, p_hora time without time zone) RETURNS character varying
    LANGUAGE plpgsql
    SET search_path TO 'vida_salud'
    AS $$
DECLARE
  r cita%ROWTYPE;
  v_codigo varchar(12);
  v_id_nueva bigint;
BEGIN
  -- 1. Obtener la cita original y bloquear la fila (solo PROGRAMADA o CONFIRMADA)
  SELECT * INTO r
    FROM cita
   WHERE id_cita = p_cita
     AND estado IN ('PROGRAMADA', 'CONFIRMADA')
     FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'La cita % no existe o no puede reprogramarse en su estado actual', p_cita;
  END IF;

  -- 2. Evitar reprogramar a la misma fecha y hora que ya tenía
  IF r.fecha = p_fecha AND r.hora_inicio = p_hora THEN
    RAISE EXCEPTION 'La nueva fecha y hora deben ser distintas a las de la cita actual (% %)', r.fecha, r.hora_inicio;
  END IF;

  -- 3. Cancelar la cita original (libera el bloque y registra en historial/bitácora)
  CALL vida_salud.sp_cancelar_cita(
    p_cita,
    p_usuario,
    'Reprogramada al ' || p_fecha || ' a las ' || p_hora
  );

  -- 4. Guardar fecha_anterior y hora_anterior en el historial de la cita original (CU23)
  UPDATE historial_estado_cita
     SET fecha_anterior = r.fecha,
         hora_anterior  = r.hora_inicio
   WHERE id_cita = p_cita
     AND estado_nuevo = 'CANCELADA';

  -- 5. Programar la nueva cita (valida horario, bloqueos y colisiones; si falla, hace rollback de todo)
  v_codigo := vida_salud.sp_programar_cita(
    r.id_paciente,
    r.id_medico,
    r.id_especialidad,
    p_usuario,
    p_fecha,
    p_hora,
    r.motivo_consulta
  );

  -- 6. Enlazar la nueva cita con la cita origen (autoasociación reprogramadaDe - CU23)
  UPDATE cita
     SET id_cita_origen = p_cita
   WHERE codigo = v_codigo
   RETURNING id_cita INTO v_id_nueva;

  -- 7. Dejar constancia de la fecha/hora original también en el historial inicial de la nueva cita
  UPDATE historial_estado_cita
     SET fecha_anterior = r.fecha,
         hora_anterior  = r.hora_inicio,
         motivo         = 'Reprogramada desde cita ' || r.codigo || ' (CU23)'
   WHERE id_cita = v_id_nueva
     AND estado_anterior IS NULL;

  RETURN v_codigo;
END $$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bitacora; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.bitacora (
    id_bitacora bigint NOT NULL,
    id_usuario bigint,
    modulo character varying(50) NOT NULL,
    tipo_accion vida_salud.tipo_accion NOT NULL,
    tabla_afectada character varying(50),
    id_registro_afectado bigint,
    descripcion character varying(255),
    detalle_anterior jsonb,
    detalle_nuevo jsonb,
    direccion_ip character varying(45),
    navegador character varying(200),
    fecha_hora timestamp with time zone DEFAULT now() NOT NULL,
    detalle text,
    ip character varying(45)
);


--
-- Name: bitacora_id_bitacora_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

ALTER TABLE vida_salud.bitacora ALTER COLUMN id_bitacora ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME vida_salud.bitacora_id_bitacora_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: bloqueo_agenda; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.bloqueo_agenda (
    id_bloqueo bigint NOT NULL,
    id_medico bigint,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL,
    motivo character varying(200) NOT NULL,
    tipo_bloqueo vida_salud.tipo_bloqueo,
    tipo vida_salud.tipo_bloqueo,
    aplica_a_todos boolean DEFAULT false NOT NULL,
    CONSTRAINT bloqueo_fechas_check CHECK ((fecha_fin >= fecha_inicio))
);


--
-- Name: bloqueo_agenda_id_bloqueo_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

ALTER TABLE vida_salud.bloqueo_agenda ALTER COLUMN id_bloqueo ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME vida_salud.bloqueo_agenda_id_bloqueo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cache; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.cache (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    expiration bigint NOT NULL
);


--
-- Name: cache_locks; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.cache_locks (
    key character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    expiration bigint NOT NULL
);


--
-- Name: cita; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.cita (
    id_cita bigint NOT NULL,
    codigo character varying(20) NOT NULL,
    id_paciente bigint NOT NULL,
    id_medico bigint NOT NULL,
    id_especialidad bigint NOT NULL,
    id_usuario_registro bigint NOT NULL,
    id_cita_origen bigint,
    fecha date NOT NULL,
    hora_inicio time without time zone NOT NULL,
    hora_fin time without time zone NOT NULL,
    estado vida_salud.estado_cita DEFAULT 'PROGRAMADA'::vida_salud.estado_cita NOT NULL,
    origen character varying(20) DEFAULT 'WEB'::character varying NOT NULL,
    motivo_consulta character varying(200),
    motivo_cancelacion character varying(200),
    observacion_atencion text,
    observaciones_atencion text,
    fecha_hora_atencion timestamp with time zone,
    expira_en timestamp with time zone,
    fecha_creacion timestamp with time zone DEFAULT now() NOT NULL,
    fecha_registro timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT cita_horas_check CHECK ((hora_fin > hora_inicio))
);


--
-- Name: cita_id_cita_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

ALTER TABLE vida_salud.cita ALTER COLUMN id_cita ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME vida_salud.cita_id_cita_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: comprobante_pago; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.comprobante_pago (
    id_comprobante bigint NOT NULL,
    id_pago bigint NOT NULL,
    numero character varying(50) NOT NULL,
    fecha_emision timestamp with time zone DEFAULT now() NOT NULL,
    monto_total numeric(10,2) NOT NULL,
    ruta_archivo character varying(255)
);


--
-- Name: comprobante_pago_id_comprobante_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

ALTER TABLE vida_salud.comprobante_pago ALTER COLUMN id_comprobante ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME vida_salud.comprobante_pago_id_comprobante_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: contacto_emergencia; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.contacto_emergencia (
    id_contacto bigint NOT NULL,
    id_paciente bigint NOT NULL,
    nombre character varying(100),
    parentesco character varying(50) NOT NULL,
    telefono character varying(20) NOT NULL,
    nombre_completo character varying(120)
);


--
-- Name: contacto_emergencia_id_contacto_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

ALTER TABLE vida_salud.contacto_emergencia ALTER COLUMN id_contacto ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME vida_salud.contacto_emergencia_id_contacto_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: especialidad; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.especialidad (
    id_especialidad bigint NOT NULL,
    nombre character varying(80) NOT NULL,
    descripcion character varying(255),
    costo numeric(10,2) DEFAULT 120.00 NOT NULL,
    activo boolean DEFAULT true NOT NULL
);


--
-- Name: especialidad_id_especialidad_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

ALTER TABLE vida_salud.especialidad ALTER COLUMN id_especialidad ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME vida_salud.especialidad_id_especialidad_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: failed_jobs; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection character varying(255) NOT NULL,
    queue character varying(255) NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

CREATE SEQUENCE vida_salud.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: vida_salud; Owner: -
--

ALTER SEQUENCE vida_salud.failed_jobs_id_seq OWNED BY vida_salud.failed_jobs.id;


--
-- Name: historial_estado_cita; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.historial_estado_cita (
    id_historial bigint NOT NULL,
    id_cita bigint NOT NULL,
    id_usuario bigint NOT NULL,
    estado_anterior vida_salud.estado_cita,
    estado_nuevo vida_salud.estado_cita NOT NULL,
    motivo character varying(200),
    fecha_cambio timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: historial_estado_cita_id_historial_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

ALTER TABLE vida_salud.historial_estado_cita ALTER COLUMN id_historial ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME vida_salud.historial_estado_cita_id_historial_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: horario; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.horario (
    id_horario bigint NOT NULL,
    id_medico bigint NOT NULL,
    dia_semana smallint NOT NULL,
    hora_inicio time without time zone NOT NULL,
    hora_fin time without time zone NOT NULL,
    duracion_bloque_min smallint DEFAULT 15 NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    CONSTRAINT horario_dia_check CHECK (((dia_semana >= 1) AND (dia_semana <= 7))),
    CONSTRAINT horario_rango_check CHECK ((hora_fin > hora_inicio))
);


--
-- Name: horario_id_horario_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

ALTER TABLE vida_salud.horario ALTER COLUMN id_horario ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME vida_salud.horario_id_horario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: informacion_medica; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.informacion_medica (
    id_info_medica bigint NOT NULL,
    id_paciente bigint NOT NULL,
    grupo_sanguineo character varying(5),
    alergias text,
    antecedentes text,
    id_informacion bigint NOT NULL,
    tipo_sangre character varying(10),
    enfermedades_cronicas text,
    medicamentos_habituales text,
    antecedentes_relevantes text,
    observaciones text,
    fecha_actualizacion timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: informacion_medica_id_info_medica_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

ALTER TABLE vida_salud.informacion_medica ALTER COLUMN id_info_medica ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME vida_salud.informacion_medica_id_info_medica_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: informacion_medica_id_informacion_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

CREATE SEQUENCE vida_salud.informacion_medica_id_informacion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: informacion_medica_id_informacion_seq; Type: SEQUENCE OWNED BY; Schema: vida_salud; Owner: -
--

ALTER SEQUENCE vida_salud.informacion_medica_id_informacion_seq OWNED BY vida_salud.informacion_medica.id_informacion;


--
-- Name: job_batches; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.job_batches (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    total_jobs integer NOT NULL,
    pending_jobs integer NOT NULL,
    failed_jobs integer NOT NULL,
    failed_job_ids text NOT NULL,
    options text,
    cancelled_at integer,
    created_at integer NOT NULL,
    finished_at integer
);


--
-- Name: jobs; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.jobs (
    id bigint NOT NULL,
    queue character varying(255) NOT NULL,
    payload text NOT NULL,
    attempts smallint NOT NULL,
    reserved_at integer,
    available_at integer NOT NULL,
    created_at integer NOT NULL
);


--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

CREATE SEQUENCE vida_salud.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: vida_salud; Owner: -
--

ALTER SEQUENCE vida_salud.jobs_id_seq OWNED BY vida_salud.jobs.id;


--
-- Name: medico; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.medico (
    id_persona bigint NOT NULL,
    codigo character varying(20) NOT NULL,
    matricula character varying(30) NOT NULL,
    activo boolean DEFAULT true NOT NULL
);


--
-- Name: medico_especialidad; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.medico_especialidad (
    id_medico bigint NOT NULL,
    id_especialidad bigint NOT NULL
);


--
-- Name: migrations; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

CREATE SEQUENCE vida_salud.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: vida_salud; Owner: -
--

ALTER SEQUENCE vida_salud.migrations_id_seq OWNED BY vida_salud.migrations.id;


--
-- Name: notificacion; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.notificacion (
    id_notificacion bigint NOT NULL,
    id_cita bigint NOT NULL,
    id_usuario_gestion bigint,
    tipo_canal character varying(20) DEFAULT 'EMAIL'::character varying NOT NULL,
    destinatario character varying(150),
    mensaje text NOT NULL,
    fecha_programada timestamp with time zone NOT NULL,
    fecha_envio timestamp with time zone,
    estado vida_salud.estado_notificacion DEFAULT 'PENDIENTE'::vida_salud.estado_notificacion NOT NULL,
    intentos smallint DEFAULT 0 NOT NULL
);


--
-- Name: notificacion_id_notificacion_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

ALTER TABLE vida_salud.notificacion ALTER COLUMN id_notificacion ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME vida_salud.notificacion_id_notificacion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: paciente; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.paciente (
    id_persona bigint NOT NULL,
    codigo character varying(20) NOT NULL,
    sexo character(1) NOT NULL,
    fecha_nacimiento date NOT NULL,
    direccion character varying(200),
    fecha_registro timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT paciente_sexo_check CHECK ((sexo = ANY (ARRAY['M'::bpchar, 'F'::bpchar, 'O'::bpchar])))
);


--
-- Name: pago; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.pago (
    id_pago bigint NOT NULL,
    id_cita bigint NOT NULL,
    id_usuario_registro bigint,
    monto numeric(10,2) NOT NULL,
    moneda character varying(3) DEFAULT 'BOB'::character varying NOT NULL,
    metodo character varying(30) DEFAULT 'QR'::character varying NOT NULL,
    estado character varying(20) DEFAULT 'APROBADO'::character varying NOT NULL,
    referencia_externa character varying(100),
    nit_ci character varying(30),
    fecha_hora timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: pago_id_pago_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

ALTER TABLE vida_salud.pago ALTER COLUMN id_pago ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME vida_salud.pago_id_pago_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: password_reset_tokens; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


--
-- Name: permiso; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.permiso (
    id_permiso bigint NOT NULL,
    nombre character varying(80) NOT NULL,
    descripcion character varying(200),
    modulo character varying(50) NOT NULL,
    ruta_menu character varying(150)
);


--
-- Name: permiso_id_permiso_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

ALTER TABLE vida_salud.permiso ALTER COLUMN id_permiso ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME vida_salud.permiso_id_permiso_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: persona; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.persona (
    id_persona bigint NOT NULL,
    ci character varying(20) NOT NULL,
    nombres character varying(80) NOT NULL,
    apellidos character varying(80) NOT NULL,
    telefono character varying(20),
    email character varying(150),
    activo boolean DEFAULT true NOT NULL,
    fecha_registro timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: persona_id_persona_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

ALTER TABLE vida_salud.persona ALTER COLUMN id_persona ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME vida_salud.persona_id_persona_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: personal_administrativo; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.personal_administrativo (
    id_persona bigint NOT NULL,
    cargo character varying(80) NOT NULL
);


--
-- Name: recuperacion_contrasena; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.recuperacion_contrasena (
    id_recuperacion bigint NOT NULL,
    id_usuario bigint NOT NULL,
    token_hash character varying(255) NOT NULL,
    fecha_generacion timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_expiracion timestamp(0) without time zone NOT NULL,
    usado boolean DEFAULT false NOT NULL
);


--
-- Name: recuperacion_contrasena_id_recuperacion_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

CREATE SEQUENCE vida_salud.recuperacion_contrasena_id_recuperacion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recuperacion_contrasena_id_recuperacion_seq; Type: SEQUENCE OWNED BY; Schema: vida_salud; Owner: -
--

ALTER SEQUENCE vida_salud.recuperacion_contrasena_id_recuperacion_seq OWNED BY vida_salud.recuperacion_contrasena.id_recuperacion;


--
-- Name: reembolso; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.reembolso (
    id_reembolso bigint NOT NULL,
    id_pago bigint NOT NULL,
    id_usuario_autoriza bigint,
    monto numeric(10,2) NOT NULL,
    motivo character varying(255) NOT NULL,
    fecha_hora timestamp with time zone DEFAULT now() NOT NULL,
    estado character varying(20) DEFAULT 'COMPLETADO'::character varying NOT NULL
);


--
-- Name: reembolso_id_reembolso_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

ALTER TABLE vida_salud.reembolso ALTER COLUMN id_reembolso ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME vida_salud.reembolso_id_reembolso_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: reporte; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.reporte (
    id_reporte bigint NOT NULL,
    id_usuario_generador bigint,
    tipo_reporte vida_salud.tipo_reporte,
    formato character varying(10) DEFAULT 'PDF'::character varying NOT NULL,
    parametros jsonb,
    fecha_generacion timestamp with time zone DEFAULT now() NOT NULL,
    ruta_archivo character varying(255),
    id_usuario bigint,
    tipo vida_salud.tipo_reporte,
    fecha_desde date,
    fecha_hasta date,
    filtros jsonb
);


--
-- Name: reporte_id_reporte_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

ALTER TABLE vida_salud.reporte ALTER COLUMN id_reporte ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME vida_salud.reporte_id_reporte_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: rol; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.rol (
    id_rol bigint NOT NULL,
    nombre character varying(50) NOT NULL,
    descripcion character varying(200)
);


--
-- Name: rol_id_rol_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

ALTER TABLE vida_salud.rol ALTER COLUMN id_rol ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME vida_salud.rol_id_rol_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: rol_permiso; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.rol_permiso (
    id_rol bigint NOT NULL,
    id_permiso bigint NOT NULL
);


--
-- Name: sesion; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.sesion (
    id_sesion character varying(80) NOT NULL,
    id_usuario bigint NOT NULL,
    ip_address character varying(45),
    user_agent text,
    payload text,
    activa boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    fecha_inicio timestamp with time zone DEFAULT now() NOT NULL,
    ultima_actividad timestamp with time zone DEFAULT now() NOT NULL,
    fecha_cierre timestamp with time zone,
    ip character varying(45)
);


--
-- Name: sessions; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.sessions (
    id character varying(255) NOT NULL,
    user_id bigint,
    ip_address character varying(45),
    user_agent text,
    payload text NOT NULL,
    last_activity integer NOT NULL
);


--
-- Name: token_recuperacion; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.token_recuperacion (
    id_token bigint NOT NULL,
    id_usuario bigint NOT NULL,
    token_hash character varying(64) NOT NULL,
    fecha_generacion timestamp with time zone DEFAULT now() NOT NULL,
    fecha_expiracion timestamp with time zone NOT NULL,
    usado boolean DEFAULT false NOT NULL
);


--
-- Name: token_recuperacion_id_token_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

ALTER TABLE vida_salud.token_recuperacion ALTER COLUMN id_token ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME vida_salud.token_recuperacion_id_token_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.users (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

CREATE SEQUENCE vida_salud.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: vida_salud; Owner: -
--

ALTER SEQUENCE vida_salud.users_id_seq OWNED BY vida_salud.users.id;


--
-- Name: usuario; Type: TABLE; Schema: vida_salud; Owner: -
--

CREATE TABLE vida_salud.usuario (
    id_usuario bigint NOT NULL,
    id_persona bigint NOT NULL,
    id_rol bigint NOT NULL,
    nombre_usuario character varying(50) NOT NULL,
    hash_contrasena character varying(255) NOT NULL,
    estado vida_salud.estado_usuario DEFAULT 'ACTIVO'::vida_salud.estado_usuario NOT NULL,
    intentos_fallidos smallint DEFAULT 0 NOT NULL,
    bloqueado_hasta timestamp with time zone,
    fecha_bloqueo timestamp with time zone,
    ultimo_acceso timestamp with time zone,
    fecha_creacion timestamp with time zone DEFAULT now() NOT NULL,
    remember_token character varying(100),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE; Schema: vida_salud; Owner: -
--

ALTER TABLE vida_salud.usuario ALTER COLUMN id_usuario ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME vida_salud.usuario_id_usuario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: failed_jobs id; Type: DEFAULT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.failed_jobs ALTER COLUMN id SET DEFAULT nextval('vida_salud.failed_jobs_id_seq'::regclass);


--
-- Name: informacion_medica id_informacion; Type: DEFAULT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.informacion_medica ALTER COLUMN id_informacion SET DEFAULT nextval('vida_salud.informacion_medica_id_informacion_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.jobs ALTER COLUMN id SET DEFAULT nextval('vida_salud.jobs_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.migrations ALTER COLUMN id SET DEFAULT nextval('vida_salud.migrations_id_seq'::regclass);


--
-- Name: recuperacion_contrasena id_recuperacion; Type: DEFAULT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.recuperacion_contrasena ALTER COLUMN id_recuperacion SET DEFAULT nextval('vida_salud.recuperacion_contrasena_id_recuperacion_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.users ALTER COLUMN id SET DEFAULT nextval('vida_salud.users_id_seq'::regclass);


--
-- Data for Name: bitacora; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.bitacora (id_bitacora, id_usuario, modulo, tipo_accion, tabla_afectada, id_registro_afectado, descripcion, detalle_anterior, detalle_nuevo, direccion_ip, navegador, fecha_hora, detalle, ip) VALUES (1, 1, 'P1_SEGURIDAD', 'LOGIN', 'usuario', 1, NULL, NULL, NULL, NULL, NULL, '2026-11-09 03:11:26+00', 'Inicio de sesión inicial del sistema', '127.0.0.1');
INSERT INTO vida_salud.bitacora (id_bitacora, id_usuario, modulo, tipo_accion, tabla_afectada, id_registro_afectado, descripcion, detalle_anterior, detalle_nuevo, direccion_ip, navegador, fecha_hora, detalle, ip) VALUES (2, 2, 'P1_SEGURIDAD', 'LOGIN', 'usuario', 2, 'Inicio de sesión: rrivero (ADMINISTRADOR) - 09/11/2026 15:46:58', NULL, NULL, NULL, 'Google Chrome', '2026-11-09 19:46:58+00', 'Inicio de sesión exitoso en la plataforma web. Usuario: [rrivero] (Ronald Rivero Fernandez), Rol: [ADMINISTRADOR], Hora: [09/11/2026 15:46:58].', '127.0.0.1');
INSERT INTO vida_salud.bitacora (id_bitacora, id_usuario, modulo, tipo_accion, tabla_afectada, id_registro_afectado, descripcion, detalle_anterior, detalle_nuevo, direccion_ip, navegador, fecha_hora, detalle, ip) VALUES (3, 2, 'P1_SEGURIDAD', 'LOGOUT', 'usuario', 2, 'Cierre de sesión: rrivero (ADMINISTRADOR) - 09/11/2026 15:47:48', NULL, NULL, NULL, 'Google Chrome', '2026-11-09 19:47:48+00', 'Cierre de sesión y revocación exitosa del usuario [rrivero] (Rol: [ADMINISTRADOR], inicio: 09/11/2026 15:46:58, cierre: 09/11/2026 15:47:48, duración: 50.285463 segundos).', '127.0.0.1');


--
-- Data for Name: bloqueo_agenda; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.bloqueo_agenda (id_bloqueo, id_medico, fecha_inicio, fecha_fin, motivo, tipo_bloqueo, tipo, aplica_a_todos) VALUES (2, NULL, '2026-09-24', '2026-09-24', 'Aniversario de Santa Cruz', NULL, 'FERIADO', true);
INSERT INTO vida_salud.bloqueo_agenda (id_bloqueo, id_medico, fecha_inicio, fecha_fin, motivo, tipo_bloqueo, tipo, aplica_a_todos) VALUES (3, NULL, '2026-11-02', '2026-11-02', 'Día de Todos los Difuntos', NULL, 'FERIADO', true);


--
-- Data for Name: cita; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.cita (id_cita, codigo, id_paciente, id_medico, id_especialidad, id_usuario_registro, id_cita_origen, fecha, hora_inicio, hora_fin, estado, origen, motivo_consulta, motivo_cancelacion, observacion_atencion, observaciones_atencion, fecha_hora_atencion, expira_en, fecha_creacion, fecha_registro) VALUES (2, 'CM-0001', 21, 10, 1, 4, NULL, '2026-10-19', '08:00:00', '08:30:00', 'ATENDIDA', 'WEB', 'Control médico general preventivo', NULL, 'Signos vitales normales. Se indica control anual.', NULL, '2026-10-19 12:25:00+00', NULL, '2026-10-15 14:00:00+00', '2026-11-09 03:10:26.736327+00');


--
-- Data for Name: comprobante_pago; Type: TABLE DATA; Schema: vida_salud; Owner: -
--



--
-- Data for Name: contacto_emergencia; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (2, 21, NULL, 'Padre', '75001122', 'Carlos Égüez');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (3, 22, NULL, 'Madre', '71003344', 'Lucía Mendoza');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (4, 24, NULL, 'Madre', '72111000', 'Silvia Suárez Suárez');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (5, 25, NULL, 'Madre', '77473302', 'Fernando Quispe Barba');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (6, 26, NULL, 'Madre', '73861775', 'Daniel Montero Égüez');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (7, 27, NULL, 'Madre', '78271802', 'Ronald Peña Roca');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (8, 28, NULL, 'Madre', '79196542', 'María Gutiérrez Paz');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (9, 29, NULL, 'Madre', '71694910', 'José Antelo Mamani');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (10, 30, NULL, 'Madre', '76456771', 'Diego Montero Áñez');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (11, 31, NULL, 'Madre', '79663999', 'Juan Terceros Flores');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (12, 32, NULL, 'Madre', '76976300', 'Fernando Moreno Parada');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (13, 33, NULL, 'Madre', '74219398', 'Daniela Barba Montero');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (14, 34, NULL, 'Madre', '79496229', 'Pablo Suárez Terceros');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (15, 35, NULL, 'Madre', '77524049', 'Patricia Moreno Mendoza');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (16, 36, NULL, 'Madre', '72446242', 'Fernanda Arteaga Antelo');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (17, 37, NULL, 'Madre', '78705249', 'Patricia Parada Antelo');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (18, 38, NULL, 'Madre', '78422837', 'Gabriela Durán Rojas');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (19, 23, NULL, 'Esposo(a)', '73963116', 'Marcelo Terceros Durán');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (20, 39, NULL, 'Esposo(a)', '74725857', 'Andrea Roca Barba');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (21, 40, NULL, 'Esposo(a)', '75917681', 'Ronald Durán Durán');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (22, 41, NULL, 'Esposo(a)', '76534421', 'Rosa Peña Moreno');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (23, 42, NULL, 'Esposo(a)', '75694707', 'Camila Quispe Mamani');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (24, 43, NULL, 'Esposo(a)', '71115806', 'Marcelo Quispe Quispe');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (25, 44, NULL, 'Esposo(a)', '73754149', 'Lucía Salvatierra Barba');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (26, 45, NULL, 'Esposo(a)', '76990426', 'Miguel Antelo Rivero');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (27, 46, NULL, 'Esposo(a)', '77400199', 'Juan Égüez Vaca');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (28, 47, NULL, 'Esposo(a)', '75537042', 'Juan Gutiérrez Saucedo');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (29, 48, NULL, 'Esposo(a)', '74773573', 'Jorge Vaca Salvatierra');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (30, 49, NULL, 'Esposo(a)', '79758854', 'Pablo Suárez Choque');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (31, 50, NULL, 'Esposo(a)', '74546700', 'Lucía Parada Chávez');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (32, 51, NULL, 'Esposo(a)', '79927506', 'María Salvatierra Chávez');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (33, 52, NULL, 'Esposo(a)', '71109076', 'Fernanda Mendoza Parada');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (34, 53, NULL, 'Esposo(a)', '72628684', 'Patricia Chávez Suárez');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (35, 54, NULL, 'Esposo(a)', '77941861', 'Noelia Peña Ribera');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (36, 55, NULL, 'Esposo(a)', '72968375', 'Gabriela Chávez Áñez');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (37, 56, NULL, 'Esposo(a)', '70442957', 'Ricardo Rojas Mamani');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (38, 57, NULL, 'Esposo(a)', '70266006', 'Gabriela Mamani Paz');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (39, 58, NULL, 'Esposo(a)', '74646708', 'Edwin Cuéllar Antelo');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (40, 59, NULL, 'Esposo(a)', '72409906', 'Andrea Vaca Durán');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (41, 60, NULL, 'Esposo(a)', '77230433', 'Paola Cuéllar Antelo');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (42, 61, NULL, 'Esposo(a)', '74244198', 'Paola Rojas Gutiérrez');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (43, 62, NULL, 'Esposo(a)', '78158679', 'Jorge Quispe Choque');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (44, 63, NULL, 'Esposo(a)', '71372149', 'Diego Melgar Roca');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (45, 64, NULL, 'Esposo(a)', '72108131', 'Patricia Mamani Chávez');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (46, 65, NULL, 'Esposo(a)', '71754170', 'Iván Mendoza Choque');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (47, 66, NULL, 'Esposo(a)', '78632265', 'Edwin Moreno Salvatierra');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (48, 67, NULL, 'Esposo(a)', '72183045', 'Ronald Terceros Durán');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (49, 68, NULL, 'Esposo(a)', '74717978', 'Andrea Antelo Durán');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (50, 69, NULL, 'Esposo(a)', '78499158', 'Luis Ribera Chávez');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (51, 70, NULL, 'Esposo(a)', '75634333', 'Andrea Saucedo Salvatierra');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (52, 71, NULL, 'Esposo(a)', '73669369', 'Edwin Mamani Durán');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (53, 72, NULL, 'Esposo(a)', '76326669', 'Jimena Barba Suárez');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (54, 73, NULL, 'Esposo(a)', '70762435', 'Mariela Flores Mamani');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (55, 74, NULL, 'Esposo(a)', '74521540', 'Noelia Justiniano Mendoza');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (56, 75, NULL, 'Esposo(a)', '74565143', 'Ana Terceros Vaca');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (57, 76, NULL, 'Esposo(a)', '78805965', 'Gustavo Durán Montero');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (58, 77, NULL, 'Esposo(a)', '79395278', 'Mónica Ribera Durán');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (59, 78, NULL, 'Esposo(a)', '73877488', 'María Moreno Rivero');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (60, 79, NULL, 'Esposo(a)', '76123670', 'Verónica Melgar Justiniano');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (61, 80, NULL, 'Esposo(a)', '79880395', 'Ricardo Rojas Barba');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (62, 81, NULL, 'Esposo(a)', '79610461', 'Mariela Montero Melgar');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (63, 82, NULL, 'Esposo(a)', '75456347', 'Carlos Quispe Peña');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (64, 83, NULL, 'Esposo(a)', '77852775', 'Juan Cuéllar Flores');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (65, 84, NULL, 'Esposo(a)', '73824184', 'Ronald Áñez Roca');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (66, 85, NULL, 'Esposo(a)', '77614243', 'Pablo Barba Ribera');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (67, 86, NULL, 'Esposo(a)', '76535335', 'Hugo Parada Roca');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (68, 87, NULL, 'Esposo(a)', '73490246', 'Gustavo Parada Chávez');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (69, 88, NULL, 'Esposo(a)', '79619362', 'Ronald Salvatierra Chávez');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (70, 89, NULL, 'Esposo(a)', '73969548', 'Sofía Salvatierra Paz');
INSERT INTO vida_salud.contacto_emergencia (id_contacto, id_paciente, nombre, parentesco, telefono, nombre_completo) VALUES (71, 90, NULL, 'Esposo(a)', '77196965', 'Álvaro Quispe Ribera');


--
-- Data for Name: especialidad; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.especialidad (id_especialidad, nombre, descripcion, costo, activo) VALUES (6, 'Dermatología', 'Tratamiento de afecciones cutáneas y capilares', 190.00, true);
INSERT INTO vida_salud.especialidad (id_especialidad, nombre, descripcion, costo, activo) VALUES (7, 'Traumatología y Ortopedia', 'Manejo de lesiones del sistema musculoesquelético', 200.00, true);
INSERT INTO vida_salud.especialidad (id_especialidad, nombre, descripcion, costo, activo) VALUES (8, 'Cardiología Pediátrica', 'Cardiopatías congénitas y evaluación infantil', 250.00, true);
INSERT INTO vida_salud.especialidad (id_especialidad, nombre, descripcion, costo, activo) VALUES (9, 'Neurología', 'Enfermedades del sistema nervioso central y periférico', 260.00, true);
INSERT INTO vida_salud.especialidad (id_especialidad, nombre, descripcion, costo, activo) VALUES (10, 'Oftalmología', 'Cuidado y patología de la visión', 180.00, true);
INSERT INTO vida_salud.especialidad (id_especialidad, nombre, descripcion, costo, activo) VALUES (11, 'Otorrinolaringología', 'Enfermedades del oído, nariz y garganta', 190.00, true);
INSERT INTO vida_salud.especialidad (id_especialidad, nombre, descripcion, costo, activo) VALUES (12, 'Gastroenterología', 'Patologías del aparato digestivo e hígado', 210.00, true);
INSERT INTO vida_salud.especialidad (id_especialidad, nombre, descripcion, costo, activo) VALUES (13, 'Urología', 'Vías urinarias y sistema reproductor masculino', 210.00, true);
INSERT INTO vida_salud.especialidad (id_especialidad, nombre, descripcion, costo, activo) VALUES (14, 'Endocrinología', 'Trastornos hormonales y metabólicos', 220.00, true);
INSERT INTO vida_salud.especialidad (id_especialidad, nombre, descripcion, costo, activo) VALUES (15, 'Neumología', 'Enfermedades respiratorias y pulmonares', 200.00, true);
INSERT INTO vida_salud.especialidad (id_especialidad, nombre, descripcion, costo, activo) VALUES (16, 'Psiquiatría', 'Salud mental y trastornos del comportamiento', 250.00, true);
INSERT INTO vida_salud.especialidad (id_especialidad, nombre, descripcion, costo, activo) VALUES (1, 'Medicina General', 'Atención primaria y diagnóstico integral', 120.00, true);
INSERT INTO vida_salud.especialidad (id_especialidad, nombre, descripcion, costo, activo) VALUES (2, 'Pediatría', 'Atención médica integral infantil y adolescente', 150.00, true);
INSERT INTO vida_salud.especialidad (id_especialidad, nombre, descripcion, costo, activo) VALUES (3, 'Ginecología', 'Salud femenina, reproductiva y prenatal', 180.00, true);
INSERT INTO vida_salud.especialidad (id_especialidad, nombre, descripcion, costo, activo) VALUES (4, 'Odontología', 'Salud bucal y tratamientos odontológicos', 140.00, true);
INSERT INTO vida_salud.especialidad (id_especialidad, nombre, descripcion, costo, activo) VALUES (5, 'Cardiología', 'Diagnóstico y tratamiento cardiovascular', 220.00, true);


--
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: vida_salud; Owner: -
--



--
-- Data for Name: historial_estado_cita; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.historial_estado_cita (id_historial, id_cita, id_usuario, estado_anterior, estado_nuevo, motivo, fecha_cambio) VALUES (1, 2, 4, NULL, 'PROGRAMADA', 'Registro inicial de cita médica', '2026-10-15 14:00:00+00');


--
-- Data for Name: horario; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (55, 91, 5, '14:00:00', '18:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (56, 92, 1, '14:00:00', '18:30:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (57, 92, 2, '14:00:00', '18:30:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (58, 92, 3, '14:00:00', '18:30:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (59, 92, 4, '14:00:00', '18:30:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (60, 92, 5, '14:00:00', '18:30:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (61, 93, 1, '14:30:00', '18:30:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (62, 93, 2, '14:30:00', '18:30:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (63, 93, 3, '14:30:00', '18:30:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (64, 93, 4, '14:30:00', '18:30:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (65, 93, 5, '14:30:00', '18:30:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (66, 94, 1, '15:00:00', '19:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (67, 94, 2, '15:00:00', '19:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (68, 94, 3, '15:00:00', '19:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (69, 94, 4, '15:00:00', '19:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (70, 94, 5, '15:00:00', '19:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (71, 95, 1, '08:30:00', '12:30:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (72, 95, 2, '08:30:00', '12:30:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (73, 95, 3, '08:30:00', '12:30:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (74, 95, 4, '08:30:00', '12:30:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (75, 95, 5, '08:30:00', '12:30:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (76, 96, 1, '14:00:00', '18:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (77, 96, 2, '14:00:00', '18:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (78, 96, 3, '14:00:00', '18:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (79, 96, 4, '14:00:00', '18:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (80, 96, 5, '14:00:00', '18:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (81, 97, 1, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (82, 97, 2, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (83, 97, 3, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (84, 97, 4, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (85, 97, 5, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (86, 98, 1, '14:00:00', '18:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (87, 98, 2, '14:00:00', '18:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (1, 10, 1, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (11, 10, 2, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (12, 10, 3, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (13, 10, 4, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (14, 10, 5, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (2, 11, 1, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (15, 11, 2, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (16, 11, 3, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (17, 11, 4, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (18, 11, 5, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (3, 12, 1, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (19, 12, 2, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (20, 12, 3, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (21, 12, 4, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (22, 12, 5, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (4, 13, 1, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (23, 13, 2, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (24, 13, 3, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (25, 13, 4, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (26, 13, 5, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (5, 14, 1, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (27, 14, 2, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (28, 14, 3, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (29, 14, 4, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (30, 14, 5, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (6, 15, 1, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (31, 15, 2, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (32, 15, 3, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (33, 15, 4, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (34, 15, 5, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (7, 16, 1, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (35, 16, 2, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (36, 16, 3, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (37, 16, 4, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (38, 16, 5, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (8, 17, 1, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (39, 17, 2, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (40, 17, 3, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (41, 17, 4, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (42, 17, 5, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (9, 18, 1, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (43, 18, 2, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (44, 18, 3, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (45, 18, 4, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (88, 98, 3, '14:00:00', '18:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (89, 98, 4, '14:00:00', '18:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (90, 98, 5, '14:00:00', '18:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (91, 99, 1, '14:30:00', '18:30:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (92, 99, 2, '14:30:00', '18:30:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (93, 99, 3, '14:30:00', '18:30:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (94, 99, 4, '14:30:00', '18:30:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (95, 99, 5, '14:30:00', '18:30:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (96, 100, 1, '15:00:00', '19:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (97, 100, 2, '15:00:00', '19:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (46, 18, 5, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (10, 20, 1, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (47, 20, 2, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (48, 20, 3, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (49, 20, 4, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (50, 20, 5, '08:00:00', '12:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (51, 91, 1, '14:00:00', '18:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (52, 91, 2, '14:00:00', '18:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (53, 91, 3, '14:00:00', '18:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (54, 91, 4, '14:00:00', '18:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (98, 100, 3, '15:00:00', '19:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (99, 100, 4, '15:00:00', '19:00:00', 30, true);
INSERT INTO vida_salud.horario (id_horario, id_medico, dia_semana, hora_inicio, hora_fin, duracion_bloque_min, activo) VALUES (100, 100, 5, '15:00:00', '19:00:00', 30, true);


--
-- Data for Name: informacion_medica; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (3, 24, NULL, 'Mariscos', NULL, 3, 'O+', 'Ninguna', 'Ninguno', 'Sin antecedentes patológicos relevantes', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (4, 25, NULL, 'Ibuprofeno', NULL, 4, 'O+', 'Ninguna', 'Ninguno', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (5, 26, NULL, 'Polen', NULL, 5, 'A-', 'Ninguna', 'Ninguno', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (6, 27, NULL, 'Ninguna conocida', NULL, 6, 'O+', 'Ninguna', 'Ninguno', 'Dengue (2023)', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (7, 28, NULL, 'Ibuprofeno', NULL, 7, 'A+', 'Ninguna', 'Ninguno', 'Dengue (2023)', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (8, 29, NULL, 'Ninguna conocida', NULL, 8, 'O+', 'Ninguna', 'Ninguno', 'Sin antecedentes patológicos relevantes', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (9, 30, NULL, 'Penicilina', NULL, 9, 'AB+', 'Ninguna', 'Ninguno', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (10, 31, NULL, 'Ibuprofeno', NULL, 10, 'A-', 'Ninguna', 'Ninguno', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (11, 32, NULL, 'Ibuprofeno', NULL, 11, 'O+', 'Ninguna', 'Ninguno', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (12, 33, NULL, 'Ninguna conocida', NULL, 12, 'A+', 'Ninguna', 'Ninguno', 'Dengue (2023)', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (13, 34, NULL, 'Ninguna conocida', NULL, 13, 'A+', 'Ninguna', 'Ninguno', 'Cirugía de apéndice (2015)', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (14, 35, NULL, 'Ninguna conocida', NULL, 14, 'A-', 'Ninguna', 'Ninguno', 'Dengue (2023)', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (15, 36, NULL, 'Penicilina', NULL, 15, 'A+', 'Ninguna', 'Ninguno', 'Dengue (2023)', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (16, 37, NULL, 'Ninguna conocida', NULL, 16, 'O-', 'Ninguna', 'Ninguno', 'Dengue (2023)', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (17, 38, NULL, 'Ninguna conocida', NULL, 17, 'O+', 'Ninguna', 'Ninguno', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (1, 21, NULL, 'Ibuprofeno', NULL, 1, 'A+', 'Ninguna', 'Ninguno', 'Cesárea (2018)', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (2, 22, NULL, 'Ninguna conocida', NULL, 2, 'O+', 'Asma', 'Salbutamol inhalador a demanda', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (18, 23, NULL, 'Mariscos', NULL, 18, 'A+', 'Ninguna', 'Ninguno', 'Cirugía de apéndice (2015)', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (19, 39, NULL, 'Ibuprofeno', NULL, 19, 'O-', 'Ninguna', 'Ninguno', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (20, 40, NULL, 'Ninguna conocida', NULL, 20, 'A-', 'Ninguna', 'Ninguno', 'Fractura de brazo derecho (2019)', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (21, 41, NULL, 'Ninguna conocida', NULL, 21, 'A+', 'Ninguna', 'Ninguno', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (22, 42, NULL, 'Mariscos', NULL, 22, 'O+', 'Asma', 'Salbutamol inhalador a demanda', 'Dengue (2023)', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (23, 43, NULL, 'Ninguna conocida', NULL, 23, 'O+', 'Ninguna', 'Ninguno', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (24, 44, NULL, 'Ninguna conocida', NULL, 24, 'O+', 'Diabetes tipo 2', 'Metformina 850 mg c/12 h', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (25, 45, NULL, 'Penicilina', NULL, 25, 'A+', 'Hipertensión arterial', 'Losartán 50 mg/día', 'Fractura de brazo derecho (2019)', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (26, 46, NULL, 'Polen', NULL, 26, 'A+', 'Ninguna', 'Ninguno', 'Fractura de brazo derecho (2019)', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (27, 47, NULL, 'Ninguna conocida', NULL, 27, 'O-', 'Diabetes tipo 2', 'Metformina 850 mg c/12 h', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (28, 48, NULL, 'Látex', NULL, 28, 'AB+', 'Diabetes tipo 2', 'Metformina 850 mg c/12 h', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (29, 49, NULL, 'Ibuprofeno', NULL, 29, 'A-', 'Hipertensión arterial', 'Losartán 50 mg/día', 'Sin antecedentes patológicos relevantes', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (30, 50, NULL, 'Penicilina', NULL, 30, 'O+', 'Asma', 'Salbutamol inhalador a demanda', 'Fractura de brazo derecho (2019)', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (31, 51, NULL, 'Mariscos', NULL, 31, 'A-', 'Hipertensión arterial', 'Losartán 50 mg/día', 'Sin antecedentes patológicos relevantes', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (32, 52, NULL, 'Látex', NULL, 32, 'AB+', 'Asma', 'Salbutamol inhalador a demanda', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (33, 53, NULL, 'Penicilina', NULL, 33, 'A+', 'Ninguna', 'Ninguno', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (34, 54, NULL, 'Ibuprofeno', NULL, 34, 'A-', 'Hipotiroidismo', 'Levotiroxina 50 mcg/día', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (35, 55, NULL, 'Ninguna conocida', NULL, 35, 'O+', 'Hipertensión arterial', 'Losartán 50 mg/día', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (36, 56, NULL, 'Látex', NULL, 36, 'AB+', 'Diabetes tipo 2', 'Metformina 850 mg c/12 h', 'Sin antecedentes patológicos relevantes', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (37, 57, NULL, 'Mariscos', NULL, 37, 'O+', 'Ninguna', 'Ninguno', 'Cirugía de apéndice (2015)', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (38, 58, NULL, 'Penicilina', NULL, 38, 'AB+', 'Ninguna', 'Ninguno', 'Cesárea (2018)', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (39, 59, NULL, 'Penicilina', NULL, 39, 'O+', 'Ninguna', 'Ninguno', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (40, 60, NULL, 'Polen', NULL, 40, 'A+', 'Diabetes tipo 2', 'Metformina 850 mg c/12 h', 'Dengue (2023)', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (41, 61, NULL, 'Mariscos', NULL, 41, 'O+', 'Ninguna', 'Ninguno', 'Fractura de brazo derecho (2019)', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (42, 62, NULL, 'Ninguna conocida', NULL, 42, 'O+', 'Diabetes tipo 2', 'Metformina 850 mg c/12 h', 'Cesárea (2018)', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (43, 63, NULL, 'Penicilina', NULL, 43, 'A+', 'Ninguna', 'Ninguno', 'Sin antecedentes patológicos relevantes', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (44, 64, NULL, 'Ninguna conocida', NULL, 44, 'O+', 'Diabetes tipo 2', 'Metformina 850 mg c/12 h', 'Dengue (2023)', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (45, 65, NULL, 'Penicilina', NULL, 45, 'B+', 'Ninguna', 'Ninguno', 'Fractura de brazo derecho (2019)', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (46, 66, NULL, 'Penicilina', NULL, 46, 'O+', 'Ninguna', 'Ninguno', 'Sin antecedentes patológicos relevantes', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (47, 67, NULL, 'Polen', NULL, 47, 'O+', 'Hipertensión arterial', 'Losartán 50 mg/día', 'Sin antecedentes patológicos relevantes', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (48, 68, NULL, 'Polen', NULL, 48, 'O+', 'Hipotiroidismo', 'Levotiroxina 50 mcg/día', 'Dengue (2023)', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (49, 69, NULL, 'Ninguna conocida', NULL, 49, 'A+', 'Ninguna', 'Ninguno', 'Cirugía de apéndice (2015)', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (50, 70, NULL, 'Ibuprofeno', NULL, 50, 'O+', 'Ninguna', 'Ninguno', 'Fractura de brazo derecho (2019)', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (51, 71, NULL, 'Ibuprofeno', NULL, 51, 'O+', 'Hipertensión arterial', 'Losartán 50 mg/día', 'Sin antecedentes patológicos relevantes', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (52, 72, NULL, 'Ninguna conocida', NULL, 52, 'A+', 'Ninguna', 'Ninguno', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (53, 73, NULL, 'Látex', NULL, 53, 'O+', 'Hipertensión arterial', 'Losartán 50 mg/día', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (54, 74, NULL, 'Ninguna conocida', NULL, 54, 'O+', 'Hipertensión arterial', 'Losartán 50 mg/día', 'Cirugía de apéndice (2015)', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (55, 75, NULL, 'Polen', NULL, 55, 'O+', 'Ninguna', 'Ninguno', 'Dengue (2023)', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (56, 76, NULL, 'Mariscos', NULL, 56, 'O-', 'Ninguna', 'Ninguno', 'Fractura de brazo derecho (2019)', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (57, 77, NULL, 'Ibuprofeno', NULL, 57, 'A+', 'Ninguna', 'Ninguno', 'Fractura de brazo derecho (2019)', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (58, 78, NULL, 'Látex', NULL, 58, 'O+', 'Hipotiroidismo', 'Levotiroxina 50 mcg/día', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (59, 79, NULL, 'Ninguna conocida', NULL, 59, 'B+', 'Asma', 'Salbutamol inhalador a demanda', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (60, 80, NULL, 'Ninguna conocida', NULL, 60, 'AB+', 'Ninguna', 'Ninguno', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (61, 81, NULL, 'Látex', NULL, 61, 'O-', 'Ninguna', 'Ninguno', 'Cirugía de apéndice (2015)', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (62, 82, NULL, 'Polen', NULL, 62, 'A-', 'Hipertensión arterial', 'Losartán 50 mg/día', 'Cirugía de apéndice (2015)', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (63, 83, NULL, 'Ninguna conocida', NULL, 63, 'O+', 'Ninguna', 'Ninguno', 'Fractura de brazo derecho (2019)', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (64, 84, NULL, 'Penicilina', NULL, 64, 'AB+', 'Hipotiroidismo', 'Levotiroxina 50 mcg/día', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (65, 85, NULL, 'Ninguna conocida', NULL, 65, 'A+', 'Ninguna', 'Ninguno', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (66, 86, NULL, 'Polen', NULL, 66, 'O+', 'Ninguna', 'Ninguno', 'Sin antecedentes patológicos relevantes', 'Paciente refiere control periódico en otra clínica', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (67, 87, NULL, 'Ninguna conocida', NULL, 67, 'B+', 'Diabetes tipo 2', 'Metformina 850 mg c/12 h', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (68, 88, NULL, 'Ninguna conocida', NULL, 68, 'O+', 'Diabetes tipo 2', 'Metformina 850 mg c/12 h', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (69, 89, NULL, 'Ibuprofeno', NULL, 69, 'O+', 'Hipotiroidismo', 'Levotiroxina 50 mcg/día', 'Sin antecedentes patológicos relevantes', 'Sin observaciones', '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.informacion_medica (id_info_medica, id_paciente, grupo_sanguineo, alergias, antecedentes, id_informacion, tipo_sangre, enfermedades_cronicas, medicamentos_habituales, antecedentes_relevantes, observaciones, fecha_actualizacion) VALUES (70, 90, NULL, 'Ninguna conocida', NULL, 70, 'O+', 'Diabetes tipo 2', 'Metformina 850 mg c/12 h', 'Dengue (2023)', 'Sin observaciones', '2026-11-09 03:11:56+00');


--
-- Data for Name: job_batches; Type: TABLE DATA; Schema: vida_salud; Owner: -
--



--
-- Data for Name: jobs; Type: TABLE DATA; Schema: vida_salud; Owner: -
--



--
-- Data for Name: medico; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.medico (id_persona, codigo, matricula, activo) VALUES (10, 'MED-001', 'MP-10039', true);
INSERT INTO vida_salud.medico (id_persona, codigo, matricula, activo) VALUES (11, 'MED-002', 'MP-83256', true);
INSERT INTO vida_salud.medico (id_persona, codigo, matricula, activo) VALUES (12, 'MED-003', 'MP-12247', true);
INSERT INTO vida_salud.medico (id_persona, codigo, matricula, activo) VALUES (13, 'MED-004', 'MP-62978', true);
INSERT INTO vida_salud.medico (id_persona, codigo, matricula, activo) VALUES (14, 'MED-005', 'MP-11939', true);
INSERT INTO vida_salud.medico (id_persona, codigo, matricula, activo) VALUES (15, 'MED-006', 'MP-65233', true);
INSERT INTO vida_salud.medico (id_persona, codigo, matricula, activo) VALUES (16, 'MED-007', 'MP-50719', true);
INSERT INTO vida_salud.medico (id_persona, codigo, matricula, activo) VALUES (17, 'MED-008', 'MP-98731', true);
INSERT INTO vida_salud.medico (id_persona, codigo, matricula, activo) VALUES (18, 'MED-009', 'MP-10954', true);
INSERT INTO vida_salud.medico (id_persona, codigo, matricula, activo) VALUES (19, 'MED-010', 'MP-98564', true);
INSERT INTO vida_salud.medico (id_persona, codigo, matricula, activo) VALUES (20, 'MED-099', 'MP-89452', true);
INSERT INTO vida_salud.medico (id_persona, codigo, matricula, activo) VALUES (91, 'MED-011', 'MP-13482', true);
INSERT INTO vida_salud.medico (id_persona, codigo, matricula, activo) VALUES (92, 'MED-012', 'MP-14295', true);
INSERT INTO vida_salud.medico (id_persona, codigo, matricula, activo) VALUES (93, 'MED-013', 'MP-15839', true);
INSERT INTO vida_salud.medico (id_persona, codigo, matricula, activo) VALUES (94, 'MED-014', 'MP-16928', true);
INSERT INTO vida_salud.medico (id_persona, codigo, matricula, activo) VALUES (95, 'MED-015', 'MP-17839', true);
INSERT INTO vida_salud.medico (id_persona, codigo, matricula, activo) VALUES (96, 'MED-016', 'MP-18940', true);
INSERT INTO vida_salud.medico (id_persona, codigo, matricula, activo) VALUES (97, 'MED-017', 'MP-19820', true);
INSERT INTO vida_salud.medico (id_persona, codigo, matricula, activo) VALUES (98, 'MED-018', 'MP-20938', true);
INSERT INTO vida_salud.medico (id_persona, codigo, matricula, activo) VALUES (99, 'MED-019', 'MP-21948', true);
INSERT INTO vida_salud.medico (id_persona, codigo, matricula, activo) VALUES (100, 'MED-020', 'MP-22849', true);


--
-- Data for Name: medico_especialidad; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.medico_especialidad (id_medico, id_especialidad) VALUES (10, 1);
INSERT INTO vida_salud.medico_especialidad (id_medico, id_especialidad) VALUES (11, 2);
INSERT INTO vida_salud.medico_especialidad (id_medico, id_especialidad) VALUES (12, 3);
INSERT INTO vida_salud.medico_especialidad (id_medico, id_especialidad) VALUES (13, 4);
INSERT INTO vida_salud.medico_especialidad (id_medico, id_especialidad) VALUES (14, 5);
INSERT INTO vida_salud.medico_especialidad (id_medico, id_especialidad) VALUES (15, 1);
INSERT INTO vida_salud.medico_especialidad (id_medico, id_especialidad) VALUES (16, 2);
INSERT INTO vida_salud.medico_especialidad (id_medico, id_especialidad) VALUES (17, 3);
INSERT INTO vida_salud.medico_especialidad (id_medico, id_especialidad) VALUES (18, 4);
INSERT INTO vida_salud.medico_especialidad (id_medico, id_especialidad) VALUES (19, 5);
INSERT INTO vida_salud.medico_especialidad (id_medico, id_especialidad) VALUES (20, 1);
INSERT INTO vida_salud.medico_especialidad (id_medico, id_especialidad) VALUES (91, 6);
INSERT INTO vida_salud.medico_especialidad (id_medico, id_especialidad) VALUES (92, 7);
INSERT INTO vida_salud.medico_especialidad (id_medico, id_especialidad) VALUES (93, 9);
INSERT INTO vida_salud.medico_especialidad (id_medico, id_especialidad) VALUES (94, 10);
INSERT INTO vida_salud.medico_especialidad (id_medico, id_especialidad) VALUES (95, 11);
INSERT INTO vida_salud.medico_especialidad (id_medico, id_especialidad) VALUES (96, 12);
INSERT INTO vida_salud.medico_especialidad (id_medico, id_especialidad) VALUES (97, 13);
INSERT INTO vida_salud.medico_especialidad (id_medico, id_especialidad) VALUES (98, 14);
INSERT INTO vida_salud.medico_especialidad (id_medico, id_especialidad) VALUES (99, 15);
INSERT INTO vida_salud.medico_especialidad (id_medico, id_especialidad) VALUES (100, 16);


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (1, '0001_01_01_000000_create_users_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (2, '0001_01_01_000001_create_cache_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (3, '0001_01_01_000002_create_jobs_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (4, '2026_10_25_100001_create_persona_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (5, '2026_10_25_100002_create_rol_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (6, '2026_10_25_100003_create_permiso_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (7, '2026_10_25_100004_create_rol_permiso_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (8, '2026_10_25_100005_create_usuario_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (9, '2026_10_25_100006_create_sesion_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (10, '2026_10_25_100007_create_token_recuperacion_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (11, '2026_10_25_100008_create_personal_administrativo_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (12, '2026_10_25_100009_create_bitacora_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (13, '2026_10_25_100010_create_paciente_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (14, '2026_10_25_100011_create_informacion_medica_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (15, '2026_10_25_100012_create_contacto_emergencia_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (16, '2026_10_25_100013_create_medico_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (17, '2026_10_25_100014_create_especialidad_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (18, '2026_10_25_100015_create_medico_especialidad_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (19, '2026_10_25_100016_create_horario_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (20, '2026_10_25_100017_create_bloqueo_agenda_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (21, '2026_10_25_100018_create_cita_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (22, '2026_10_25_100019_create_historial_estado_cita_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (23, '2026_10_25_100020_create_notificacion_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (24, '2026_10_25_100021_create_reporte_table', 1);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (25, '2026_11_07_200001_actualizar_tablas_segun_diccionario_23_tablas', 2);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (26, '2026_11_08_150000_ensure_administradores_and_data_sync', 3);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (28, '2026_11_08_190000_add_costo_to_especialidad_table', 5);
INSERT INTO vida_salud.migrations (id, migration, batch) VALUES (29, '2026_11_08_163000_poblar_60_pacientes_completos', 6);


--
-- Data for Name: notificacion; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.notificacion (id_notificacion, id_cita, id_usuario_gestion, tipo_canal, destinatario, mensaje, fecha_programada, fecha_envio, estado, intentos) VALUES (2, 2, 4, 'EMAIL', NULL, 'Recordatorio de cita médica CM-0001 programada para el 2026-10-19 a las 08:00.', '2026-10-18 12:00:00+00', '2026-10-18 12:05:00+00', 'ENVIADA', 1);


--
-- Data for Name: paciente; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (24, 'PAC-0024', 'M', '2024-12-12', 'Barrio Guaracachi, calle 5', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (25, 'PAC-0025', 'M', '2016-02-26', 'Av. Piraí, 6to anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (26, 'PAC-0026', 'M', '2016-06-01', 'Av. Cristo Redentor, 4to anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (27, 'PAC-0004', 'M', '2019-01-20', 'Av. Grigotá, 3er anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (28, 'PAC-0005', 'M', '2013-04-02', 'Barrio Las Palmas, calle 2', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (29, 'PAC-0006', 'M', '2022-07-16', 'Av. Beni, 2do anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (30, 'PAC-0007', 'M', '2019-04-18', 'Barrio El Trompillo, calle Bolívar', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (31, 'PAC-0008', 'F', '2023-10-19', 'Av. Piraí, 6to anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (32, 'PAC-0009', 'F', '2016-07-12', 'Av. Beni, 2do anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (33, 'PAC-0010', 'M', '2014-09-18', 'Av. Virgen de Cotoca, 5to anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (34, 'PAC-0011', 'F', '2013-09-22', 'Av. Santos Dumont, 5to anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (35, 'PAC-0012', 'M', '2015-11-01', 'Barrio Guaracachi, calle 5', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (36, 'PAC-0013', 'F', '2018-07-01', 'Av. Piraí, 6to anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (37, 'PAC-0014', 'M', '2016-08-04', 'Plan Tres Mil, UV 160', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (38, 'PAC-0015', 'M', '2014-05-03', 'Av. Beni, 2do anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (21, 'PAC-0001', 'F', '1976-02-20', 'Av. Virgen de Cotoca, 5to anillo', '2026-11-09 03:08:26.773064+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (22, 'PAC-0002', 'M', '1982-04-12', 'Av. Grigotá, 3er anillo', '2026-11-09 03:08:26.779385+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (23, 'PAC-0003', 'M', '1971-08-11', 'Av. Mutualista, 4to anillo', '2026-11-09 03:08:26.78205+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (39, 'PAC-0019', 'M', '1990-05-08', 'Av. Grigotá, 3er anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (40, 'PAC-0020', 'M', '1972-11-21', 'Barrio Las Palmas, calle 2', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (41, 'PAC-0021', 'M', '1995-04-08', 'Av. Mutualista, 4to anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (42, 'PAC-0022', 'M', '1991-02-05', 'Barrio Hamacas, calle Los Tajibos', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (43, 'PAC-0023', 'F', '1981-01-16', 'Barrio El Trompillo, calle Bolívar', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (44, 'PAC-0044', 'M', '1957-05-15', 'Av. Alemana, 3er anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (45, 'PAC-0045', 'M', '1968-09-20', 'Barrio El Trompillo, calle Bolívar', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (46, 'PAC-0046', 'M', '1973-08-15', 'Av. Mutualista, 4to anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (47, 'PAC-0027', 'M', '1995-07-04', 'Av. Alemana, 3er anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (48, 'PAC-0028', 'M', '1964-05-26', 'Barrio Equipetrol, calle 7', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (49, 'PAC-0029', 'F', '1970-09-25', 'Barrio Los Lotes, calle 10', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (50, 'PAC-0030', 'M', '1959-02-22', 'Barrio Equipetrol, calle 7', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (51, 'PAC-0031', 'M', '1982-07-14', 'Av. Grigotá, 3er anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (52, 'PAC-0032', 'M', '2003-04-22', 'Av. Paraguá, 4to anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (53, 'PAC-0033', 'F', '1953-04-04', 'Av. Cristo Redentor, 4to anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (54, 'PAC-0034', 'M', '1994-10-11', 'Av. Piraí, 6to anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (55, 'PAC-0035', 'M', '1957-03-01', 'Av. Banzer, 3er anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (56, 'PAC-0036', 'M', '1956-05-07', 'Barrio Hamacas, calle Los Tajibos', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (57, 'PAC-0037', 'F', '1978-08-03', 'Av. Beni, 2do anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (58, 'PAC-0038', 'F', '1950-08-26', 'Barrio Sirari, calle Las Palmas', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (59, 'PAC-0039', 'M', '1964-04-17', 'Av. Virgen de Cotoca, 5to anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (60, 'PAC-0040', 'F', '1987-01-01', 'Barrio Urbari, calle 3', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (61, 'PAC-0041', 'M', '1996-06-11', 'Barrio Los Lotes, calle 10', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (62, 'PAC-0042', 'F', '1953-12-25', 'Barrio Urbari, calle 3', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (63, 'PAC-0043', 'M', '1963-02-26', 'Av. Virgen de Cotoca, 5to anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (64, 'PAC-0064', 'F', '1976-01-26', 'Barrio El Trompillo, calle Bolívar', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (65, 'PAC-0065', 'F', '1959-11-11', 'Av. Grigotá, 3er anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (66, 'PAC-0066', 'M', '1971-01-07', 'Barrio Sirari, calle Las Palmas', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (67, 'PAC-0047', 'F', '1964-01-08', 'Barrio Los Lotes, calle 10', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (68, 'PAC-0048', 'M', '1991-05-09', 'Barrio Sirari, calle Las Palmas', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (69, 'PAC-0049', 'M', '2002-03-22', 'Av. Mutualista, 4to anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (70, 'PAC-0050', 'F', '1973-07-04', 'Barrio Guaracachi, calle 5', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (71, 'PAC-0051', 'F', '1969-01-19', 'Av. Cristo Redentor, 4to anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (72, 'PAC-0052', 'M', '1968-08-01', 'Av. Grigotá, 3er anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (73, 'PAC-0053', 'M', '2001-01-04', 'Av. Grigotá, 3er anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (74, 'PAC-0054', 'M', '1962-05-05', 'Barrio El Trompillo, calle Bolívar', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (75, 'PAC-0055', 'F', '1971-10-07', 'Barrio Urbari, calle 3', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (76, 'PAC-0056', 'M', '1971-04-09', 'Av. Grigotá, 3er anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (77, 'PAC-0057', 'F', '1952-10-09', 'Barrio El Trompillo, calle Bolívar', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (78, 'PAC-0058', 'M', '1956-02-28', 'Barrio Sirari, calle Las Palmas', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (79, 'PAC-0059', 'F', '1976-10-23', 'Barrio Sirari, calle Las Palmas', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (80, 'PAC-0060', 'F', '1977-01-02', 'Av. Mutualista, 4to anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (81, 'PAC-0061', 'F', '1967-01-01', 'Barrio Los Lotes, calle 10', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (82, 'PAC-0062', 'M', '1977-08-26', 'Av. Banzer, 3er anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (83, 'PAC-0063', 'M', '2003-09-24', 'Barrio Las Palmas, calle 2', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (84, 'PAC-0084', 'M', '1964-06-07', 'Av. Virgen de Cotoca, 5to anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (85, 'PAC-0085', 'M', '1956-11-23', 'Av. Alemana, 3er anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (86, 'PAC-0086', 'F', '1960-09-01', 'Av. Cristo Redentor, 4to anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (87, 'PAC-0067', 'F', '1952-11-09', 'Av. Cristo Redentor, 4to anillo', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (88, 'PAC-0068', 'F', '1961-01-08', 'Barrio Guaracachi, calle 5', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (89, 'PAC-0069', 'F', '1953-02-18', 'Barrio Sirari, calle Las Palmas', '2026-11-09 03:11:56.393746+00');
INSERT INTO vida_salud.paciente (id_persona, codigo, sexo, fecha_nacimiento, direccion, fecha_registro) VALUES (90, 'PAC-0070', 'F', '1950-05-14', 'Av. Grigotá, 3er anillo', '2026-11-09 03:11:56.393746+00');


--
-- Data for Name: pago; Type: TABLE DATA; Schema: vida_salud; Owner: -
--



--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: vida_salud; Owner: -
--



--
-- Data for Name: permiso; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.permiso (id_permiso, nombre, descripcion, modulo, ruta_menu) VALUES (1, 'ACCESO_SISTEMA', NULL, 'P1_SEGURIDAD', '/dashboard');
INSERT INTO vida_salud.permiso (id_permiso, nombre, descripcion, modulo, ruta_menu) VALUES (2, 'GESTION_USUARIOS', NULL, 'P2_RBAC', '/admin/usuarios');
INSERT INTO vida_salud.permiso (id_permiso, nombre, descripcion, modulo, ruta_menu) VALUES (3, 'GESTION_ROLES', NULL, 'P2_RBAC', '/admin/roles');
INSERT INTO vida_salud.permiso (id_permiso, nombre, descripcion, modulo, ruta_menu) VALUES (4, 'CONSULTAR_BITACORA', NULL, 'P3_AUDITORIA', '/admin/bitacora');
INSERT INTO vida_salud.permiso (id_permiso, nombre, descripcion, modulo, ruta_menu) VALUES (5, 'GESTION_PACIENTES', NULL, 'P4_PACIENTES', '/pacientes');
INSERT INTO vida_salud.permiso (id_permiso, nombre, descripcion, modulo, ruta_menu) VALUES (6, 'GESTION_MEDICOS', NULL, 'P5_MEDICOS', '/medicos');
INSERT INTO vida_salud.permiso (id_permiso, nombre, descripcion, modulo, ruta_menu) VALUES (7, 'GESTION_HORARIOS', NULL, 'P5_HORARIOS', '/medicos/horarios');
INSERT INTO vida_salud.permiso (id_permiso, nombre, descripcion, modulo, ruta_menu) VALUES (8, 'BLOQUEO_AGENDA', NULL, 'P5_AGENDA', '/agenda/bloqueos');
INSERT INTO vida_salud.permiso (id_permiso, nombre, descripcion, modulo, ruta_menu) VALUES (9, 'GESTION_CITAS', NULL, 'P6_CITAS', '/citas');
INSERT INTO vida_salud.permiso (id_permiso, nombre, descripcion, modulo, ruta_menu) VALUES (10, 'ATENCION_MEDICA', NULL, 'P6_CITAS', '/citas/atencion');
INSERT INTO vida_salud.permiso (id_permiso, nombre, descripcion, modulo, ruta_menu) VALUES (11, 'NOTIFICACIONES_CITAS', NULL, 'P6_NOTIFICACIONES', '/citas/recordatorios');
INSERT INTO vida_salud.permiso (id_permiso, nombre, descripcion, modulo, ruta_menu) VALUES (12, 'REPORTES_ADMINISTRATIVOS', NULL, 'P7_REPORTES', '/reportes');


--
-- Data for Name: persona; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (2, '11757436', 'Silvia Irene', 'Colque López', '76945876', 'scolque@vidasalud.com.bo', true, '2026-11-09 02:59:56.445416+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (3, '14567212', 'Ronald', 'Rivero Fernandez', '73127317', 'ronaldorojasugarte@gmail.com', true, '2026-11-09 02:59:56.448917+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (4, '1000001', 'Carlos Alberto', 'Administrador General', '71234567', 'admin@vidasalud.com', true, '2026-11-09 02:59:56.449974+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (5, '8090601', 'Rosa María', 'Vaca Cuéllar', '75403694', 'rvaca@vidasalud.com.bo', true, '2026-11-09 02:59:56.451341+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (6, '5930783', 'Carla Andrea', 'Suárez Roca', '78793510', 'csuarez@vidasalud.com.bo', true, '2026-11-09 02:59:56.452487+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (7, '7668705', 'Jorge Luis', 'Mendoza Paz', '71128245', 'jmendoza@vidasalud.com.bo', true, '2026-11-09 02:59:56.453522+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (8, '7175901', 'Daniela', 'Justiniano Áñez', '76954784', 'djustiniano@vidasalud.com.bo', true, '2026-11-09 02:59:56.454402+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (9, '2000002', 'Ana María', 'Recepcionista Central', '72345678', 'recepcion@vidasalud.com', true, '2026-11-09 02:59:56.455351+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (10, '10039156', 'Juan Ronaldo', 'Rojas Ugarte', '74625968', 'jrojas@vidasalud.com.bo', true, '2026-11-09 02:59:56.456495+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (11, '8325677', 'Patricia', 'Gutiérrez Melgar', '76244222', 'pgutierrez@vidasalud.com.bo', true, '2026-11-09 02:59:56.45767+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (12, '12247339', 'Fernando', 'Arteaga Ribera', '70246676', 'farteaga@vidasalud.com.bo', true, '2026-11-09 02:59:56.459005+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (13, '6297813', 'Claudia', 'Montero Saucedo', '72839842', 'cmontero@vidasalud.com.bo', true, '2026-11-09 02:59:56.460452+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (14, '11939857', 'Marcelo', 'Terceros Chávez', '78940741', 'mterceros@vidasalud.com.bo', true, '2026-11-09 02:59:56.461492+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (15, '6523383', 'Gabriela', 'Peña Salvatierra', '75666192', 'gpena@vidasalud.com.bo', true, '2026-11-09 02:59:56.462359+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (16, '5071992', 'Álvaro', 'Moreno Durán', '71424219', 'amoreno@vidasalud.com.bo', true, '2026-11-09 02:59:56.463197+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (17, '9873195', 'Lorena', 'Antelo Barba', '71631930', 'lantelo@vidasalud.com.bo', true, '2026-11-09 02:59:56.464143+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (18, '10954052', 'Ricardo', 'Égüez Parada', '79248485', 'reguez@vidasalud.com.bo', true, '2026-11-09 02:59:56.465176+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (19, '9856412', 'Hugo', 'Flores Mamani', '78452722', 'hflores@vidasalud.com.bo', false, '2026-11-09 02:59:56.466073+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (20, '3000003', 'Carlos', 'Pérez Gómez', '73456789', 'dr.perez@vidasalud.com', true, '2026-11-09 02:59:56.467065+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (24, '9802455', 'Mauricio', 'Suárez Égüez', '73222777', 'mauricio.suarez.9802455@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (25, '7197193', 'Fernando', 'Quispe Suárez', '74464717', 'fernando.quispe.7197193@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (26, '7571841', 'Rodrigo Gustavo', 'Montero Durán', '77763855', 'rodrigo.montero.7571841@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (27, '11135083', 'Ronald Marco', 'Peña Parada', '79956114', 'ronald.pena.11135083@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (28, '8304307', 'Marcelo', 'Gutiérrez Chávez', '70269292', 'marcelo.gutierrez.8304307@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (29, '6773800', 'Iván', 'Antelo Mendoza', '78378110', 'ivan.antelo.6773800@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (30, '10706704', 'Ronald Hugo', 'Montero Flores', '73340188', 'ronald.montero.10706704@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (31, '12325778', 'Rosa', 'Terceros Vaca', '73742751', 'rosa.terceros.12325778@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (32, '11779623', 'Gabriela', 'Moreno Roca', '70301420', 'gabriela.moreno.11779623@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (33, '6087759', 'Óscar', 'Barba Melgar', '70966459', 'oscar.barba.6087759@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (34, '8056876', 'Roxana', 'Suárez Mendoza', '79313966', 'roxana.suarez.8056876@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (35, '12045806', 'Óscar', 'Moreno Parada', '70297216', 'oscar.moreno.12045806@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (36, '13509854', 'Valeria', 'Arteaga Montero', '74441184', 'valeria.arteaga.13509854@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (37, '6360586', 'Rodrigo Fernando', 'Parada Saucedo', '77483331', 'rodrigo.parada.6360586@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (38, '12382174', 'Sergio', 'Durán Montero', '72272457', 'sergio.duran.12382174@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (21, '12181643', 'Jimena', 'Égüez Choque', '75666779', 'jeguez@outlook.com', true, '2026-11-09 02:59:56.468407+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (22, '10223343', 'Ronald', 'Saucedo Mendoza', '71640267', 'rsaucedo@gmail.com', true, '2026-11-09 02:59:56.469694+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (23, '9432684', 'Jorge Ronald', 'Rojas Choque', '75702715', 'jrojas@gmail.com', true, '2026-11-09 02:59:56.470725+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (39, '7533855', 'Mauricio Daniel', 'Égüez Rivero', '71422656', 'meguez@outlook.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (40, '10538514', 'Rodrigo Gustavo', 'Montero Suárez', '72888507', 'rmontero@hotmail.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (41, '6315648', 'Marcelo Álvaro', 'Salvatierra Égüez', '75856625', 'marcelo.salvatierra.6315648@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (42, '9349202', 'Gustavo', 'Ribera Antelo', '77450754', 'gribera@hotmail.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (43, '11333378', 'Mariela', 'Barba Áñez', '70377458', 'mbarba@outlook.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (44, '13860036', 'Marcelo Miguel', 'Suárez Barba', '76642496', 'msuarez@hotmail.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (45, '7941821', 'Daniel', 'Peña Arteaga', '79468576', 'daniel.pena.7941821@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (46, '13081819', 'Daniel', 'Suárez Quispe', '71465238', 'dsuarez@hotmail.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (47, '12187543', 'Javier Pablo', 'Rojas Suárez', '77149368', 'javier.rojas.12187543@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (48, '12270738', 'Gustavo José', 'Gutiérrez Saucedo', '70558696', 'gustavo.gutierrez.12270738@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (49, '11962475', 'María', 'Justiniano Égüez', '77411330', 'mjustiniano@hotmail.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (50, '7949013', 'Marco', 'Antelo Chávez', '76932921', 'mantelo@gmail.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (51, '12441619', 'Daniel', 'Suárez Saucedo', '78870217', 'daniel.suarez.12441619@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (52, '6439135', 'Daniel', 'Barba Mamani', '78590570', 'dbarba@hotmail.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (53, '10188329', 'Paola', 'Paz Terceros', '76840518', 'ppaz@hotmail.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (54, '12829770', 'Juan', 'Moreno Mamani', '79792237', 'juan.moreno.12829770@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (55, '10463304', 'Diego', 'Parada Ribera', '79107639', 'diego.parada.10463304@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (56, '8488363', 'Javier', 'Peña Flores', '72599181', 'jpena@outlook.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (57, '4714352', 'Ximena', 'Peña Salvatierra', '74642606', 'xpena@gmail.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (58, '6576726', 'Silvia', 'Melgar Flores', '71133869', 'silvia.melgar.6576726@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (59, '11194783', 'Iván Álvaro', 'Moreno Mamani', '70846850', 'imoreno@outlook.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (60, '13964587', 'Paola', 'Arteaga Ribera', '70263147', 'parteaga@outlook.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (61, '6622484', 'Rodrigo', 'Áñez Parada', '72694389', 'ranez@outlook.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (62, '8487994', 'Fernanda', 'Choque Rivero', '70105063', 'fernanda.choque.8487994@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (63, '8329161', 'Luis', 'Justiniano Melgar', '72954079', 'luis.justiniano.8329161@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (64, '9927337', 'Rosa', 'Durán Parada', '79360305', 'rduran@outlook.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (65, '10960281', 'Karen Gabriela', 'Mamani Ribera', '74574461', 'karen.mamani.10960281@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (66, '5046301', 'Sergio', 'Paz Chávez', '79948441', 'sergio.paz.5046301@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (67, '13885376', 'Camila', 'Choque Peña', '75975326', 'cchoque@gmail.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (68, '3084682', 'Daniel', 'Égüez Terceros', '74762322', 'daniel.eguez.3084682@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (69, '3570715', 'Iván', 'Cuéllar Arteaga', '73413816', 'icuellar@hotmail.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (70, '13660553', 'Sofía', 'Melgar Vaca', '78628745', 'smelgar@outlook.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (71, '4882637', 'Sofía', 'Terceros Gutiérrez', '72196662', 'sofia.terceros.4882637@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (72, '4703447', 'Marcelo', 'Quispe Melgar', '75615839', 'mquispe@hotmail.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (73, '12637899', 'Sergio', 'Roca Terceros', '79308614', 'sroca@hotmail.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (74, '4428329', 'Diego', 'Chávez Roca', '71757766', 'dchavez@outlook.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (75, '8007355', 'Verónica', 'Paz Parada', '74505952', 'veronica.paz.8007355@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (76, '7941513', 'Marcelo', 'Rivero Arteaga', '77489188', 'marcelo.rivero.7941513@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (77, '8472576', 'Valeria', 'Áñez Roca', '78933363', 'vanez@hotmail.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (78, '5142779', 'Fernando Wilson', 'Roca Barba', '78251059', 'froca@hotmail.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (79, '4322975', 'María', 'Quispe Barba', '76977759', 'maria.quispe.4322975@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (80, '12643600', 'Patricia Daniela', 'Peña Saucedo', '71458028', 'ppena@hotmail.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (81, '8445513', 'Ximena Mónica', 'Quispe Quispe', '73239955', 'xquispe@outlook.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (82, '6802949', 'Jorge', 'Moreno Suárez', '70122746', 'jorge.moreno.6802949@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (83, '5928532', 'Gustavo Edwin', 'Roca Mamani', '72995463', 'groca@gmail.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (84, '12213337', 'Sergio Wilson', 'Mamani Durán', '73358901', 'smamani@outlook.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (85, '13963055', 'Miguel', 'Saucedo Flores', '79813128', 'miguel.saucedo.13963055@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (86, '5659131', 'Carla', 'Roca Peña', '75468768', 'carla.roca.5659131@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (87, '11528498', 'Mariela', 'Parada Mendoza', '71946797', 'mparada@hotmail.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (88, '3877914', 'Claudia', 'Paz Paz', '71401341', 'claudia.paz.3877914@vidasalud.com.bo', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (89, '7354419', 'Gabriela', 'Rivero Choque', '75116093', 'grivero@gmail.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (90, '11487228', 'Jimena', 'Moreno Peña', '73338219', 'jmoreno@hotmail.com', true, '2026-11-09 03:11:56+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (91, '13482910', 'Mariana Sofía', 'Villarroel Suárez', '71829301', 'mvillarroel@vidasalud.com.bo', true, '2026-11-10 09:57:20.009829+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (92, '14295831', 'Rodrigo Andrés', 'Camacho Aguilera', '72948512', 'rcamacho@vidasalud.com.bo', true, '2026-11-10 09:57:20.106746+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (93, '15839204', 'Esteban Mauricio', 'Zeballos Ortiz', '73849102', 'ezeballos@vidasalud.com.bo', true, '2026-11-10 09:57:20.108072+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (94, '16928475', 'Valeria Elena', 'Hurtado Céspedes', '74928173', 'vhurtado@vidasalud.com.bo', true, '2026-11-10 09:57:20.109577+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (95, '17839201', 'Guillermo Javier', 'Paz Soldán', '75839201', 'gpaz@vidasalud.com.bo', true, '2026-11-10 09:57:20.110889+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (96, '18940291', 'Silvia Daniela', 'Torrico Benítez', '76940281', 'storrico@vidasalud.com.bo', true, '2026-11-10 09:57:20.112828+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (97, '19820394', 'Alejandro José', 'Morales Barrientos', '77820394', 'amorales@vidasalud.com.bo', true, '2026-11-10 09:57:20.115272+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (98, '20938412', 'Carla Viviana', 'Añez Justiniano', '78938412', 'canez@vidasalud.com.bo', true, '2026-11-10 09:57:20.116576+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (99, '21948523', 'Gonzalo Hernán', 'Rivera Melgar', '79948523', 'grivera@vidasalud.com.bo', true, '2026-11-10 09:57:20.118055+00');
INSERT INTO vida_salud.persona (id_persona, ci, nombres, apellidos, telefono, email, activo, fecha_registro) VALUES (100, '22849534', 'Lucía Mercedes', 'Saldaña Quiroga', '70849534', 'lsaldana@vidasalud.com.bo', true, '2026-11-10 09:57:20.120107+00');


--
-- Data for Name: personal_administrativo; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.personal_administrativo (id_persona, cargo) VALUES (2, 'Administradora del sistema');
INSERT INTO vida_salud.personal_administrativo (id_persona, cargo) VALUES (4, 'Administrador de Sistemas');
INSERT INTO vida_salud.personal_administrativo (id_persona, cargo) VALUES (5, 'Recepcionista turno mañana');
INSERT INTO vida_salud.personal_administrativo (id_persona, cargo) VALUES (6, 'Recepcionista turno mañana');
INSERT INTO vida_salud.personal_administrativo (id_persona, cargo) VALUES (7, 'Recepcionista turno tarde');
INSERT INTO vida_salud.personal_administrativo (id_persona, cargo) VALUES (8, 'Recepcionista turno tarde');
INSERT INTO vida_salud.personal_administrativo (id_persona, cargo) VALUES (9, 'Recepcionista Central');


--
-- Data for Name: recuperacion_contrasena; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.recuperacion_contrasena (id_recuperacion, id_usuario, token_hash, fecha_generacion, fecha_expiracion, usado) VALUES (1, 1, '845862d5d965e6663f59c35762375f4485ac374cdf038c21b2c330090253bb34', '2026-11-07 15:56:49', '2026-11-07 19:56:49', false);
INSERT INTO vida_salud.recuperacion_contrasena (id_recuperacion, id_usuario, token_hash, fecha_generacion, fecha_expiracion, usado) VALUES (2, 1, '925f7cfd9284ea6dd80f5f721171458892b17d7078f3680537a17b5cb27997b7', '2026-11-05 16:56:49', '2026-11-06 16:56:49', true);


--
-- Data for Name: reembolso; Type: TABLE DATA; Schema: vida_salud; Owner: -
--



--
-- Data for Name: reporte; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.reporte (id_reporte, id_usuario_generador, tipo_reporte, formato, parametros, fecha_generacion, ruta_archivo, id_usuario, tipo, fecha_desde, fecha_hasta, filtros) VALUES (3, NULL, NULL, 'PDF', NULL, '2026-11-09 03:11:26+00', NULL, 1, 'CITAS_PERIODO', '2026-10-01', '2026-10-31', '{"estado": "ATENDIDA"}');


--
-- Data for Name: rol; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.rol (id_rol, nombre, descripcion) VALUES (4, 'PACIENTE', 'Acceso web para auto-reserva de citas, consulta de fichas y pagos');
INSERT INTO vida_salud.rol (id_rol, nombre, descripcion) VALUES (1, 'ADMINISTRADOR', 'Acceso total al sistema y configuración global');
INSERT INTO vida_salud.rol (id_rol, nombre, descripcion) VALUES (2, 'RECEPCIONISTA', 'Gestión de pacientes, agenda y confirmación de citas');
INSERT INTO vida_salud.rol (id_rol, nombre, descripcion) VALUES (3, 'MEDICO', 'Consulta de agenda, citas asignadas y registro de atención');


--
-- Data for Name: rol_permiso; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.rol_permiso (id_rol, id_permiso) VALUES (1, 1);
INSERT INTO vida_salud.rol_permiso (id_rol, id_permiso) VALUES (1, 2);
INSERT INTO vida_salud.rol_permiso (id_rol, id_permiso) VALUES (1, 3);
INSERT INTO vida_salud.rol_permiso (id_rol, id_permiso) VALUES (1, 4);
INSERT INTO vida_salud.rol_permiso (id_rol, id_permiso) VALUES (1, 5);
INSERT INTO vida_salud.rol_permiso (id_rol, id_permiso) VALUES (1, 6);
INSERT INTO vida_salud.rol_permiso (id_rol, id_permiso) VALUES (1, 7);
INSERT INTO vida_salud.rol_permiso (id_rol, id_permiso) VALUES (1, 8);
INSERT INTO vida_salud.rol_permiso (id_rol, id_permiso) VALUES (1, 9);
INSERT INTO vida_salud.rol_permiso (id_rol, id_permiso) VALUES (1, 10);
INSERT INTO vida_salud.rol_permiso (id_rol, id_permiso) VALUES (1, 11);
INSERT INTO vida_salud.rol_permiso (id_rol, id_permiso) VALUES (1, 12);
INSERT INTO vida_salud.rol_permiso (id_rol, id_permiso) VALUES (2, 1);
INSERT INTO vida_salud.rol_permiso (id_rol, id_permiso) VALUES (2, 5);
INSERT INTO vida_salud.rol_permiso (id_rol, id_permiso) VALUES (2, 9);
INSERT INTO vida_salud.rol_permiso (id_rol, id_permiso) VALUES (2, 11);
INSERT INTO vida_salud.rol_permiso (id_rol, id_permiso) VALUES (3, 1);
INSERT INTO vida_salud.rol_permiso (id_rol, id_permiso) VALUES (3, 5);
INSERT INTO vida_salud.rol_permiso (id_rol, id_permiso) VALUES (3, 9);
INSERT INTO vida_salud.rol_permiso (id_rol, id_permiso) VALUES (3, 10);


--
-- Data for Name: sesion; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.sesion (id_sesion, id_usuario, ip_address, user_agent, payload, activa, created_at, updated_at, fecha_inicio, ultima_actividad, fecha_cierre, ip) VALUES ('27c4c9dc3d9e4bdfa36e04e02f65ace251cebbabbc6450e834f90898d10ed34f', 1, NULL, NULL, NULL, true, '2026-11-09 03:08:04.424074+00', '2026-11-09 03:08:04.424074+00', '2026-11-09 03:11:26+00', '2026-11-09 03:11:26+00', NULL, '127.0.0.1');
INSERT INTO vida_salud.sesion (id_sesion, id_usuario, ip_address, user_agent, payload, activa, created_at, updated_at, fecha_inicio, ultima_actividad, fecha_cierre, ip) VALUES ('0IZMRyctZB0fYeaxx3dl4a5I7ueXNrb6Q6NutZeT', 2, NULL, NULL, NULL, true, '2026-11-09 19:46:58.114222+00', '2026-11-09 19:46:58.114222+00', '2026-11-09 19:46:58+00', '2026-11-09 19:46:58+00', NULL, '127.0.0.1');
INSERT INTO vida_salud.sesion (id_sesion, id_usuario, ip_address, user_agent, payload, activa, created_at, updated_at, fecha_inicio, ultima_actividad, fecha_cierre, ip) VALUES ('1f13e823d43cdbc1479429d9dfe3a9a216d7466ad4e9d7f42622e6122cfcd0d6', 2, NULL, NULL, NULL, false, '2026-11-09 19:46:58.085955+00', '2026-11-09 19:46:58.085955+00', '2026-11-09 19:46:58+00', '2026-11-09 19:46:58+00', '2026-11-09 23:47:48+00', '127.0.0.1');


--
-- Data for Name: token_recuperacion; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.token_recuperacion (id_token, id_usuario, token_hash, fecha_generacion, fecha_expiracion, usado) VALUES (1, 1, '91b4d142823f7d20c5f08df69122de43f35f057a988d9619f6d3138485c9a203', '2026-11-08 03:11:26+00', '2026-11-08 04:11:26+00', true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: vida_salud; Owner: -
--



--
-- Data for Name: usuario; Type: TABLE DATA; Schema: vida_salud; Owner: -
--

INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (16, 17, 3, 'lantelo', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-09 02:59:56.861132+00', '2026-11-09 02:59:56.861132+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (3, 4, 1, 'admin', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:35+00', '2026-11-10 11:10:35+00', NULL, '2026-11-09 02:59:56.829044+00', '2026-11-09 02:59:56.829044+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (4, 5, 2, 'rvaca', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:35+00', '2026-11-10 11:10:35+00', NULL, '2026-11-09 02:59:56.830798+00', '2026-11-09 02:59:56.830798+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (5, 6, 2, 'csuarez', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:35+00', '2026-11-10 11:10:35+00', NULL, '2026-11-09 02:59:56.832723+00', '2026-11-09 02:59:56.832723+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (6, 7, 2, 'jmendoza', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-09 02:59:56.835645+00', '2026-11-09 02:59:56.835645+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (17, 18, 3, 'reguez', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-09 02:59:56.864736+00', '2026-11-09 02:59:56.864736+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (18, 19, 3, 'hflores', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'INACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-09 02:59:56.867312+00', '2026-11-09 02:59:56.867312+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (19, 20, 3, 'dr.perez', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-09 02:59:56.873223+00', '2026-11-09 02:59:56.873223+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (20, 91, 3, 'dr.villarroel', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-10 09:57:27.344124+00', '2026-11-10 09:57:27.344124+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (21, 92, 3, 'dr.camacho', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-10 09:57:27.359225+00', '2026-11-10 09:57:27.359225+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (22, 93, 3, 'dr.zeballos', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-10 09:57:27.363215+00', '2026-11-10 09:57:27.363215+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (29, 100, 3, 'dr.saldana', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-10 09:57:27.382747+00', '2026-11-10 09:57:27.382747+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (30, 24, 4, 'paciente', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-10 11:10:36.146853+00', '2026-11-10 11:10:36.146853+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (7, 8, 2, 'djustiniano', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-09 02:59:56.837646+00', '2026-11-09 02:59:56.837646+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (8, 9, 2, 'recepcion', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-09 02:59:56.8395+00', '2026-11-09 02:59:56.8395+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (9, 10, 3, 'jrojas', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-09 02:59:56.841342+00', '2026-11-09 02:59:56.841342+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (10, 11, 3, 'pgutierrez', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-09 02:59:56.844037+00', '2026-11-09 02:59:56.844037+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (11, 12, 3, 'farteaga', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-09 02:59:56.845963+00', '2026-11-09 02:59:56.845963+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (12, 13, 3, 'cmontero', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-09 02:59:56.847749+00', '2026-11-09 02:59:56.847749+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (13, 14, 3, 'mterceros', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-09 02:59:56.849887+00', '2026-11-09 02:59:56.849887+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (1, 2, 1, 'scolque', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:35+00', '2026-11-10 11:10:35+00', NULL, '2026-11-09 02:59:56.819959+00', '2026-11-09 02:59:56.819959+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (2, 3, 1, 'rrivero', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:35+00', '2026-11-10 11:10:35+00', 'LwgKlgFbvh3cpt3zE2yF5ycnZHlAg9wWjH8YCXJKwFqsidT8LkUFDMgcqHah', '2026-11-09 02:59:56.826963+00', '2026-11-09 02:59:56.826963+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (14, 15, 3, 'gpena', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-09 02:59:56.853666+00', '2026-11-09 02:59:56.853666+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (15, 16, 3, 'amoreno', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-09 02:59:56.856462+00', '2026-11-09 02:59:56.856462+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (23, 94, 3, 'dr.hurtado', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-10 09:57:27.366495+00', '2026-11-10 09:57:27.366495+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (24, 95, 3, 'dr.paz', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-10 09:57:27.368741+00', '2026-11-10 09:57:27.368741+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (25, 96, 3, 'dr.torrico', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-10 09:57:27.37093+00', '2026-11-10 09:57:27.37093+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (26, 97, 3, 'dr.morales', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-10 09:57:27.373315+00', '2026-11-10 09:57:27.373315+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (27, 98, 3, 'dr.anez', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-10 09:57:27.376157+00', '2026-11-10 09:57:27.376157+00');
INSERT INTO vida_salud.usuario (id_usuario, id_persona, id_rol, nombre_usuario, hash_contrasena, estado, intentos_fallidos, bloqueado_hasta, fecha_bloqueo, ultimo_acceso, fecha_creacion, remember_token, created_at, updated_at) VALUES (28, 99, 3, 'dr.rivera', '$2y$12$YAIaxefnpp.nGKVfSont6OKbrq1JGKtJ5Wx397SbmQmGB/IwbjQUO', 'ACTIVO', 0, NULL, NULL, '2026-11-10 11:10:36+00', '2026-11-10 11:10:36+00', NULL, '2026-11-10 09:57:27.379892+00', '2026-11-10 09:57:27.379892+00');


--
-- Name: bitacora_id_bitacora_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.bitacora_id_bitacora_seq', 3, true);


--
-- Name: bloqueo_agenda_id_bloqueo_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.bloqueo_agenda_id_bloqueo_seq', 3, true);


--
-- Name: cita_id_cita_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.cita_id_cita_seq', 2, true);


--
-- Name: comprobante_pago_id_comprobante_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.comprobante_pago_id_comprobante_seq', 1, true);


--
-- Name: contacto_emergencia_id_contacto_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.contacto_emergencia_id_contacto_seq', 71, true);


--
-- Name: especialidad_id_especialidad_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.especialidad_id_especialidad_seq', 16, true);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.failed_jobs_id_seq', 1, false);


--
-- Name: historial_estado_cita_id_historial_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.historial_estado_cita_id_historial_seq', 1, true);


--
-- Name: horario_id_horario_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.horario_id_horario_seq', 100, true);


--
-- Name: informacion_medica_id_info_medica_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.informacion_medica_id_info_medica_seq', 70, true);


--
-- Name: informacion_medica_id_informacion_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.informacion_medica_id_informacion_seq', 70, true);


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.jobs_id_seq', 1, false);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.migrations_id_seq', 29, true);


--
-- Name: notificacion_id_notificacion_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.notificacion_id_notificacion_seq', 2, true);


--
-- Name: pago_id_pago_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.pago_id_pago_seq', 1, true);


--
-- Name: permiso_id_permiso_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.permiso_id_permiso_seq', 12, true);


--
-- Name: persona_id_persona_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.persona_id_persona_seq', 100, true);


--
-- Name: recuperacion_contrasena_id_recuperacion_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.recuperacion_contrasena_id_recuperacion_seq', 2, true);


--
-- Name: reembolso_id_reembolso_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.reembolso_id_reembolso_seq', 1, false);


--
-- Name: reporte_id_reporte_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.reporte_id_reporte_seq', 3, true);


--
-- Name: rol_id_rol_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.rol_id_rol_seq', 4, true);


--
-- Name: token_recuperacion_id_token_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.token_recuperacion_id_token_seq', 1, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.users_id_seq', 1, false);


--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE SET; Schema: vida_salud; Owner: -
--

SELECT pg_catalog.setval('vida_salud.usuario_id_usuario_seq', 30, true);


--
-- Name: bitacora bitacora_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.bitacora
    ADD CONSTRAINT bitacora_pkey PRIMARY KEY (id_bitacora);


--
-- Name: bloqueo_agenda bloqueo_agenda_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.bloqueo_agenda
    ADD CONSTRAINT bloqueo_agenda_pkey PRIMARY KEY (id_bloqueo);


--
-- Name: cache_locks cache_locks_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.cache_locks
    ADD CONSTRAINT cache_locks_pkey PRIMARY KEY (key);


--
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);


--
-- Name: cita cita_codigo_unico; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.cita
    ADD CONSTRAINT cita_codigo_unico UNIQUE (codigo);


--
-- Name: cita cita_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.cita
    ADD CONSTRAINT cita_pkey PRIMARY KEY (id_cita);


--
-- Name: comprobante_pago comprobante_numero_unico; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.comprobante_pago
    ADD CONSTRAINT comprobante_numero_unico UNIQUE (numero);


--
-- Name: comprobante_pago comprobante_pago_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.comprobante_pago
    ADD CONSTRAINT comprobante_pago_pkey PRIMARY KEY (id_comprobante);


--
-- Name: comprobante_pago comprobante_pago_unico; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.comprobante_pago
    ADD CONSTRAINT comprobante_pago_unico UNIQUE (id_pago);


--
-- Name: contacto_emergencia contacto_emergencia_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.contacto_emergencia
    ADD CONSTRAINT contacto_emergencia_pkey PRIMARY KEY (id_contacto);


--
-- Name: especialidad especialidad_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.especialidad
    ADD CONSTRAINT especialidad_pkey PRIMARY KEY (id_especialidad);


--
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- Name: historial_estado_cita historial_estado_cita_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.historial_estado_cita
    ADD CONSTRAINT historial_estado_cita_pkey PRIMARY KEY (id_historial);


--
-- Name: horario horario_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.horario
    ADD CONSTRAINT horario_pkey PRIMARY KEY (id_horario);


--
-- Name: informacion_medica info_medica_paciente_unica; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.informacion_medica
    ADD CONSTRAINT info_medica_paciente_unica UNIQUE (id_paciente);


--
-- Name: informacion_medica informacion_medica_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.informacion_medica
    ADD CONSTRAINT informacion_medica_pkey PRIMARY KEY (id_info_medica);


--
-- Name: job_batches job_batches_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.job_batches
    ADD CONSTRAINT job_batches_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: medico medico_codigo_unico; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.medico
    ADD CONSTRAINT medico_codigo_unico UNIQUE (codigo);


--
-- Name: medico_especialidad medico_especialidad_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.medico_especialidad
    ADD CONSTRAINT medico_especialidad_pkey PRIMARY KEY (id_medico, id_especialidad);


--
-- Name: medico medico_matricula_unica; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.medico
    ADD CONSTRAINT medico_matricula_unica UNIQUE (matricula);


--
-- Name: medico medico_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.medico
    ADD CONSTRAINT medico_pkey PRIMARY KEY (id_persona);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: notificacion notificacion_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.notificacion
    ADD CONSTRAINT notificacion_pkey PRIMARY KEY (id_notificacion);


--
-- Name: paciente paciente_codigo_unico; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.paciente
    ADD CONSTRAINT paciente_codigo_unico UNIQUE (codigo);


--
-- Name: paciente paciente_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.paciente
    ADD CONSTRAINT paciente_pkey PRIMARY KEY (id_persona);


--
-- Name: pago pago_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.pago
    ADD CONSTRAINT pago_pkey PRIMARY KEY (id_pago);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);


--
-- Name: permiso permiso_nombre_unico; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.permiso
    ADD CONSTRAINT permiso_nombre_unico UNIQUE (nombre);


--
-- Name: permiso permiso_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.permiso
    ADD CONSTRAINT permiso_pkey PRIMARY KEY (id_permiso);


--
-- Name: persona persona_ci_unico; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.persona
    ADD CONSTRAINT persona_ci_unico UNIQUE (ci);


--
-- Name: persona persona_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.persona
    ADD CONSTRAINT persona_pkey PRIMARY KEY (id_persona);


--
-- Name: personal_administrativo personal_administrativo_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.personal_administrativo
    ADD CONSTRAINT personal_administrativo_pkey PRIMARY KEY (id_persona);


--
-- Name: recuperacion_contrasena recuperacion_contrasena_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.recuperacion_contrasena
    ADD CONSTRAINT recuperacion_contrasena_pkey PRIMARY KEY (id_recuperacion);


--
-- Name: recuperacion_contrasena recuperacion_contrasena_token_hash_unique; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.recuperacion_contrasena
    ADD CONSTRAINT recuperacion_contrasena_token_hash_unique UNIQUE (token_hash);


--
-- Name: reembolso reembolso_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.reembolso
    ADD CONSTRAINT reembolso_pkey PRIMARY KEY (id_reembolso);


--
-- Name: reporte reporte_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.reporte
    ADD CONSTRAINT reporte_pkey PRIMARY KEY (id_reporte);


--
-- Name: rol rol_nombre_unico; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.rol
    ADD CONSTRAINT rol_nombre_unico UNIQUE (nombre);


--
-- Name: rol_permiso rol_permiso_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.rol_permiso
    ADD CONSTRAINT rol_permiso_pkey PRIMARY KEY (id_rol, id_permiso);


--
-- Name: rol rol_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (id_rol);


--
-- Name: sesion sesion_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.sesion
    ADD CONSTRAINT sesion_pkey PRIMARY KEY (id_sesion);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: token_recuperacion token_recuperacion_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.token_recuperacion
    ADD CONSTRAINT token_recuperacion_pkey PRIMARY KEY (id_token);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: usuario usuario_nombre_unico; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.usuario
    ADD CONSTRAINT usuario_nombre_unico UNIQUE (nombre_usuario);


--
-- Name: usuario usuario_persona_unica; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.usuario
    ADD CONSTRAINT usuario_persona_unica UNIQUE (id_persona);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);


--
-- Name: cache_expiration_index; Type: INDEX; Schema: vida_salud; Owner: -
--

CREATE INDEX cache_expiration_index ON vida_salud.cache USING btree (expiration);


--
-- Name: cache_locks_expiration_index; Type: INDEX; Schema: vida_salud; Owner: -
--

CREATE INDEX cache_locks_expiration_index ON vida_salud.cache_locks USING btree (expiration);


--
-- Name: especialidad_nombre_unico_ci; Type: INDEX; Schema: vida_salud; Owner: -
--

CREATE UNIQUE INDEX especialidad_nombre_unico_ci ON vida_salud.especialidad USING btree (lower(btrim((nombre)::text)));


--
-- Name: failed_jobs_connection_queue_failed_at_index; Type: INDEX; Schema: vida_salud; Owner: -
--

CREATE INDEX failed_jobs_connection_queue_failed_at_index ON vida_salud.failed_jobs USING btree (connection, queue, failed_at);


--
-- Name: idx_bitacora_fecha; Type: INDEX; Schema: vida_salud; Owner: -
--

CREATE INDEX idx_bitacora_fecha ON vida_salud.bitacora USING btree (fecha_hora DESC);


--
-- Name: idx_cita_medico_fecha; Type: INDEX; Schema: vida_salud; Owner: -
--

CREATE INDEX idx_cita_medico_fecha ON vida_salud.cita USING btree (id_medico, fecha, hora_inicio);


--
-- Name: idx_cita_paciente_fecha; Type: INDEX; Schema: vida_salud; Owner: -
--

CREATE INDEX idx_cita_paciente_fecha ON vida_salud.cita USING btree (id_paciente, fecha);


--
-- Name: idx_pago_cita; Type: INDEX; Schema: vida_salud; Owner: -
--

CREATE INDEX idx_pago_cita ON vida_salud.pago USING btree (id_cita);


--
-- Name: jobs_queue_index; Type: INDEX; Schema: vida_salud; Owner: -
--

CREATE INDEX jobs_queue_index ON vida_salud.jobs USING btree (queue);


--
-- Name: persona_email_unico_ci; Type: INDEX; Schema: vida_salud; Owner: -
--

CREATE UNIQUE INDEX persona_email_unico_ci ON vida_salud.persona USING btree (lower(btrim((email)::text))) WHERE (email IS NOT NULL);


--
-- Name: sessions_last_activity_index; Type: INDEX; Schema: vida_salud; Owner: -
--

CREATE INDEX sessions_last_activity_index ON vida_salud.sessions USING btree (last_activity);


--
-- Name: sessions_user_id_index; Type: INDEX; Schema: vida_salud; Owner: -
--

CREATE INDEX sessions_user_id_index ON vida_salud.sessions USING btree (user_id);


--
-- Name: bitacora fk_bitacora_usuario; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.bitacora
    ADD CONSTRAINT fk_bitacora_usuario FOREIGN KEY (id_usuario) REFERENCES vida_salud.usuario(id_usuario) ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: bloqueo_agenda fk_bloqueo_medico; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.bloqueo_agenda
    ADD CONSTRAINT fk_bloqueo_medico FOREIGN KEY (id_medico) REFERENCES vida_salud.medico(id_persona) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: cita fk_cita_especialidad; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.cita
    ADD CONSTRAINT fk_cita_especialidad FOREIGN KEY (id_especialidad) REFERENCES vida_salud.especialidad(id_especialidad) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
-- Name: cita fk_cita_medico; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.cita
    ADD CONSTRAINT fk_cita_medico FOREIGN KEY (id_medico) REFERENCES vida_salud.medico(id_persona) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
-- Name: cita fk_cita_paciente; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.cita
    ADD CONSTRAINT fk_cita_paciente FOREIGN KEY (id_paciente) REFERENCES vida_salud.paciente(id_persona) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
-- Name: cita fk_cita_usuario_registro; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.cita
    ADD CONSTRAINT fk_cita_usuario_registro FOREIGN KEY (id_usuario_registro) REFERENCES vida_salud.usuario(id_usuario) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
-- Name: comprobante_pago fk_comprobante_pago; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.comprobante_pago
    ADD CONSTRAINT fk_comprobante_pago FOREIGN KEY (id_pago) REFERENCES vida_salud.pago(id_pago) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contacto_emergencia fk_contacto_emergencia_paciente; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.contacto_emergencia
    ADD CONSTRAINT fk_contacto_emergencia_paciente FOREIGN KEY (id_paciente) REFERENCES vida_salud.paciente(id_persona) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: historial_estado_cita fk_historial_cita; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.historial_estado_cita
    ADD CONSTRAINT fk_historial_cita FOREIGN KEY (id_cita) REFERENCES vida_salud.cita(id_cita) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: historial_estado_cita fk_historial_usuario; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.historial_estado_cita
    ADD CONSTRAINT fk_historial_usuario FOREIGN KEY (id_usuario) REFERENCES vida_salud.usuario(id_usuario) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
-- Name: horario fk_horario_medico; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.horario
    ADD CONSTRAINT fk_horario_medico FOREIGN KEY (id_medico) REFERENCES vida_salud.medico(id_persona) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: informacion_medica fk_info_medica_paciente; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.informacion_medica
    ADD CONSTRAINT fk_info_medica_paciente FOREIGN KEY (id_paciente) REFERENCES vida_salud.paciente(id_persona) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: medico_especialidad fk_medico_especialidad_especialidad; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.medico_especialidad
    ADD CONSTRAINT fk_medico_especialidad_especialidad FOREIGN KEY (id_especialidad) REFERENCES vida_salud.especialidad(id_especialidad) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
-- Name: medico_especialidad fk_medico_especialidad_medico; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.medico_especialidad
    ADD CONSTRAINT fk_medico_especialidad_medico FOREIGN KEY (id_medico) REFERENCES vida_salud.medico(id_persona) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: medico fk_medico_persona; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.medico
    ADD CONSTRAINT fk_medico_persona FOREIGN KEY (id_persona) REFERENCES vida_salud.persona(id_persona) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notificacion fk_notificacion_cita; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.notificacion
    ADD CONSTRAINT fk_notificacion_cita FOREIGN KEY (id_cita) REFERENCES vida_salud.cita(id_cita) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notificacion fk_notificacion_usuario_gestion; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.notificacion
    ADD CONSTRAINT fk_notificacion_usuario_gestion FOREIGN KEY (id_usuario_gestion) REFERENCES vida_salud.usuario(id_usuario) ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: paciente fk_paciente_persona; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.paciente
    ADD CONSTRAINT fk_paciente_persona FOREIGN KEY (id_persona) REFERENCES vida_salud.persona(id_persona) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pago fk_pago_cita; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.pago
    ADD CONSTRAINT fk_pago_cita FOREIGN KEY (id_cita) REFERENCES vida_salud.cita(id_cita) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pago fk_pago_usuario_registro; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.pago
    ADD CONSTRAINT fk_pago_usuario_registro FOREIGN KEY (id_usuario_registro) REFERENCES vida_salud.usuario(id_usuario) ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: personal_administrativo fk_personal_admin_persona; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.personal_administrativo
    ADD CONSTRAINT fk_personal_admin_persona FOREIGN KEY (id_persona) REFERENCES vida_salud.persona(id_persona) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: reembolso fk_reembolso_pago; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.reembolso
    ADD CONSTRAINT fk_reembolso_pago FOREIGN KEY (id_pago) REFERENCES vida_salud.pago(id_pago) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
-- Name: reembolso fk_reembolso_usuario_autoriza; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.reembolso
    ADD CONSTRAINT fk_reembolso_usuario_autoriza FOREIGN KEY (id_usuario_autoriza) REFERENCES vida_salud.usuario(id_usuario) ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: reporte fk_reporte_usuario_generador; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.reporte
    ADD CONSTRAINT fk_reporte_usuario_generador FOREIGN KEY (id_usuario_generador) REFERENCES vida_salud.usuario(id_usuario) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rol_permiso fk_rol_permiso_permiso; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.rol_permiso
    ADD CONSTRAINT fk_rol_permiso_permiso FOREIGN KEY (id_permiso) REFERENCES vida_salud.permiso(id_permiso) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rol_permiso fk_rol_permiso_rol; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.rol_permiso
    ADD CONSTRAINT fk_rol_permiso_rol FOREIGN KEY (id_rol) REFERENCES vida_salud.rol(id_rol) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: sesion fk_sesion_usuario; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.sesion
    ADD CONSTRAINT fk_sesion_usuario FOREIGN KEY (id_usuario) REFERENCES vida_salud.usuario(id_usuario) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: token_recuperacion fk_token_recuperacion_usuario; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.token_recuperacion
    ADD CONSTRAINT fk_token_recuperacion_usuario FOREIGN KEY (id_usuario) REFERENCES vida_salud.usuario(id_usuario) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: usuario fk_usuario_persona; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.usuario
    ADD CONSTRAINT fk_usuario_persona FOREIGN KEY (id_persona) REFERENCES vida_salud.persona(id_persona) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
-- Name: usuario fk_usuario_rol; Type: FK CONSTRAINT; Schema: vida_salud; Owner: -
--

ALTER TABLE ONLY vida_salud.usuario
    ADD CONSTRAINT fk_usuario_rol FOREIGN KEY (id_rol) REFERENCES vida_salud.rol(id_rol) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--


