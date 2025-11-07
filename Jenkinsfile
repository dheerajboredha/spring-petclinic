pipeline {
    agent {
        label 'Java'
    }
    triggers {
        pollSCM('* * * * *')
    }
    stages {
        stage('git repo') {
            steps {
                git url: 'https://github.com/spring-projects/spring-petclinic.git', branch: 'main'
                    
            }
        }
        stage('java build and scan') {
            steps {
                withCredentials([string(credentialsId: 'sonar_id', variable: 'SONAR_TOKEN')]) {
                    withSonarQubeEnv('sonar') {
                        sh """
                             mvn package sonar:sonar \
                            -Dsonar.organization=dheerajboredha \
                            -Dsonar.projectKey=dheerajboredha_spring-petclinic \
                            -Dsonar.host.url=https://sonarcloud.io \
                            -Dsonar.login=$SONAR_TOKEN
                        """
                    }
                }
            }
        }
        stage('Upload to JFrog Artifactory') {
            steps {
                rtUpload (
                    serverId: 'JFROG_SPC_JAVA',  // Ensure the Jfrog credentials are correct
                    spec: ''' {
                        "files": [
                          {
                            "pattern": "target/*.jar",
                            "target": "javaspc-libs-release-local/"
                          }
                        ]
                    }
                    '''
                )
                rtPublishBuildInfo (serverId: 'JFROG_SPC_JAVA') //publish build info to Jfrog artifactory
            }

        }
        stage('Docker image build') {
            steps {
                sh 'docker image build -t java:1.0 .'  // bat is used in shell
                sh 'docker image ls'
            }
        }
    }
    post {
        always {
            // Archieve the Jar files and test reports regardless of the pipeline result
            archiveArtifacts artifacts: '**/target/*.jar'
            junit '**/target/surefire-reports/*.xml'
        }
        success {
            echo 'this pipeline good'
        }
        failure {
            echo 'this is waste pipeline'
        }
    }
}
