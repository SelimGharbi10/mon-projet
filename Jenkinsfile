pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'selim2002/tpfoyer:latest'
        KUBECONFIG_PATH = '/var/lib/jenkins/.kube/config'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/SelimGharbi10/mon-projet.git'
            }
        }

        stage('Clean & Compile') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Configurer Docker pour Minikube
                sh 'eval $(minikube docker-env)'

                // Build l'image Docker
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withEnv(["KUBECONFIG=${KUBECONFIG_PATH}"]) {
                    sh 'kubectl delete pod -l app=backend || true'
                    sh 'kubectl apply -f backend.yaml'
                    sh 'kubectl get pods'
                }
            }
        }
    }

    post {
        success {
            echo "✅ CI/CD terminé avec succès"
        }
        failure {
            echo "❌ Pipeline terminé avec erreurs"
        }
    }
}
