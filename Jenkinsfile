pipeline {
    agent any

    tools{
        jdk 'java11'
        maven 'maven'
    }

    stages {
        stage('Git checkout'){
            steps{
            git branch: 'final_project', url: 'https://github.com/GunaranjanV/Practice_day22.git'
            }
        }
        stage('Maven compile'){
            steps{
                sh 'mvn compile'
            }
        }
        stage('Maven Build'){
            steps{
                sh 'mvn clean install'
            }
        }
        stage('Docker image creation'){
            steps{
                sh 'docker build -t gunaranjanv/appu:1 .'
            }
        }

        stage('Docker Image scan'){
            steps{
                sh 'trivy image --format table -o trivy-image-report.html gunaranjanv/appu:1'
            }
        }
        stage('Docker Containerization'){
            steps{
                sh '''
                    docker stop gunaranjanv/website:1 || true
                    docker rm gunaranjanv/website:1 || true
                    docker run -it -d --name new_website -p 9001:8080 gunaranjanv/appu:1
                    '''
            }
        }
        stage('Docker login'){
            steps{
                script{
                    withCredentials([usernamePassword(credentialsId: 'docker-credentials',
                                                        usernameVariable: 'DOCKER_USERNAME',
                                                        passwordVariable: 'DOCKER_PASSWORD')]){
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                                                        }
                }
                
            }
        }
        stage('Docker push'){
            steps{
                sh 'docker push gunaranjanv/appu:1'
            }
        }

    }

}
