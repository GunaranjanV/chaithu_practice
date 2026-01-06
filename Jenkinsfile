pipeline {
    agent {
        label 'prod'
    }
        stages{
            stage("git checkout"){
                steps{
                    git branch: 'main', url: 'https://github.com/GunaranjanV/chaithu_practice.git'
                }
            }
            stage("Hostname"){
                steps{
                    sh "hostname -I"
                }
            }
        }
}