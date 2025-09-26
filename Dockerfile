# Stage 1: Build the WAR using Maven
FROM maven:3.9.0-eclipse-temurin-17 AS build

# Set working directory
WORKDIR /app

# Copy pom.xml and src folder into container
COPY pom.xml .
COPY src ./src

# Build the WAR
RUN mvn clean package -DskipTests

# Stage 2: Use Tomcat to run the WAR
FROM tomcat:10.1-jdk17

# Remove default ROOT app
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy WAR from build stage
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
