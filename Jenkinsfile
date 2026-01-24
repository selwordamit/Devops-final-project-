
// ---- Linux Pipeline (Current Production) ----

pipeline {
    agent any

    tools {
        nodejs 'Node20'
    }
    
    triggers {
        // Requirement 6: Polls GitHub for changes and runs every 5 minutes
        pollSCM('H/5 * * * *')
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

        stage('External Monitoring Status') {
            steps {
                echo "✅ Requirement 6: Querying UptimeRobot API for Status"
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

        // --- Heavy Testing Block ---
        // These stages run ONLY on Code Change or Manual Build to prevent server crash loops
        stage('Automated Quality Tests') {
            when {
                not { triggeredBy 'TimerTrigger' }
            }
            stages {
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