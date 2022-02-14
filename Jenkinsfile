pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
                    env.REPOSITORY_NAME = env.GIT_URL.replaceFirst(/^.*\/([^\/]+?).git$/, '$1')
                    env.REPOSITORY_NAME_LOWER_CASE = env.REPOSITORY_NAME.toLowerCase()
                    env.FEATURE_NAME = env.BRANCH_NAME.toLowerCase().replaceFirst(/feature\//, '')
                    env.VIRTUAL_HOST_PART = "${env.FEATURE_NAME}.${env.REPOSITORY_NAME_LOWER_CASE}"
                    env.APP_PREFIX = "${REPOSITORY_NAME}_${BRANCH_NAME}"
                    env.APP_CONTAINER_NAME = "${APP_PREFIX}_app"
                }
                sh 'envsubst < .build.env > .env'
                sh 'env'
                sh 'docker-compose build'
                sh 'docker-compose up -d'
                sh "docker exec -i -u www-data $APP_CONTAINER_NAME composer install"
                sh "docker exec -i -u www-data $APP_CONTAINER_NAME php yii migrate --interactive=0"
            }
        }

        stage('Test') {
            steps {
                script {
                    try {
                        sh "docker exec -i -u www-data ${APP_CONTAINER_NAME} php vendor/bin/codecept run --xml"
                    }
                    catch (exc) {
                        sh 'docker-compose stop'
//                         sh "docker container rm \$(docker container ps -a | grep ${APP_PREFIX} | cut -f 1 -d ' ')"
                        env.GIT_COMMIT_MSG = sh (script: 'git log -1 --pretty=%B ${GIT_COMMIT}', returnStdout: true).trim()
                        // Отправка уведомления в telegram
                        sh "tg-me \"" +
                        "*Tests failed*\n" +
                        "*Build*: [Url](${BUILD_URL})\n" +
                        "*Project*: [${REPOSITORY_NAME}](${GIT_URL})\n" +
                        "*Branch*: ${BRANCH_NAME}\n" +
                        "*Changes*: [Url](${RUN_CHANGES_DISPLAY_URL})\""
                    }
                }
            }
        }
    }
    post {
        always {
            junit 'tests/_output/*.xml'
        }
    }
}