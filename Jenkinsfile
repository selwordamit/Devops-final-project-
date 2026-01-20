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
        // Check for GitHub changes every 5 minutes
        pollSCM('H/5 * * * *')
    }

    environment {
        // Path to the project folder inside Tomcat webapps on Azure Linux VM
        TOMCAT_WEBAPP = "/var/lib/tomcat9/webapps/Devops-final-project-/adamliadadiramityuri"
        // Internal application URL for health monitoring
        APP_URL = "http://localhost:8081/Devops-final-project-/adamliadadiramityuri/"
    }

    stages {
        stage('Initialize') {
            steps {
                echo "✅ STARTING DEPLOYMENT PROCESS"
                echo "Time: ${sh(script: 'date', returnStdout: true).trim()}"
            }
        }

        stage('Checkout') {
            steps {
                echo "✅ Fetching latest code from GitHub"
                // SCM checkout is handled automatically by Jenkins
            }
        }

        stage('Prepare Directory') {
            steps {
                echo "✅ Verifying target directory structure"
                sh "mkdir -p ${TOMCAT_WEBAPP}"
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                echo "✅ Deploying index.jsp to Tomcat web server"
                // Copy the file to the specific folder including the team names
                sh "cp adamliadadiramityuri/index.jsp ${TOMCAT_WEBAPP}/index.jsp"
            }
        }

        stage('Health Check') {
            steps {
                echo "✅ Initiating Internal Health Check for: ${APP_URL}"
                sh """
                    STATUS=\$(curl -s -o /dev/null -w "%{http_code}" ${APP_URL})
                    if [ \$STATUS -ge 200 ] && [ \$STATUS -lt 400 ]; then
                        echo "✅ Internal Status: SUCCESS"
                    else
                        echo "❌ Internal Status: FAILED (Status: \$STATUS)"
                        exit 1
                    fi
                """
            }
        }

        stage('External Monitoring Status') {
            steps {
                echo "✅ Checking UptimeRobot status"
                // Using the Secret Text credential created in Jenkins
                withCredentials([string(credentialsId: 'uptimerobot-api-key', variable: 'UPTIME_KEY')]) {
                    script {
                        def response = sh(
                            script: "curl -X POST https://api.uptimerobot.com/v2/getMonitors -d 'api_key=${UPTIME_KEY}&format=json' -s",
                            returnStdout: true
                        )
                        
                        if (response.contains('"status":2')) {
                            echo "✅ UptimeRobot status: Application is UP"
                        } else {
                            echo "❌ UptimeRobot status: Application is DOWN or Unreachable"
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline finished successfully"
        }
        failure {
            echo "❌ Pipeline failed - check the logs for syntax or permission errors"
        }
    }
}