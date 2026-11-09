#!/bin/sh
set -e

# 1. Restaurar o instalar dependencias de Composer si el volumen local montado tras git clone no tiene vendor/
if [ ! -f /var/www/html/vendor/autoload.php ]; then
    if [ -d /opt/vendor_backup ]; then
        echo "Restaurando dependencias de Composer pre-empaquetadas en la imagen..."
        cp -a /opt/vendor_backup /var/www/html/vendor
    else
        echo "Instalando dependencias de Composer..."
        composer install --no-dev --optimize-autoloader --no-interaction
    fi
fi

# 2. Restaurar assets compilados de Frontend (public/build) si no existen en el host
if [ ! -f /var/www/html/public/build/manifest.json ] && [ -d /opt/build_backup ]; then
    echo "Restaurando assets compilados de Frontend..."
    mkdir -p /var/www/html/public
    cp -a /opt/build_backup /var/www/html/public/build
fi

# 3. Sincronizar Frontend/nueva_interfaces hacia public/Frontend/nueva_interfaces
if [ -d /var/www/html/Frontend/nueva_interfaces ]; then
    mkdir -p /var/www/html/public/Frontend/nueva_interfaces
    cp -rf /var/www/html/Frontend/nueva_interfaces/* /var/www/html/public/Frontend/nueva_interfaces/ 2>/dev/null || true
fi

# 4. Crear archivo .env si no existe tras git clone
if [ ! -f /var/www/html/.env ]; then
    if [ -f /var/www/html/.env.docker.example ]; then
        cp /var/www/html/.env.docker.example /var/www/html/.env
    elif [ -f /var/www/html/.env.example ]; then
        cp /var/www/html/.env.example /var/www/html/.env
    fi
fi

# 5. Generar APP_KEY si falta
if [ -f /var/www/html/.env ] && ! grep -q "^APP_KEY=base64:" /var/www/html/.env; then
    php artisan key:generate --force || true
fi

# 6. Crear directorios y permisos para storage, cache y base de datos
mkdir -p /var/www/html/storage/framework/cache/data \
         /var/www/html/storage/framework/sessions \
         /var/www/html/storage/framework/views \
         /var/www/html/storage/logs \
         /var/www/html/bootstrap/cache \
         /var/www/html/database

chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/database 2>/dev/null || true

# 7. En entorno Docker Compose (DB_HOST=db), verificar que PostgreSQL tenga cargado el esquema y datos completos
if [ -z "$PORT" ] && [ "${DB_CONNECTION:-pgsql}" = "pgsql" ]; then
    DB_H="${DB_HOST:-db}"
    DB_P="${DB_PORT:-5432}"
    DB_U="${DB_USERNAME:-postgres}"
    DB_D="${DB_DATABASE:-Clinica_Vida_Salud}"
    export PGPASSWORD="${DB_PASSWORD:-belen0506}"

    echo "Esperando disponibilidad de PostgreSQL en ${DB_H}:${DB_P}..."
    TRIES=0
    until pg_isready -h "$DB_H" -p "$DB_P" -U "$DB_U" >/dev/null 2>&1 || [ $TRIES -ge 25 ]; do
        TRIES=$((TRIES + 1))
        sleep 1
    done

    if pg_isready -h "$DB_H" -p "$DB_P" -U "$DB_U" >/dev/null 2>&1; then
        USER_COUNT=$(psql -h "$DB_H" -p "$DB_P" -U "$DB_U" -d "$DB_D" -tAc "SELECT COUNT(*) FROM vida_salud.usuario;" 2>/dev/null || echo "0")
        if [ -z "$USER_COUNT" ] || [ "$USER_COUNT" = "0" ]; then
            if [ -f /var/www/html/database/clinica_vida_salud_dump.sql ]; then
                echo "Cargando base de datos completa Clinica_Vida_Salud desde database/clinica_vida_salud_dump.sql..."
                psql -h "$DB_H" -p "$DB_P" -U "$DB_U" -d "$DB_D" -f /var/www/html/database/clinica_vida_salud_dump.sql >/dev/null 2>&1 || true
            fi
        fi
        php artisan migrate --force >/dev/null 2>&1 || true
    fi
fi

# 8. Ejecución automática en Railway / Cloud cuando se asigna la variable $PORT
if [ -n "$PORT" ]; then
    echo "Ambiente Cloud / Railway detectado. Puerto HTTP: $PORT"

    if [ -n "$DATABASE_URL" ]; then
        echo "Variable DATABASE_URL detectada."
        sed -i 's/^DB_CONNECTION=.*/DB_CONNECTION=pgsql/' /var/www/html/.env 2>/dev/null || true
        export DB_CONNECTION=pgsql
        export DB_SCHEMA=vida_salud,public
        sed -i 's/^DB_SCHEMA=.*/DB_SCHEMA=vida_salud,public/' /var/www/html/.env 2>/dev/null || true

        DB_U=$(echo "$DATABASE_URL" | sed -E 's|^.*://([^:]+):([^@]+)@([^:/]+):?([0-9]*)/([^?]*).*$|\1|')
        DB_P=$(echo "$DATABASE_URL" | sed -E 's|^.*://([^:]+):([^@]+)@([^:/]+):?([0-9]*)/([^?]*).*$|\2|')
        DB_H=$(echo "$DATABASE_URL" | sed -E 's|^.*://([^:]+):([^@]+)@([^:/]+):?([0-9]*)/([^?]*).*$|\3|')
        DB_PORT_VAL=$(echo "$DATABASE_URL" | sed -E 's|^.*://([^:]+):([^@]+)@([^:/]+):?([0-9]*)/([^?]*).*$|\4|')
        DB_D=$(echo "$DATABASE_URL" | sed -E 's|^.*://([^:]+):([^@]+)@([^:/]+):?([0-9]*)/([^?]*).*$|\5|')
        [ -z "$DB_PORT_VAL" ] && DB_PORT_VAL="5432"

        if [ -n "$DB_H" ] && [ "$DB_H" != "$DATABASE_URL" ]; then
            sed -i "s|^DB_HOST=.*|DB_HOST=$DB_H|" /var/www/html/.env 2>/dev/null || true
            sed -i "s|^DB_PORT=.*|DB_PORT=$DB_PORT_VAL|" /var/www/html/.env 2>/dev/null || true
            sed -i "s|^DB_DATABASE=.*|DB_DATABASE=$DB_D|" /var/www/html/.env 2>/dev/null || true
            sed -i "s|^DB_USERNAME=.*|DB_USERNAME=$DB_U|" /var/www/html/.env 2>/dev/null || true
            sed -i "s|^DB_PASSWORD=.*|DB_PASSWORD=$DB_P|" /var/www/html/.env 2>/dev/null || true
            export DB_HOST="$DB_H"
            export DB_PORT="$DB_PORT_VAL"
            export DB_DATABASE="$DB_D"
            export DB_USERNAME="$DB_U"
            export DB_PASSWORD="$DB_P"
        fi
    fi

    if [ -n "$PGHOST" ]; then
        echo "Variable PGHOST detectada: $PGHOST"
        sed -i 's/^DB_CONNECTION=.*/DB_CONNECTION=pgsql/' /var/www/html/.env 2>/dev/null || true
        sed -i "s|^DB_HOST=.*|DB_HOST=$PGHOST|" /var/www/html/.env 2>/dev/null || true
        [ -n "$PGPORT" ] && sed -i "s|^DB_PORT=.*|DB_PORT=$PGPORT|" /var/www/html/.env 2>/dev/null || true
        [ -n "$PGDATABASE" ] && sed -i "s|^DB_DATABASE=.*|DB_DATABASE=$PGDATABASE|" /var/www/html/.env 2>/dev/null || true
        [ -n "$PGUSER" ] && sed -i "s|^DB_USERNAME=.*|DB_USERNAME=$PGUSER|" /var/www/html/.env 2>/dev/null || true
        [ -n "$PGPASSWORD" ] && sed -i "s|^DB_PASSWORD=.*|DB_PASSWORD=$PGPASSWORD|" /var/www/html/.env 2>/dev/null || true
        sed -i 's/^DB_SCHEMA=.*/DB_SCHEMA=vida_salud,public/' /var/www/html/.env 2>/dev/null || true
        export DB_CONNECTION=pgsql
        export DB_HOST="$PGHOST"
        [ -n "$PGPORT" ] && export DB_PORT="$PGPORT"
        [ -n "$PGDATABASE" ] && export DB_DATABASE="$PGDATABASE"
        [ -n "$PGUSER" ] && export DB_USERNAME="$PGUSER"
        [ -n "$PGPASSWORD" ] && export DB_PASSWORD="$PGPASSWORD"
        export DB_SCHEMA=vida_salud,public
    fi

    DB_STATUS=0
    php artisan db:show >/dev/null 2>&1 || DB_STATUS=$?

    if [ $DB_STATUS -ne 0 ]; then
        echo "AVISO: No se pudo conectar al host de PostgreSQL configurado (DB_HOST=${DB_HOST:-db})."
        echo "Activando almacenamiento seguro SQLite interno para garantizar funcionamiento inmediato..."

        touch /var/www/html/database/database.sqlite
        chmod 777 /var/www/html/database/database.sqlite 2>/dev/null || true

        sed -i 's/^DB_CONNECTION=.*/DB_CONNECTION=sqlite/' /var/www/html/.env 2>/dev/null || true
        sed -i 's/^DB_HOST=.*/#DB_HOST=/' /var/www/html/.env 2>/dev/null || true
        sed -i 's|^DB_DATABASE=.*|DB_DATABASE=/var/www/html/database/database.sqlite|' /var/www/html/.env 2>/dev/null || true

        export DB_CONNECTION=sqlite
        export DB_DATABASE=/var/www/html/database/database.sqlite
    else
        echo "Conexión a PostgreSQL establecida exitosamente."
    fi

    echo "Ejecutando migraciones de base de datos..."
    php artisan migrate --force || true

    echo "Ejecutando seeders de datos iniciales..."
    php artisan db:seed --force || true

    echo "Iniciando servidor HTTP Laravel en 0.0.0.0:$PORT..."
    exec php artisan serve --host=0.0.0.0 --port="$PORT"
fi

# Ejecutar el comando pasado como parámetro (por defecto php-fpm para Docker Compose)
exec "$@"
