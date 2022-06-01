# Docker:
1. Pulling tomcat image  
`docker pull tomcat`

2. Test tomcat  
`docker run -p=8082:8080  -v /home/liad/Desktop/webapps:/usr/local/tomcat/webapps/status tomcat`

3. Pull Jenkins (https://hub.docker.com/r/jenkins/jenkins)  
`docker pull jenkins/jenkins`

4. Test Jenkins  
`docker run -u root --privileged -p 8081:8080 -p 50000:50000 -d -v D:/jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock jenkins/jenkins`

# App:
1. Create `index.jsp`
```
<!doctype html>
<h1>Mini Webapp of Aliza!</h1>
<%
  for (int i = 0; i < 5; ++i) {
      out.println("<p>Hello, Hello, Hello, Hello, Hello, Hello, Hello!</p>");
  }
%>
```
2. Create `WEB-INF/web.xml`
```
<web-app>
</web-app>
```
3. Create `Dockerfile`
```
FROM tomcat:latest # Pulls latest tomcat
COPY app /usr/local/tomcat/webapps/app # Copies webapp files
EXPOSE 8080 # Exposing port
CMD ["catalina.sh","run"] # Runs webapp with tomcat
```
4. Build docker webapp image.  
`docker build -t=webapp .`
5. Run webapp container using  
`docker run -p=8082:8080 -v {volume}:/usr/local/tomcat/webapps/status webapp`
6. Open  
`http://localhost:8082/app`

# Docker Compose
1. Create `docker-compose.yaml` to start the webapp with it.
```
version: '3'
services:
  tomcat:
    image: tomcat:latest
    volumes:
      - .:/usr/local/tomcat/webapps
    ports:
      - 8082:8080
```
2. Test `http://localhost:8888/`

# Starting the App via jenkins.
1. New item
2. Freestyle Project
3. Source Code Management - `mark Git`
4. Input Project URL.
5. Change Branch name to "main" (it's the new standart - and it's the main branch in the git repo)
6. Mark "`GitHub hook trigger for GITScm polling`" - this will insure a build on push to github.
7. **Build:**
  - Add build step **->** Execute Shell
  - `docker build -t=webapp .`
8. **Build:**
  - Add build step **->** Execute Shell
  - `docker run -p=8888:8080 -d -v /.:/usr/local/tomcat/webapps/status webapp`
  - _**OR**_ you can use `docekr-compose up -d` to run via docker compose.
9. **Post-build Actions:**
  - Monitor Site
  - URL = `http://{machine ip}:8082/app`
  - Success Response Codes = `200`
  - Timeout in seconds = `10` 

# Adding a second Job as "monitor":
1. New item.
2. Freestyle Project
3. Mark [v] Build periodically - inside the text box, insert `* * * * *` (5 stars) - this is cronjob syntax to tell "build every minute".
4. **Build:**
  - Add build step **->** Execute Shell
  - inside text box - `docker ps`
5. **Post-build Actions:** (as previously)  
  - Monitor Site
  - URL = `http://{machine ip}:8082/app`
  - Success Response Codes = `200`
  - Timeout in seconds = `10` 


# Monitor:
To monitor a website, you need to install inside Jenkins "SiteMonitor" plugin, and then **in our application** we can monitor it by writing the IP of the machine that the jenkins runs on, and the APP url.

# Debug:
- If docker missing inside container:  

1. run (This will let u "enter" the container with a terminal):  
  `docker exec -it {id} /bin/bash`

2. run (This will install docker inside container.):
    ```
    curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-17.04.0-ce.tgz \
    && tar xzvf docker-17.04.0-ce.tgz \
    && mv docker/docker /usr/local/bin \
    && rm -r docker docker-17.04.0-ce.tgz
    ```