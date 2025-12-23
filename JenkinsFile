pipeline {
    agent any

    tools {
        jdk 'JAVA_HOME'       // adapte selon ta version dans Jenkins
        maven 'M2_HOME'       // nom que tu as donné à Maven dans Jenkins
    }

    environment {
        SONAR_TOKEN = credentials('sonar-token')        // token SonarQube
        DOCKERHUB_TOKEN = credentials('DOCKERHUB_TOKEN') // token Docker Hub
        DOCKER_IMAGE = 'selim2002/springboot-app:latest'
        KUBECONFIG_PATH = '/var/lib/jenkins/.kube/config' // kubeconfig Jenkins
    }

    stages {

        // -----------------------------
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/TON_REPO/tpfoyer.git',
                        credentialsId: 'git-credentials'
                    ]]
                ])
            }
        }

        // -----------------------------
        stage('Clean') {
            steps {
                sh "mvn clean"
            }
        }

        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }

        stage('Unit Tests') {
            steps {
                sh "mvn test"
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh """
                    mvn sonar:sonar \
                      -Dsonar.projectKey=tpfoyer \
                      -Dsonar.host.url=http://192.168.33.10:9000 \
                      -Dsonar.login=${SONAR_TOKEN}
                    """
                }
            }
        }

        stage('Package') {
            steps {
                sh "mvn package -DskipTests"
            }
        }

        // -----------------------------
        stage('Build & Push Docker Image') {
            steps {
                script {
                    sh """
                    docker build -t ${DOCKER_IMAGE} .
                    echo $DOCKERHUB_TOKEN | docker login -u selim2002 --password-stdin
                    docker push ${DOCKER_IMAGE}
                    """
                }
            }
        }

        // -----------------------------
        stage('Deploy to Kubernetes') {
            steps {
                withEnv(["KUBECONFIG=${KUBECONFIG_PATH}"]) {
                    sh 'kubectl apply -f backend.yaml'
                    sh 'kubectl get pods'
                    sh 'kubectl get svc'
                }
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: 'target/*.jar'
            echo "✅ CI/CD terminé avec succès"
        }
        failure {
            echo "❌ Erreur dans le pipeline"
        }
    }
}
