pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
                    env.REPOSITORY_NAME = env.GIT_URL.replaceFirst(/^.*\/([^\/]+?).git$/, '$1')
                    env.REPOSITORY_NAME_LOWER_CASE = env.REPOSITORY_NAME.toLowerCase()
                    env.BRANCH_NAME_LOWER_CASE = env.BRANCH_NAME.toLowerCase()
                    env.VIRTUAL_HOST_PART = "${env.BRANCH_NAME_LOWER_CASE}.${env.REPOSITORY_NAME_LOWER_CASE}"
                    env.APP_CONTAINER_NAME = "${REPOSITORY_NAME}_${BRANCH_NAME}_app"
                }
                sh 'envsubst < .build.env > .env'
                sh 'docker-compose build'
                sh 'docker-compose up -d'
                sh 'env'
                sh "docker exec -ti -u www-data $APP_CONTAINER_NAME composer install"
                sh "docker exec -ti -u www-data $APP_CONTAINER_NAME php yii migrate --interactive=0"
            }
        }
    }
}