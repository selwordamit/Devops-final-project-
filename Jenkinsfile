//     ---PowerShell Pipeline Do not Delete--- 

/*pipeline {
    agent any

    tools {
        nodejs 'Node20'
    }

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

    tools {
        nodejs 'Node20'
    }
    
    triggers {
        // Polls GitHub for changes every 5 minutes
        pollSCM('H/5 * * * *')
        // Scheduled run every 5 minutes for monitoring
        cron('H/5 * * * *')
    }

    environment {
        // Path to the application folder on the server
        TOMCAT_WEBAPP = "/var/lib/tomcat9/webapps/Devops-final-project-/adamliadadiramityuri"
        // Public address for the application
        APP_URL = "http://4.178.56.71:8081/Devops-final-project-/adamliadadiramityuri/"
    }

    stages {
        stage('Initialize') {
            steps {
                echo "✅ STARTING PROCESS"
                echo "Current Server Time: ${sh(script: 'date', returnStdout: true).trim()}"
            }
        }

        stage('Checkout') {
            steps {
                echo "✅ Fetching latest source code from GitHub"
                checkout scm
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                echo "✅ Deploying index.jsp to production"
                sh "cp adamliadadiramityuri/index.jsp ${TOMCAT_WEBAPP}/index.jsp"
            }
        }

        stage('Selenium Tests') {
            steps {
                echo "✅ Running Selenium UI tests"
                sh '''
                    set -e
                    export MOZ_HEADLESS=1
                    npx --yes selenium-side-runner "selenium/test_page.side" --base-url "$APP_URL" --capabilities "browserName=firefox"
                '''
            }
        }

        stage('External Monitoring Status') {
            steps {
                echo "✅ Querying UptimeRobot API for Status"
                withCredentials([string(credentialsId: 'uptimerobot-api-key', variable: 'UPTIME_KEY')]) {
                    script {
                        def response = sh(
                            script: 'curl -X POST https://api.uptimerobot.com/v2/getMonitors -d "api_key=${UPTIME_KEY}&format=json" -s',
                            returnStdout: true
                        )
                        
                        if (response.contains('"status":2')) {
                            echo "✅ MONITOR STATUS: ONLINE"
                        } else {
                            error("❌ MONITOR ALERT: Application is reported as DOWN")
                        }
                    }
                }
            }
        }

        stage('Load Test (Gatling)') {
            steps {
                echo "✅ Starting Load Test (Gatling)"
                sh 'mvn gatling:test -Dgatling.simulationClass=Load3Min -Dgatling.jvmArgs="-Xmx128m"'
            }
        }

        stage('Stress Test (Gatling)') {
            steps {
                echo "✅ Starting Stress Test (Gatling)"
                sh 'mvn gatling:test -Dgatling.simulationClass=Stress3Min -Dgatling.jvmArgs="-Xmx128m"'
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully"
            // For gatling graphs 
            gatlingArchive()
        }
        failure {
            echo "❌ Pipeline failed"
        }
    }
}