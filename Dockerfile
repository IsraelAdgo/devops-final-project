FROM tomcat:latest
COPY app /usr/local/tomcat/webapps/app
EXPOSE 8080
CMD ["catalina.sh","run"]