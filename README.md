# Usage.

### **STEP 1** : Dowload base images.
1. docker pull tomcat:latest
2. docker pull jenkins/jenkins


### **STEP 2** : Docker compose.
`X` = path to jenkins home - Root of jenkins, config etc.  
`Y` = path to webapps location - Just a folder. (Jenkins and Tomcat share this folder)
```  
version: '3'
services:
  tomcat:
    image: tomcat:latest
    volumes:
      - {Y}:/usr/local/tomcat/webapps
    ports:
      - 8082:8080
  jenkins:
    image: jenkins/jenkins
    volumes:
      - {X}:/var/jenkins_home
      - {Y}:/home/webapps
    ports:
      - 8081:8080
      - 50000:50000
```

### **STEP 3** : Setup Jenkins.
Just setup Jenkins with initial settings.
  - install `SiteMonitor` plugin.

### **STEP 4** : Creating Job.
1. Create new Job (`Freestyle project`)
2. `Source Code Management`:
    - mark Git
    - add URL of repo.
    - change branch to `main`
3. `Build Triggers`:
    - mark `GitHub hook trigger for GITScm polling`
4. `Build`:
    - `Execute shell`
    - cope `cp -r ./app /home/webapps/app` to the text box
5. `Post-build Actions`:
    - `Monitor Site`
    - URL = `http://{your machine ip}:8082/app`
    - Success Response Codes = `200`
    - Timeout in seconds = `10`