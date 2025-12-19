# Airflow + dlt Pipeline

Pipeline de datos que extrae información de GitHub usando dlt y lo carga a AWS S3.

## Configuración

### 1. Instalar dependencias

```bash
uv sync
```

### 2. Configurar credenciales

Copia el archivo de ejemplo y agrega tus credenciales:

```bash
cp .dlt/secrets.toml.example .dlt/secrets.toml
```

Edita `.dlt/secrets.toml` con:
- Tu GitHub access token
- Tu bucket de S3
- Tus credenciales de AWS (access key y secret key)

### 3. Ejecutar con Docker

```bash
docker-compose up --build
```

Airflow estará disponible en: http://localhost:8080
- Usuario: `admin`
- Contraseña: `admin`

### 4. Ejecutar el pipeline manualmente (sin Docker)

```bash
uv run python airflow_dlt_pipeline.py
```

## Estructura del proyecto

- `airflow_dlt_pipeline.py` - Pipeline principal de dlt
- `dags/` - DAGs de Airflow
- `.dlt/` - Configuración y secretos de dlt
- `docker-compose.yml` - Configuración de Docker
- `Dockerfile` - Imagen de Docker para Airflow

## Recursos extraídos

El pipeline extrae los siguientes recursos de GitHub:
- Repositorios de la organización dlt-hub
- Contribuidores del repo dlt-hub/dlt
- Issues (incremental)
- Forks (incremental con backfill)
- Releases

Los datos se guardan en formato Parquet en S3.
