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
                withCredentials([string(credentialsId: 'jenkins-docker', variable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u selim2002 --password-stdin'
                    sh 'docker push selim2002/tpfoyer:latest'
                }
            }
        }

       stage('Deploy to Kubernetes') {
    steps {
        withCredentials([file(credentialsId: 'kubeconfig-jenkins', variable: 'KUBECONFIG_FILE')]) {
            sh 'export KUBECONFIG=$KUBECONFIG_FILE'
            sh 'kubectl apply -f backend.yaml'
        }
    }
}


    }

    post {
        always {
            echo 'Pipeline terminé'
        }
    }
}
