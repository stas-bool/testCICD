pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
                    env.REPOSITORY_NAME_LOWER_CASE = env.GIT_URL.replaceFirst(/^.*\/([^\/]+?).git$/, '$1').toLowerCase()
                    env.BRANCH_NAME_LOWER_CASE = env.BRANCH_NAME.toLowerCase()
                    env.VIRTUAL_HOST_PART = "${env.REPOSITORY_NAME_LOWER_CASE}.${env.BRANCH_NAME_LOWER_CASE}"
                }
                sh 'envsubst < .build.env > .env'
                sh 'cat .env'
                sh 'env'
                sh 'docker-compose up -d --build'
            }
        }
    }
}