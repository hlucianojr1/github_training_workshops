# Multi-stage build for Java Spring Boot backend
# Stage 1: Build the application
FROM gradle:8-jdk21 AS build

WORKDIR /app

# Copy gradle files first for better layer caching
COPY build.gradle settings.gradle gradlew ./
COPY gradle gradle/

# Download dependencies (cached layer)
RUN gradle dependencies --no-daemon || true

# Copy source code
COPY src src/

# Build the application
RUN gradle bootJar --no-daemon

# Stage 2: Runtime
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Create non-root user for security
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copy the built JAR from build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
