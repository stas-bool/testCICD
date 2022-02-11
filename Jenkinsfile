pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'envsubst < .build.env > .env'
                sh 'cat .env'
            }
        }
    }
}