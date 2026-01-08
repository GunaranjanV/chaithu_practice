pipeline {
    agent any

    parameters {
        choice(
            name: 'terraformAction',
            choices: ['apply','destroy'],
            description: 'Choose your terraform action to perform'
        )
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage("Git checkout") {
            steps {
                dir("terraform") {
                    git branch: 'terraform', url: 'https://github.com/GunaranjanV/chaithu_practice.git'
                }
            }
        }

        stage('plan') {
            steps {
                sh '''
                    cd all_in_one/
                    terraform init
                    terraform plan -out=tfplan
                    terraform show -no-color tfplan > tfplan.txt
                '''
            }
        }

        stage('approval') {
            steps {
                script {
                    def plan = readFile 'all_in_one/tfplan.txt'
                    input message: "Do you want to proceed with terraform action?",
                          parameters: [text(name: 'plan',
                                            description: 'Review your plan one more time',
                                            defaultValue: plan)]
                }
            }
        }

        stage('Apply or Destroy') {
            when {
                expression {
                    return params.terraformAction == 'apply' || params.terraformAction == 'destroy'
                }
            }
            steps {
                script {
                    if (params.terraformAction == 'apply') {
                        sh '''
                            cd all_in_one/
                            terraform apply -input=false tfplan
                        '''
                    } else if (params.terraformAction == 'destroy') {
                        sh '''
                            cd all_in_one/
                            terraform destroy -auto-approve
                        '''
                    }
                }
            }
        }
    }
}
