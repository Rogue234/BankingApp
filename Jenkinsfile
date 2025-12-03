pipeline {
    agent any

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "maven_3.6.3"
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerloginid') // Replace with your Jenkins credentials ID
    }

    stages {
        stage('SCM Checkout') {
            steps {
                // Clone the repository
                git 'https://github.com/Rogue234/BankingApp.git'
            }
        }
        stage('Build') {
            steps {
                // Build the application using Maven
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Docker Build') {
            steps {
                // Build the Docker image
                sh 'docker build -t rogue234/banking-app:${BUILD_NUMBER} .'
            }
        }
        stage('Docker Login') {
            steps {
                // Log in to DockerHub
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('Docker Push') {
            steps {
                // Push the Docker image to DockerHub
                sh 'docker push rogue234/banking-app:${BUILD_NUMBER}'
                sh 'docker tag rogue234/banking-app:${BUILD_NUMBER} rogue234/banking-app:latest'
                sh 'docker push rogue234/banking-app:latest'
            }
        }
        stage('Deploy') {
            steps {
                // Run the deployment script
                sh './deploy.sh -i rogue234/banking-app -t ${BUILD_NUMBER} -p 8080:8080 -v /data:/app/data'
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
