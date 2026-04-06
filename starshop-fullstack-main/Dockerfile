# PHẦN 1: BUILD
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
# Chỉ copy file pom trước để tận dụng cache của Docker (build sẽ nhanh hơn)
COPY pom.xml .
RUN mvn dependency:go-offline

COPY . .
RUN mvn clean package -DskipTests

# PHẦN 2: RUN
FROM eclipse-temurin:21-jdk
WORKDIR /app
# Dùng dấu * để hốt file jar, và đảm bảo nó vào đúng thư mục /app/app.jar
COPY --from=build /app/target/*.jar /app/app.jar

EXPOSE 8080
# Chạy với đường dẫn tuyệt đối cho chắc chắn
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
