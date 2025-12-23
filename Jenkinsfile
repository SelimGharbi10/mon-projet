pipeline {
    agent any

    tools {
        jdk 'JAVA_HOME'       // Assure-toi que ce nom correspond à celui configuré dans Jenkins
        maven 'M2_HOME'       // Assure-toi que ce nom correspond à celui configuré dans Jenkins
    }

    environment {
        SONAR_TOKEN      = credentials('sonar-credentials')    // ID du credential Jenkins pour SonarQube
        DOCKERHUB_TOKEN  = credentials('jenkins-docker')       // ID du credential Jenkins pour Docker Hub
        DOCKER_IMAGE     = 'selim2002/tpfoyer:latest'
        KUBECONFIG_PATH  = '/var/lib/jenkins/.kube/config'     // chemin du kubeconfig Jenkins
    }

    stages {

        // -----------------------------
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/master']], // Vérifie si la branche est 'main' ou 'master'
                    userRemoteConfigs: [[
                        url: 'https://github.com/SelimGharbi10/mon-projet.git',
                        credentialsId: 'git-credentials' // ID du credential Jenkins pour GitHub
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
                withSonarQubeEnv('sonarqube') { // Nom du serveur SonarQube configuré dans Jenkins
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
                    echo ${DOCKERHUB_TOKEN} | docker login -u selim2002 --password-stdin
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
            archiveArtifacts artifacts: 'target/*.jar', allowEmptyArchive: true
            echo "✅ CI/CD terminé avec succès"
        }
        failure {
            echo "❌ Erreur dans le pipeline"
        }
    }
}
