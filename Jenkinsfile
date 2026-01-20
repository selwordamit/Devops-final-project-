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

    // Project Requirement: Trigger the job every 5 minutes (Requirement #6)
    triggers {
        pollSCM('H/5 * * * *')
    }

    environment {
        // Defined the specific path under Tomcat webapps including the team names (Requirement #3)
        TOMCAT_WEBAPP = "/var/lib/tomcat9/webapps/Devops-final-project-/adamliadadiramityuri"
    }

    stages {
        stage('Initialize') {
            steps {
                echo "✅ STARTING DEPLOYMENT PROCESS"
                // Log the current server time for traceability
                echo "Current Time: ${sh(script: 'date', returnStdout: true).trim()}"
            }
        }

        stage('Checkout') {
            steps {
                echo "✅ Fetching latest source code from GitHub repository"
                // Jenkins automatically performs 'git checkout' based on the job configuration
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                echo "✅ Deploying index.jsp to production environment (Tomcat)"
                // Overwrites the existing JSP file in the webapps directory (Requirement #4)
                sh "cp adamliadadiramityuri/index.jsp ${TOMCAT_WEBAPP}/index.jsp"
            }
        }

        stage('External Monitoring Status') {
            steps {
                echo "✅ Querying UptimeRobot API for external application status"
                
                // Securely retrieving the API Key from Jenkins Credentials store to avoid hardcoding secrets
                withCredentials([string(credentialsId: 'uptimerobot-api-key', variable: 'UPTIME_KEY')]) {
                    script {
                        // Performing a POST request to UptimeRobot API to get current monitor status
                        // Single quotes are used to prevent Groovy from touching the $ variables
                        def response = sh(
                            script: 'curl -X POST https://api.uptimerobot.com/v2/getMonitors -d "api_key=${UPTIME_KEY}&format=json" -s',
                            returnStdout: true
                        )
                        
                        // In UptimeRobot API, "status": 2 means the site is UP/Online
                        if (response.contains('"status":2')) {
                            echo "✅ UptimeRobot confirms: Application is UP and publicly accessible"
                        } else {
                            // If status is not 2, we force the pipeline to fail (Requirement #6)
                            error("❌ UptimeRobot Alert: Application is reported as DOWN by external monitor!")
                        }
                    }
                }
            }
        }
    }

    // Post-execution actions to report the final build status
    post {
        success {
            echo "✅ Pipeline finished successfully - All requirements for this stage met"
        }
        failure {
            echo "❌ Pipeline failed - Check the deployment or the external monitor status"
        }
    }
}