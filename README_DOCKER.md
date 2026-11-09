# Despliegue con Docker — Clínica Vida Salud (Frontend + Backend + Base de Datos)

Este proyecto está completamente empaquetado para levantarse en cualquier entorno (Windows, Linux, macOS o servidor en la nube) con un solo comando utilizando Docker y Docker Compose, sin errores al clonar desde Git.

---

## Servicios incluidos en Docker (`docker-compose.yml`)

1. **`vidasalud-web` (`nginx:alpine`):**
   - Servidor web HTTP en el puerto `8002` (`http://localhost:8002`).
   - Sirve el Frontend (`Frontend/nueva_interfaces/index.html` y `public/build`) y conecta por FastCGI con el Backend de Laravel.
2. **`vidasalud-app` (`PHP 8.3 FPM Alpine` + Node/NPM + PostgreSQL Client):**
   - PHP 8.3 con extensiones completas: `pdo_pgsql`, `pgsql`, `intl`, `zip`, `bcmath`, `gd`, `opcache`.
   - Dependencias de Composer y assets de Frontend pre-empaquetados en la imagen (`/opt/vendor_backup` y `/opt/build_backup`) para restaurarse automáticamente al clonar el repositorio con `git clone`.
   - Script de entrada (`docker/entrypoint.sh`) con saltos de línea LF garantizados que configura `.env`, permisos y sincroniza la base de datos automáticamente.
3. **`vidasalud-db` (`postgres:16-alpine`):**
   - Base de datos: `Clinica_Vida_Salud`
   - Puerto local mapeado: `5433` (interno `5432`)
   - Usuario: `postgres` / Contraseña: `belen0506`
   - Inicializada automáticamente desde `docker/postgres/init/01_schema.sql` y `database/clinica_vida_salud_dump.sql` con las 34 tablas del esquema `vida_salud`, triggers, procedimientos almacenados, más de 60 pacientes, médicos, horarios, citas, pagos y bitácora.

---

## Cómo clonar e iniciar el proyecto desde Git

1. **Clonar la rama `prueba` del repositorio:**
   ```bash
   git clone -b prueba https://github.com/SILVIAIRENE/Sistema-de-gestion-de-citas-medicas-.git
   cd Sistema-de-gestion-de-citas-medicas-
   ```

2. **Construir e iniciar los contenedores (Frontend + Backend + Base de Datos):**
   ```bash
   docker compose up -d --build
   ```

3. **Abrir la aplicación en el navegador:**
   - **Acceso Directo Principal (Login / Panel Completo):**  
     [http://localhost:8002](http://localhost:8002)
   - **Ruta Directa Frontend:**  
     [http://localhost:8002/Frontend/nueva_interfaces/index.html](http://localhost:8002/Frontend/nueva_interfaces/index.html)

---

## Credenciales de Acceso por Rol

| Rol | Usuario | Contraseña |
|---|---|---|
| **Administrador** | `rrivero` | `Admin123*` |
| **Administradora** | `scolque` | `Admin123*` |
| **Recepcionista** | `rvaca` | `Admin123*` |
| **Recepcionista** | `csuarez` | `Admin123*` |
| **Médico Especialista** | `jrojas` | `Admin123*` |


