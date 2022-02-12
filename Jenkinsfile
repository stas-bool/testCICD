pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
                    env.REPOSITORY_NAME = env.GIT_URL.replaceFirst(/^.*\/([^\/]+?).git$/, '$1')
                }
                sh 'envsubst < .build.env > .env'
                sh 'cat .env'
                sh 'env'
                sh 'docker-compose up -d --build'
            }
        }
    }
}