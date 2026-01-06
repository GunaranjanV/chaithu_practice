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
            stage("Build"){
                steps{
                    echo "This is build stage"
                }
            }
            stage("test"){
                steps{
                    echo "This is test stage"
                }
            }
            stage("Prod"){
                steps{
                    echo "This is prod stage"
                }
            }
        }
}