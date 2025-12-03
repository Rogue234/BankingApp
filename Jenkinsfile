pipeline {
    agent any

    tools {
        maven "maven_3.6.3" // Ensure Maven is installed in Jenkins
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerloginid') // Replace with your Jenkins credentials ID
    }

    stages {
        stage('SCM Checkout') {
            steps {
                git 'https://github.com/Rogue234/BankingApp.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t rogue234/banking-app:${BUILD_NUMBER} .'
            }
        }
        stage('Docker Login') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('Docker Push') {
            steps {
                sh 'docker push rogue234/banking-app:${BUILD_NUMBER}'
                sh 'docker tag rogue234/banking-app:${BUILD_NUMBER} rogue234/banking-app:latest'
                sh 'docker push rogue234/banking-app:latest'
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed!'
        }
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
