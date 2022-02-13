pipeline {
    agent any
    stages {
        environment {
            REPOSITORY_NAME = GIT_URL.replaceFirst(/^.*\/([^\/]+?).git$/, '$1')
            REPOSITORY_NAME_LOWER_CASE = REPOSITORY_NAME.toLowerCase()
            FEATURE_NAME = BRANCH_NAME.toLowerCase().replaceFirst(/feature-/, '')
            VIRTUAL_HOST_PART = "${FEATURE_NAME}.${REPOSITORY_NAME_LOWER_CASE}"
            APP_PREFIX = "${REPOSITORY_NAME}_${BRANCH_NAME}"
            APP_CONTAINER_NAME = "${APP_PREFIX}_app"
        }
        stage('Build') {
            steps {
                script {
                }
                sh 'envsubst < .build.env > .env'
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
                        sh "docker container rm \$(docker container ps -a | grep ${APP_PREFIX} | cut -f 1 -d ' ')"
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