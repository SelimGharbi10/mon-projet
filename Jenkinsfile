pipeline {
    agent any

    tools {
        jdk 'JAVA_HOME'
        maven 'M2_HOME'
    }

    environment {
        DOCKER_IMAGE = 'selim2002/springboot-app:latest'
        KUBECONFIG   = '/var/lib/jenkins/.kube/config'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/SelimGharbi10/mon-projet.git',
                    credentialsId: 'git-credentials'
            }
        }

        stage('Clean & Compile') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'mvn test || true'
            }
        }

        stage('SonarQube Analysis') {
            environment {
                SONAR_TOKEN = credentials('sonar-credentials')
            }
            steps {
                withSonarQubeEnv('sonar-credentials') {
                    sh """
                    mvn sonar:sonar \
                      -Dsonar.projectKey=tpfoyer \
                      -Dsonar.host.url=http://192.168.33.10:9000 \
                      -Dsonar.login=${SONAR_TOKEN} || true
                    """
                }
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package -DskipTests'
            }
        }

        stage('Build & Push Docker Image') {
            environment {
                DOCKERHUB_TOKEN = credentials('jenkins-docker')
            }
            steps {
                sh """
                docker build -t ${DOCKER_IMAGE} .
                echo "${DOCKERHUB_TOKEN}" | docker login -u selim2002 --password-stdin
                docker push ${DOCKER_IMAGE}
                """
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                export KUBECONFIG=${KUBECONFIG}
                kubectl apply -f backend.yaml
                kubectl get pods
                kubectl get svc
                """
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            echo "✅ CI/CD terminé avec succès"
        }
        failure {
            echo "❌ Pipeline terminé avec erreurs"
        }
    }
}
