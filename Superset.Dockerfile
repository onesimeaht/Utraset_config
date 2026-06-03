FROM apache/superset:latest

USER root

# Installation du driver PostgreSQL dans l'environnement virtuel de Superset
RUN pip install psycopg2-binary --target $(python -c "import sys; print([p for p in sys.path if 'site-packages' in p and '.venv' in p][0])")

USER superset