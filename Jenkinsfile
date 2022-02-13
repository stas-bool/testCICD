pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
                    env.REPOSITORY_NAME = env.GIT_URL.replaceFirst(/^.*\/([^\/]+?).git$/, '$1')
                    env.REPOSITORY_NAME_LOWER_CASE = env.REPOSITORY_NAME.toLowerCase()
                    env.FEATURE_NAME = env.BRANCH_NAME.toLowerCase().replaceFirst(/feature-/, '')
                    env.VIRTUAL_HOST_PART = "${env.FEATURE_NAME}.${env.REPOSITORY_NAME_LOWER_CASE}"
                    env.APP_CONTAINER_NAME = "${REPOSITORY_NAME}_${BRANCH_NAME}_app"
                }
                sh 'envsubst < .build.env > .env'
                sh 'docker-compose build'
                sh 'docker-compose up -d'
                sh 'env'
                sh "docker exec -i -u www-data $APP_CONTAINER_NAME composer install"
                sh "docker exec -i -u www-data $APP_CONTAINER_NAME php yii migrate --interactive=0"
            }
        }
        stage('Test') {
            sh "docker exec -i -u www-data $APP_CONTAINER_NAME php vendor/bin/codecept run --xml"
        }
    }
    post {
        always {
            junit 'tests/_output/*.xml'
        }
    }
}