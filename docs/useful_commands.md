cicd_postgres - имя контейнера
```bash
# Дамп базы из докера
docker exec -ti cicd_postgres sh -c "PGPASSWORD=cicd pg_dump -U cicd -h 172.19.0.3 --no-privileges --no-owner cicd" > /tmp/dump.sql

# IP адрес контейнера
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' cicd_postgres
```