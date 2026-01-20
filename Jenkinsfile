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
        // Polls GitHub for code changes every 5 minutes
        pollSCM('H/5 * * * *')
        // Force-runs the pipeline every 5 minutes for health monitoring (CRON)
        cron('H/5 * * * *')
    }

    environment {
        TOMCAT_WEBAPP = "/var/lib/tomcat9/webapps/Devops-final-project-/adamliadadiramityuri"
        // Target URL for monitoring
        APP_URL = "http://4.178.56.71:8081/Devops-final-project-/adamliadadiramityuri/"
    }

    stages {
        stage('Initialize') {
            steps {
                echo "✅ STARTING PROCESS"
                // Log server time for audit trail
                echo "Current Server Time: ${sh(script: 'date', returnStdout: true).trim()}"
            }
        }

        stage('Checkout') {
            steps {
                echo "✅ Fetching latest source code from GitHub"
                // SCM checkout is handled automatically by Jenkins job configuration
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                echo "✅ Deploying index.jsp to production (Requirement #4)"
                // Copy the file to the Tomcat directory on the Azure Linux VM
                sh "cp adamliadadiramityuri/index.jsp ${TOMCAT_WEBAPP}/index.jsp"
            }
        }

        stage('External Monitoring Status') {
            steps {
                echo "🔍 Querying UptimeRobot API for Status & Performance Graphs (Requirement #6)"
                
                // Retrieving the API Key from Jenkins Credentials store for security
                withCredentials([string(credentialsId: 'uptimerobot-api-key', variable: 'UPTIME_KEY')]) {
                    script {
                        // Requesting monitor data from UptimeRobot via POST request
                        def response = sh(
                            script: "curl -X POST https://api.uptimerobot.com/v2/getMonitors -d 'api_key=${UPTIME_KEY}&format=json' -s",
                            returnStdout: true
                        )
                        
                        // status 2 in UptimeRobot indicates the site is UP
                        if (response.contains('"status":2')) {
                            echo "-------------------------------------------------------"
                            echo "✅MONITOR STATUS: ONLINE"
                            echo "Performance metrics are being logged to UptimeRobot"
                            echo "-------------------------------------------------------"
                        } else {
                            // Failing the build if the external monitor reports an issue
                            error("❌ MONITOR ALERT: Application is reported as DOWN by UptimeRobot")
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Success"
        }
        failure {
            echo "❌ Failure
        }
    }
}