pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        IMAGE_NAME = 'selim2002/tpfoyer:latest'
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/SelimGharbi10/mon-projet'
                sh 'ls -la' // vérifier que Dockerfile est présent
            }
        }

        stage('Build & Package') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t selim2002/tpfoyer:latest .'
            }
        }

        stage('Push Docker Image') {
            steps {
                sh '''
                echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                docker push selim2002/tpfoyer:latest
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f backend.yaml'
            }
        }
    }

    post {
        always {
            echo 'Pipeline terminé'
        }
    }
}
