FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

FROM eclipse-temurin:21-jdk
WORKDIR /app
# Vì packaging là war nên copy file .war
COPY --from=build /app/target/app.war app.war
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.war"]
