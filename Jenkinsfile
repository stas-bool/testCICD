pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                //script {
                    //env.REPOSITORY_NAME = env.GIT_URL.replaceFirst(/^.*\/([^\/]+?).git$/, '$1')
//                 }
                sh 'cp .example.env .env'
                sh 'cat .env'
                sh 'docker-compose up -d --build'
                sh 'docker exec -it cicd_app sh -c "cd /var/www/cicd && php vendor/bin/codecept run"'
            }
        }
    }
}