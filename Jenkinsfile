pipeline {
    agent any

    environment {
        AWS_REGION   = 'ap-southeast-2'
        ECR_REPO     = '904934038179.dkr.ecr.ap-southeast-2.amazonaws.com/flask-ci-cd'
        IMAGE_TAG    = "${BUILD_NUMBER}"
        CLUSTER_NAME = 'flask-ci-cd-cluster'
        KUBECONFIG   = '/var/jenkins_home/.kube/config'
    }

    stages {

        stage('Build & Push Image') {
            steps {
                sh '''
                  aws ecr get-login-password --region ${AWS_REGION} \
                    | docker login --username AWS --password-stdin ${ECR_REPO}

                  docker buildx build \
                    --platform linux/amd64 \
                    -t ${ECR_REPO}:${IMAGE_TAG} \
                    --push .
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                  aws eks update-kubeconfig \
                    --region ${AWS_REGION} \
                    --name ${CLUSTER_NAME}

                  kubectl set image deployment/flask-app \
                    flask=${ECR_REPO}:${IMAGE_TAG} \
                    -n flask

                  kubectl rollout status deployment/flask-app -n flask
                '''
            }
        }
    }

    post {
        success {
            echo "✅ CI/CD completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed."
        }
    }
}
