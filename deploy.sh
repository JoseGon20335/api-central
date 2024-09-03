#!/bin/bash

echo "Deploying API Central..."

# Obtener el primer parámetro (si está presente)
SEED_DB=${1:-0}  # Por defecto, SEED_DB es 0 si no se proporciona

echo "Pulling changes from GitHub..."
git pull https://JoseGon20335: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@github.com/JoseGon20335/api-central.git

echo "Activating virtual environment..."
source venv/bin/activate

echo "Making migrations and updating database..."
flask db migrate -m "Agregar tabla Dictionary y actualizar modelos"

echo "Upgrading database..."
flask db upgrade

# Recarga los archivos de configuracion 
echo "Reloading configuration files..."
sudo systemctl daemon-reload

# Reinicia el servicio de la aplicacion
echo "Restarting API Central service..."
sudo systemctl restart api-central.service

# Actualizar Nginx (si es necesario):
echo "Restarting Nginx..."
sudo systemctl restart nginx

# Ejecutar el seed solo si el parámetro SEED_DB es 1
if [ "$SEED_DB" -eq 1 ]; then
    echo "Running seed script..."
    python seed.py
else
    echo "Skipping seed script."
fi

echo "Deployment complete!"