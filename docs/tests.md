##Тестирование
Запуск тестов:
```bash
docker exec -it cicd_app sh -c "cd /var/www/cicd && php vendor/bin/codecept run"
```