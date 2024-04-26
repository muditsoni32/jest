pipeline {
    agent any
    
    environment {
        SSH_AGENT_CREDENTIALS = credentials('mudit_test') // Update with your SSH credentials ID
        REMOTE_USER = 'ec2-user' // Update with your remote username
        REMOTE_HOST = '18.206.147.42' // Update with your remote host IP
        REMOTE_DIR = '/home' // Update with the directory where you want to deploy
    }
    
    stages {
        stage('Build') {
            steps {
                script {
                    // Start SSH Agent and add SSH credentials
                    sshagent(credentials: [$SSH_AGENT_CREDENTIALS]) {
                        // Build the Docker image on the remote server
                        sh "ssh ${REMOTE_USER}@${REMOTE_HOST} 'cd ${REMOTE_DIR} && docker build -t my-node-app .'"
                    }
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    // Run tests inside the Docker container on the remote server
                    sshagent(credentials: [$SSH_AGENT_CREDENTIALS]) {
                        sh "ssh ${REMOTE_USER}@${REMOTE_HOST} 'cd ${REMOTE_DIR} && docker run --rm my-node-app npm test --coverage --reporters=jest-junit'"
                    }
                }
            }
            
            post {
                always {
                    // Archive test results
                    sshagent(credentials: [$SSH_AGENT_CREDENTIALS]) {
                        sh "scp ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/test-results.xml ."
                        junit 'test-results.xml'
                    }
                }
            }
        }
    }
}
