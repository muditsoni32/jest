pipeline {
    agent any
    
    environment {
        // Define SSH credentials for connecting to the remote server
        SSH_CREDENTIALS = credentials('mudit_test')
        REMOTE_USER = 'ec2-user'
        REMOTE_HOST = '18.206.147.42'
        REMOTE_PATH = '/app'
    }
    
    stages {
        stage('Build') {
            steps {
                // Checkout the code from Git
                checkout scm
                
                // Build Docker image
                script {
                    docker.build("jest-junit-reporter")
                }
            }
        }
        
        stage('Test') {
            steps {
                // Run tests inside Docker container
                script {
                    docker.image("jest-junit-reporter").inside {
                        sh 'npm test'
                    }
                }
                
                // Publish test results using JUnit plugin
                junit testDataPublishers: [attachments()], testResults: '/app'
            }
        }
        
        stage('Deploy') {
            steps {
                // Copy Docker image to remote server
                script {
                    sh "docker save jest-junit-reporter | sshpass -p ${SSH_CREDENTIALS} ssh ${REMOTE_USER}@${REMOTE_HOST} 'docker load'"
                }
                
                // SSH into remote server and start Docker container
                script {
                    sshagent(credentials: [SSH_CREDENTIALS]) {
                        sh "ssh ${REMOTE_USER}@${REMOTE_HOST} 'docker run -d -p 3000:3000 --name jest-junit-reporter jest-junit-reporter'"
                    }
                }
            }
        }
    }
}
