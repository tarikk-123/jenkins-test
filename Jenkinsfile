pipeline {
    agent {
        label 'slavenode-1'  // Agent node etiket adı
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        IMAGE_NAME = 'tarik1661/jenkins-test2'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm

                // Dizini ve içeriklerini göster
                sh '''
                    echo "Bulunduğum dizin:"
                    pwd
                    echo "Dizin içeriği:"
                    ls -la
                '''
            }
        }

        stage('Get App.java commit count and environment info') {
            steps {
                script {
                    // Hostname, dizin bilgisi ve ls çıktısı
                    sh """
                        echo "Hostname: \$(hostname)"
                        echo "Current directory: \$(pwd)"
                        echo "Directory contents:"
                        ls -la
                    """

                    // App.java dosyasına yapılmış commit sayısını al
                    def AppjavaCommitCount = sh(
                        script: "git rev-list --count HEAD -- App.java",
                        returnStdout: true
                    ).trim()
                    env.VERSION = "1.0.${AppjavaCommitCount}"
                    echo "Docker image version: ${env.VERSION}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:${VERSION} ."
                }
            }
        }

        stage('Login to DockerHub') {
            steps {
                script {
                    sh """
                        echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh "docker push ${IMAGE_NAME}:${VERSION}"
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline başarıyla tamamlandı! Docker image Docker Hub\'a push edildi.'
        }
        failure {
            echo 'Pipeline başarısız oldu! Hata oluştu.'
        }
        always {
            script {
                sh "docker logout"
            }
        }
    }
}
