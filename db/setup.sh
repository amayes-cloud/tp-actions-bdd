
#!/usr/bin/env bash

set -euo pipefail

echo ">> Démarrage de PostgreSQL"
sudo systemctl start postgresql.service

echo ">> Attente du serveur (15 secondes maximum)"
for i in $(seq 1 15); do
    if pg_isready -h localhost -p 5432; then
        break
    fi
    sleep 1
done

pg_isready -h localhost -p 5432

echo ">> Configuration du mot de passe postgres"
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"

echo ">> Création de la base tp"
sudo -u postgres createdb tp

echo ">> Création de la table students"
PGPASSWORD=postgres psql -h localhost -U postgres -d tp \
    -v ON_ERROR_STOP=1 \
    -f "$(dirname "$0")/init.sql"
