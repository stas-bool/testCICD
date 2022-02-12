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
                }
                sh 'envsubst < .build.env > .env'
                sh 'cat .env'
                sh 'env'
                sh 'docker-compose build --no-cache'
                sh 'docker-compose up -d'
            }
        }
    }
}