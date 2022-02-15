# testCICD

1. Установить docker:
   - [Windows](https://docs.docker.com/desktop/windows/install/)
   - Debian/Ubuntu: `sudo apt-get install docker docker-compose`
   - [Mac](https://docs.docker.com/desktop/mac/install/)
2. Зайти в папку с проектом
3. Скопировать .env.example в .env
4. Запустить `docker-compose up -d`
5. Установка зависимостей `docker exec -it cicd_app sh -c "composer install"`
6. Применение миграций `docker exec -it cicd_app sh -c "php yii migrate --interactive=0"`

Сайт будет доступен по адресу http://127.0.0.1:888/. 
Порт меняется в [.env](.env) `NGINX_PORT`

### Прочие инструкции
- [Тестирование](docs/tests.md)
- [Настройка xdebug](docs/debug.md)
- [Прочее](docs/useful_commands.md)

Если есть предложения, исправления, оформляем pull request.
