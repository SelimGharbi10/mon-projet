pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('jenkins-docker')
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
        withCredentials([usernamePassword(credentialsId: 'jenkins-docker',
                                         usernameVariable: 'DOCKER_USER',
                                         passwordVariable: 'DOCKER_PASS')]) {
            // Connexion à Docker Hub
            sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
            
            // Push de l'image
            sh 'docker push selim2002/tpfoyer:latest'
        }
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
