FROM maven:3.9.9-eclipse-temurin-21 AS builder
WORKDIR /opt/app
COPY pom.xml ./
RUN mvn dependency:go-offline
COPY ./src ./src
RUN mvn clean install

FROM eclipse-temurin:21.0.8_9-jre-jammy AS production
WORKDIR /opt/app
EXPOSE 8080
COPY --from=builder /opt/app/target/*.jar /opt/app/*.jar
ENTRYPOINT ["java","-Dspring.profiles.active=production", "-jar", "/opt/app/*.jar"]