pipeline {
    agent any

    environment {
        AWS_REGION   = 'ap-southeast-2'
        ECR_REPO     = '904934038179.dkr.ecr.ap-southeast-2.amazonaws.com/flask-ci-cd'
        IMAGE_TAG    = "${env.BUILD_NUMBER}"
        CLUSTER_NAME = 'flask-ci-cd-cluster'
        KUBECONFIG   = '/var/jenkins_home/.kube/eks-config'
    }

    stages {

        stage('Build & Push Image (amd64)') {
            steps {
                withAWS(credentials: 'aws-jenkins-creds', region: "${AWS_REGION}") {
                    sh '''
                      # Create or reuse buildx builder
                      docker buildx inspect multiarch-builder >/dev/null 2>&1 || \
                      docker buildx create --name multiarch-builder --use

                      docker buildx use multiarch-builder
                      docker buildx inspect --bootstrap

                      # Build and push Flask app image
                      docker buildx build \
                        --platform linux/amd64 \
                        --provenance=false \
                        -t ${ECR_REPO}:${IMAGE_TAG} \
                        --push .
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withAWS(credentials: 'aws-jenkins-creds', region: "${AWS_REGION}") {
                    sh '''
                      aws eks update-kubeconfig \
                        --region ${AWS_REGION} \
                        --name ${CLUSTER_NAME} \
                        --kubeconfig ${KUBECONFIG}

                      kubectl set image deployment/flask-app \
                        flask=${ECR_REPO}:${IMAGE_TAG} \
                        -n flask

                      kubectl rollout status deployment/flask-app -n flask
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ CI/CD completed: amd64 image built and deployed to EKS!"
        }
        failure {
            echo "❌ Pipeline failed."
        }
        always {
            sh 'docker system prune -f || true'
        }
    }
}
