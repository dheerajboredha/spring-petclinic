# FROM maven:3.9.11-eclipse-temurin-17 AS build
# RUN apt-get update && apt-get install -y git
# RUN git clone https://github.com/dheerajboredha/spring-petclinic.git && \
#     cd spring-petclinic && \
#     mvn package

# FROM openjdk:25-ea-17-jdk AS run
# RUN adduser -m -d /usr/share/spc -s /bin/bash testuser1
# USER testuser1
# WORKDIR /usr/share/spc
# COPY --from=build /spring-petclinic/target/*.jar name.jar
# EXPOSE 8080/tcp
# CMD ["java", "-jar", "name.jar"]

FROM openjdk:17
ADD https://trialbj18b6.jfrog.io/ui/native/javaspc-libs-release/spring-petclinic-4.0.0-SNAPSHOT.jar name.jar
EXPOSE 8080
CMD ["java", "-jar", "name.jar"]