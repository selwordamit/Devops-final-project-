//     ---PowerShell Pipeline Do not Delete--- 

/*pipeline {
    agent any

    triggers {
        // Check for Git changes every 5 minutes (Poll SCM)
        pollSCM('H/5 * * * *')
    }

    environment {
        // Defining paths as variables for easier maintenance
        TOMCAT_WEBAPP = "C:/Program Files/Apache Software Foundation/Tomcat 8.5/webapps/Devops-final-project-/adamliadadiramityuri"
        APP_URL = "http://localhost:8081/Devops-final-project-/adamliadadiramityuri/"
    }

    stages {
        stage('Checkout') {
            steps {
                // Jenkins handles the checkout automatically, but this stage verifies it
                echo 'Checking out source code from GitHub...'
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                // Execute Windows batch command to copy the file
                bat """
                @echo off
                echo "Copying index.jsp to Tomcat webapps directory..."
                copy /Y "adamliadadiramityuri\\index.jsp" "${TOMCAT_WEBAPP}\\index.jsp"
                """
            }
        }

        stage('Health Check') {
            steps {
                echo "Verifying deployment status at ${APP_URL}"
                // Running the PowerShell command to check the HTTP Status Code
                powershell """
                \$r = Invoke-WebRequest -UseBasicParsing -TimeoutSec 15 -Uri '${APP_URL}'
                if (\$r.StatusCode -ge 200 -and \$r.StatusCode -lt 400) {
                    Write-Host 'Health Check Passed: Server is UP'
                } else {
                    Write-Host ('Health Check Failed: Status Code ' + \$r.StatusCode)
                    exit 1
                }
                """
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution finished.'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the logs above for errors.'
            
        }
    }
}
*/




// ----Linux Pipeline----

pipeline {
    agent any

    triggers {
        pollSCM('H/5 * * * *')
    }

    environment {
        // Linux path for Tomcat 9 webapps
        TOMCAT_WEBAPP = "/var/lib/tomcat9/webapps/Devops-final-project-/adamliadadiramityuri"
        // The URL to check
        APP_URL = "http://localhost:8081/Devops-final-project-/adamliadadiramityuri/"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code from GitHub...'
            }
        }

        stage('Prepare Directory') {
            steps {
                // Ensure the target directory exists on Linux
                sh "sudo mkdir -p ${TOMCAT_WEBAPP}"
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                echo "Copying index.jsp to Tomcat..."
                // Using Linux 'cp' command
                sh "sudo cp adamliadadiramityuri/index.jsp ${TOMCAT_WEBAPP}/index.jsp"
            }
        }

        stage('Health Check') {
            steps {
                echo "Verifying deployment status at ${APP_URL}"
                // Using 'curl' to check the HTTP status code on Linux
                sh """
                STATUS=\$(curl -s -o /dev/null -w "%{http_code}" ${APP_URL})
                if [ \$STATUS -ge 200 ] && [ \$STATUS -lt 400 ]; then
                    echo "Health Check Passed: Status \$STATUS"
                else
                    echo "Health Check Failed: Status \$STATUS"
                    exit 1
                fi
                """
            }
        }
    }

    post {
        failure {
            echo 'Pipeline failed. Check the logs for errors.'
        }
    }
}