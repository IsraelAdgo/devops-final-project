pipeline {
    agent any
    environment {
        PATH = "$PATH:/usr/local/bin"
    }
    stages {
        stage('build webapp container') {
            steps {
                sh """
                docker build -t=webapp .
                """
            }
        }
        stage('run webapp container') {
            steps {
                sh """
                docker run -d -p=8082:8080 -v /.:/usr/local/tomcat/webapps/status webapp --force-recreate
                """
            }
        }
    }
}