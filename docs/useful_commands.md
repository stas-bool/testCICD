cicd_postgres - имя контейнера

IP адрес контейнера: 

`docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' cicd_postgres`

Дамп базы из докера:

`docker exec -ti cicd_postgres sh -c "PGPASSWORD=cicd pg_dump -U cicd -h 172.19.0.3 --no-privileges --no-owner cicd" > /tmp/dump.sql`

Чтобы дамп базы загрузился при сборке контейнера, нужно его положить в [папку](../docker/postgres/dump/.).
Все файлы с расширением *.sh или *.sql в этой папке будут выполнены во время сборки контейнера postgres.