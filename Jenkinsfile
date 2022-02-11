pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'cp .example.env .env'
                sh 'cat .env'
                sh 'docker-compose up -d --build'
                sh 'docker exec -it cicd_app sh -c "cd /var/www/cicd && php vendor/bin/codecept run"'
            }
        }
    }
}