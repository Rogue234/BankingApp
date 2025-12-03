FROM ubuntu:22.04
RUN apt-get update && apt-get install -y openjdk-17-jre wget curl
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
                                        
