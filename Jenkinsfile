pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('jenkins-docker') // Jenkins credentials
        IMAGE_NAME = 'selim2002/tpfoyer:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/SelimGharbi10/mon-projet'
            }
        }

        stage('Build & Package') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                sh """
                echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                docker push ${IMAGE_NAME}
                """
            }
        }
    }

    post {
        always {
            echo 'Pipeline terminé'
        }
    }
}
