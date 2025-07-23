# Base image with Java 17 and Maven
FROM maven:3.9.6-eclipse-temurin-17 AS builder

# Set working directory
WORKDIR /app

# Copy only pom.xml first for dependency caching
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy the rest of the source code
COPY . .

# Build the plugin (skip tests to speed up if desired)
RUN mvn clean install -DskipTests

# Final image with just the .hpi artifact (optional)
FROM eclipse-temurin:17-jdk

# Set working directory
WORKDIR /plugin

# Copy the built HPI file from builder
COPY --from=builder /app/target/github-checks.hpi .

# Default command
CMD ["ls", "-lh", "/plugin"]
