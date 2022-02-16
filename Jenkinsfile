pipeline {
    agent any
    stages {
        // Стадия сборки
        stage('Build') {
            steps {
                script {
                    env.REPOSITORY_NAME = env.GIT_URL.replaceFirst(/^.*\/([^\/]+?).git$/, '$1')
                    env.REPOSITORY_NAME_LOWER_CASE = env.REPOSITORY_NAME.toLowerCase()
                    env.FEATURE_NAME = env.BRANCH_NAME.toLowerCase().replaceFirst('feature/', '')
                    env.VIRTUAL_HOST_PART = "${env.FEATURE_NAME}.${env.REPOSITORY_NAME_LOWER_CASE}"
                    env.APP_PREFIX = "${REPOSITORY_NAME}_${BRANCH_NAME}".replaceAll('/', '_')
                    env.APP_CONTAINER_NAME = "${APP_PREFIX}_app"
                }
                // Замена переменных в файле из окружения
                sh 'envsubst < .build.env > .env'
                sh 'envsubst < docker/nginx/example-vhost.conf > docker/nginx/vhost/vhost.conf'
                // Сборка контейнера
                sh 'docker-compose build --no-cache'
                // Запуск контейнера
                sh 'docker-compose up -d'
                // Установка зависимостей
                sh "docker exec -i -u www-data $APP_CONTAINER_NAME composer install"
                // Применение миграций
                sh "docker exec -i -u www-data $APP_CONTAINER_NAME php yii migrate --interactive=0"
            }
        }
        // Стадия тестирования
        stage('Test') {
            steps {
                script {
                    try {
                        // Запуск тестов в контейнере
                        sh "docker exec -i -u www-data ${APP_CONTAINER_NAME} php vendor/bin/codecept run --xml"
                    }
                    catch (exc) {
                        // Если тесты не прошли
                        // Остановить контейнер
                        sh 'docker-compose stop'
                        // Отправить уведомление в telegram с ссылкой на сборку
                        sh "tg-me \"Tests failed\n[Build](${BUILD_URL})\""
                        // Тут можно отправлять сообщения автору коммита
                    }
                }
            }
        }
        stage('Deploy feature') {
            when { branch pattern: "feature/.*", comparator: "REGEXP"}
            steps {
                // Перезапуск прокси
                sh 'docker stop myproxy'
                sh 'docker run --name=myproxy -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock -t --rm --network=container_network -d jwilder/nginx-proxy'
            }
        }
        stage('Deploy stage') {
            when { branch "stage" }
            steps {
                sh "ssh ubuntu@10.0.0.231 \"cd ~/stage && git pull && \
                    docker-compose restart && \
                    docker exec -i -u www-data cicd_app composer install && \
                    docker exec -i -u www-data cicd_app php yii migrate --interactive=0\""
                sh 'docker-compose stop'
            }
        }
        stage('Deploy production') {
            when { branch "master" }
            steps {
                sh "ssh ubuntu@10.0.0.231 \"cd ~/prod && git pull && \
                    docker-compose restart && \
                    docker exec -i -u www-data cicd_app composer install && \
                    docker exec -i -u www-data cicd_app php yii migrate --interactive=0\""
                sh 'docker-compose stop'
            }
        }
        stage('Other branches') {
            when { branch pattern: '^(?!stage|master|feature\\/[\\w\\-_]*).*', comparator: "REGEXP" }
            steps {
                echo 'Other branches'
                sh 'docker-compose stop'
            }
        }
    }
    post {
        // Выполняется всегда. Даже если сборка на удалась
        // Тут можно отправлять сообщения автору коммита, если сборка не удалась
        always {
            // Результаты тестов
            junit 'tests/_output/*.xml'
        }
    }
}