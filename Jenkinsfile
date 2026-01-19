pipeline {
    agent any

    triggers {
        // Poll the SCM every 5 minutes.
        // The pipeline will run only if changes are detected in the repository.
        pollSCM('H/5 * * * *')

        // Optional: run the pipeline every 5 minutes even without SCM changes.
        // Keep this if you want periodic monitoring checks.
        cron('H/5 * * * *')
    }

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    environment {
        // ---------- Deploy paths ----------
        SRC = "${WORKSPACE}\\adamliadadiramityuri\\index.jsp"
        DST = "C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Devops-final-project-\\adamliadadiramityuri\\index.jsp"

        // ---------- Monitoring ----------
        HEALTH_URL = "http://localhost:8080/Devops-final-project-/adamliadadiramityuri/"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Deploy JSP to Tomcat') {
            steps {
                bat '''
@echo off
echo SRC=%SRC%
echo DST=%DST%

if not exist "%SRC%" (
    echo ERROR: source file not found: %SRC%
    dir /s /b "%WORKSPACE%\\index.jsp"
    exit /b 1
)

copy /Y "%SRC%" "%DST%"
if errorlevel 1 exit /b 1

echo DONE
'''
            }
        }

        stage('Monitor Check') {
            steps {
                bat '''
@echo off
echo Checking %HEALTH_URL%

powershell -NoProfile -Command "
try {
    $r = Invoke-WebRequest -UseBasicParsing -TimeoutSec 10 -Uri '%HEALTH_URL%' -ErrorAction Stop
    Write-Host ('STATUS CODE: ' + $r.StatusCode)
    if ($r.StatusCode -ge 200 -and $r.StatusCode -lt 400) { exit 0 } else { exit 1 }
}
catch {
    if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
        $code = [int]$_.Exception.Response.StatusCode
        Write-Host ('STATUS CODE: ' + $code)
    }
    else {
        Write-Host ('ERROR: ' + $_.Exception.Message)
    }
    exit 1
}
"

exit /b %ERRORLEVEL%
'''
            }
        }
    }

    post {
        success {
            echo 'Pipeline finished successfully.'
        }
        failure {
            echo 'Pipeline failed. Check console output.'
        }
    }
}
