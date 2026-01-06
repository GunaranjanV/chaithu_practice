pipeline {
    agent any

    tools {
        jdk 'java-11'
        maven 'maven'
    }

    stages {
        stage('Git checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/GunaranjanV/chaithu_practice.git'
            }
        }

        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }

        stage('Build') {
            steps {
                sh "mvn clean install"
            }
        }

        stage('Build and tag') {
            steps {
                sh "docker build -t gunaranjanv/webapp:1 ."
            }
        }

        stage('Docker image scan') {
            steps {
                sh "trivy image --format table -o trivy-image-report.html gunaranjanv/webapp:1"
            }
        }

        stage('Containersation') {
            steps {
                sh '''
                    docker stop chaithu3 || true
                    docker rm chaithu3 || true
                    docker run -it -d --name chaithu3 -p 9004:8080 gunaranjanv/webapp:1
                '''
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                    }
                }
            }
        }

        stage('Pushing image to repository') {
            steps {
                sh 'docker push gunaranjanv/webapp:1'
            }
        }
    }
}