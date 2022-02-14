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
                // Сборка контейнера
                sh 'docker-compose build'
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
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Pass'
            }
        }
    }
    post {
        // Выполняется всегда. Даже если сборка на удалась
        always {
            // Результаты тестов
            junit 'tests/_output/*.xml'
        }
    }
}