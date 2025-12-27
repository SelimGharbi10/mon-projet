pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('jenkins-docker') // identifiants DockerHub
        IMAGE_NAME = 'selim2002/tpfoyer:latest'
        KUBECONFIG_FILE = credentials('kubeconfig-jenkins') // fichier kubeconfig pour Kubernetes
    }

    tools {
        jdk 'JAVA_HOME'
        maven 'M2_HOME'
    }

    stages {

        stage('Checkout') {
            steps {
                git url: 'https://github.com/SelimGharbi10/mon-projet', branch: 'master'
                sh 'ls -la' // vérifier la présence du Dockerfile
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
                withCredentials([string(credentialsId: 'jenkins-docker', variable: 'DOCKER_PASS')]) {
                    sh """
                    echo $DOCKER_PASS | docker login -u selim2002 --password-stdin
                    docker push ${IMAGE_NAME}
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-jenkins', variable: 'KUBECONFIG')]) {
                    sh '''
                    export KUBECONFIG=$KUBECONFIG
                    kubectl apply -f backend.yaml
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline terminé'
        }

        success {
            emailext (
                subject: "✅ SUCCESS : Pipeline ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "Pipeline exécuté avec succès !\nURL: ${env.BUILD_URL}",
                to: "gharbi.selim01@gmail.com"
            )
        }

        failure {
            emailext (
                subject: "❌ FAILURE : Pipeline ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "Pipeline échoué ❌\nLogs: ${env.BUILD_URL}",
                to: "gharbi.selim01@gmail.com"
            )
        }
    }
}
