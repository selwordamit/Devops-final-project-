//     ---PowerShell Pipeline Do not Delete--- 

pipeline {
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





// ----Linux Pipeline----
/*
pipeline {
    agent any

    triggers {
        // Checks for changes in GitHub every 5 minutes
        pollSCM('H/5 * * * *')
    }

    environment {
        // Path to your project folder inside Tomcat webapps
        TOMCAT_WEBAPP = "/var/lib/tomcat9/webapps/Devops-final-project-/adamliadadiramityuri"
        // The URL of your application for health monitoring
        APP_URL = "http://localhost:8081/Devops-final-project-/adamliadadiramityuri/"
    }

    stages {
        stage('Initialize') {
            steps {
                echo "-------------------------------------------------------"
                echo "🚀 STARTING DEPLOYMENT PROCESS"
                echo "Target Server: Azure Linux VM"
                echo "Time: ${sh(script: 'date', returnStdout: true).trim()}"
                echo "-------------------------------------------------------"
            }
        }

        stage('Checkout') {
            steps {
                echo "📥 Fetching latest code from GitHub..."
                // Jenkins handles the Git checkout automatically via SCM settings
                echo "Successfully synchronized with repository."
            }
        }

        stage('Prepare Directory') {
            steps {
                echo "📁 Verifying target directory structure..."
                // Create directory if it doesn't exist (no sudo needed if permissions are set)
                sh "mkdir -p ${TOMCAT_WEBAPP}"
                echo "Directory is ready: ${TOMCAT_WEBAPP}"
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                echo "📦 Deploying index.jsp to Tomcat web server..."
                // Copy the file and show confirmation in logs
                sh """
                    cp adamliadadiramityuri/index.jsp ${TOMCAT_WEBAPP}/index.jsp
                    ls -l ${TOMCAT_WEBAPP}/index.jsp
                """
                echo "✅ File successfully copied to webapps."
            }
        }

        stage('Health Check') {
            steps {
                echo "🔍 Initiating Health Check for: ${APP_URL}"
                // Perform a curl request and capture the status code
                sh """
                    STATUS=\$(curl -s -o /dev/null -w "%{http_code}" ${APP_URL})
                    echo "Response Code Received: \$STATUS"
                    
                    if [ \$STATUS -ge 200 ] && [ \$STATUS -lt 400 ]; then
                        echo "-------------------------------------------------------"
                        echo "🟢 MONITORING STATUS: SUCCESS"
                        echo "Application is UP and responding correctly."
                        echo "-------------------------------------------------------"
                    else
                        echo "-------------------------------------------------------"
                        echo "🔴 MONITORING STATUS: FAILED"
                        echo "Application is DOWN or returning an error."
                        echo "-------------------------------------------------------"
                        exit 1
                    fi
                """
            }
        }
    }

    post {
        success {
            echo "✨ Pipeline finished successfully! Great job team."
        }
        failure {
            echo "❌ Pipeline failed! Review the logs above to identify the issue."
        }
        always {
            echo "Cleaning up workspace..."
        }
    }
}
*/