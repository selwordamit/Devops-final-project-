# DevOps Final Project: JSP Application & CI/CD Pipeline

This project demonstrates a complete **CI/CD pipeline implementation** for a **Java Server Pages (JSP)** web application, utilizing modern DevOps tools for automation, performance testing, and continuous monitoring.

---

## 🚀 Project Overview

The application is a simple **JSP-based web interface** that allows users to submit text and view processed results.  
The infrastructure is fully automated, deploying to an **Apache Tomcat 9** server on a **Linux environment** via a **Jenkins Declarative Pipeline**.

**Workflow:**  
`GitHub → Jenkins → Apache Tomcat → Monitoring & Testing`

---

## 🛠 Technologies & Tools

**Web Server:** Apache Tomcat 9  
**CI/CD Engine:** Jenkins (Declarative Pipeline)  
**Build Tool:** Maven  

**Testing Suite:**
- **Selenium IDE** – Automated UI & functional validations  
- **Gatling (Scala)** – Load & stress testing  

**Monitoring:**
- **UptimeRobot API** – Public endpoint availability tracking  

---

## 🏗 Pipeline Architecture

The `Jenkinsfile` defines a multi-stage lifecycle ensuring code quality and deployment stability:

1. **Initialize & Checkout**  
   Verifies environment and fetches the latest source code from GitHub.

2. **Deploy to Tomcat**  
   Automatically deploys `index.jsp` to:  
   `/var/lib/tomcat9/webapps/`

3. **External Monitoring Status**  
   Queries the **UptimeRobot API** to ensure the public endpoint is reachable.

4. **Automated Quality Tests**  
   Conditional execution:
   - Skips heavy tests during routine 5-minute cron checks  
   - Runs full test suite on SCM changes or manual triggers

   **Test Phases:**
   - **Selenium Tests:** 4 functional UI validations (headless Firefox)
   - **Load Test:** 27 concurrent users over 3 minutes
   - **Stress Test:** Ramp-up to 70 concurrent users to detect breaking point

---

## 📊 Testing Strategy

### Selenium UI Validations

Implemented **4 Hard Assertions** using Fail-Fast methodology:

- **Header Verification (h1)**  
  Confirms page identity: `"DevOps Project"`

- **Welcome Message (h2)**  
  Ensures static JSP content renders correctly

- **Result Box Validation**  
  Confirms server-side logic displays output container after submission

- **Data Integrity Check**  
  Matches submitted string `"DevOpsProject"` against displayed output

---

### Performance Benchmarking (Gatling)

**Load Simulation**
- Ramp from 1 → 27 users in 30 seconds  
- Maintain steady load for 3 minutes  

**Stress Simulation**
- Linear ramp-up to 70 users over 3 minutes  

**Quality Gates**
- Pipeline fails if:
  - Success rate < **90%**
  - Response time exceeds defined thresholds

---

## 📋 Prerequisites & Configuration

To replicate this environment:

**Jenkins Plugins**
- NodeJS  
- Maven  
- Gatling  
- Pipeline  

**Credentials**
- Jenkins Secret Text: `uptimerobot-api-key`

**Environment**
- Linux server  
- Apache Tomcat 9  
- Public IP address  

---

## 👥 Authors

Adam  
Liad  
Adir  
Amit  
Yuri  

---
