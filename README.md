# testCICD

1. Установить docker-compose:
   - [Windows](https://docs.docker.com/desktop/windows/install/).
   - Debian/Ubuntu: `sudo apt-get install docker-compose`
   - [Mac](https://docs.docker.com/desktop/mac/install/)
3. Зайти в папку с проектом
4. Скопировать .env.example в .env
5. Запустить `docker-compose up`

Сайт будет доступен по адресу http://127.0.0.1:888/. 
Порт меняется в [.env](.env) `NGINX_PORT`

###Прочие инструкции
- [Тестирование](docs/tests.md)
- [Настройка xdebug](docs/debug.md)
- [Прочее](docs/useful_commands.md)

Если есть предложения, исправления, оформляем pull request.
