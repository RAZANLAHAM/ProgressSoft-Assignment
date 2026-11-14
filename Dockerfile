FROM tomcat:9.0-jdk17-temurin

COPY sample-app/sample-app.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080 

