pipeline {
    agent {
        label 'general'
    }

    triggers {
        githubPush()
    }

    options {
        timeout(time: 10, unit: 'MINUTES')
        timestamps()
    }

    environment {
        IMAGE_TAG = "v1.0.$BUILD_NUMBER"
        IMAGE_BASE_NAME = "netflix-movie-catalog-dev"

        DOCKER_CREDS = credentials('dockerhub')
        DOCKER_USERNAME = "${DOCKER_CREDS_USR}"
        DOCKER_PASS = "${DOCKER_CREDS_PSW}"
    }

    stages {
        stage('Docker setup') {
            steps {
                sh '''
                  docker login -u $DOCKER_USERNAME -p $DOCKER_PASS
                '''
            }
        }

        stage('Build app container') {
            steps {
                sh '''
                    IMAGE_FULL_NAME=$DOCKER_USERNAME/$IMAGE_BASE_NAME:$IMAGE_TAG
                    docker build -t $IMAGE_FULL_NAME .
                    docker push $IMAGE_FULL_NAME
                '''
            }
        }
        stage('Trigger Deploy') {
            steps {
                build job: 'NetflixDeployDev', wait: false, parameters: [
                    string(name: 'SERVICE_NAME', value: "NetflixMovieCatalog"),
                    string(name: 'IMAGE_FULL_NAME_PARAM', value: "$DOCKER_USERNAME/$IMAGE_BASE_NAME:$IMAGE_TAG")
                ]
            }
        }
    }
}