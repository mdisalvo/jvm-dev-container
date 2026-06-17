# Use official Java 21 image as base
FROM eclipse-temurin:21-jdk-jammy

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LEININGEN_VERSION=2.10.0 \
    MAVEN_VERSION=3.9.6 \
    PATH="/opt/gradle/gradle-8.5/bin:/opt/maven/bin:/opt/sbt/bin:/opt/kotlin/kotlinc/bin:/root/.lein:$PATH"

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    ca-certificates \
    unzip \
    vim \
    nano \
    htop \
    && rm -rf /var/lib/apt/lists/*

# Download and install Leiningen from Codeberg
RUN mkdir -p /root/.lein && \
    wget -q https://codeberg.org/leiningen/leiningen/raw/stable/bin/lein -O /root/.lein/lein && \
    chmod +x /root/.lein/lein && \
    /root/.lein/lein version

# Install Maven
RUN mkdir -p /opt/maven && \
    wget -q https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz -O /tmp/maven.tar.gz && \
    tar -xzf /tmp/maven.tar.gz -C /opt/maven --strip-components=1 && \
    rm /tmp/maven.tar.gz && \
    mvn --version

# Install Gradle
RUN mkdir -p /opt/gradle && \
    wget -q https://services.gradle.org/distributions/gradle-8.5-bin.zip -O /tmp/gradle.zip && \
    unzip -q /tmp/gradle.zip -d /opt/gradle && \
    rm /tmp/gradle.zip && \
    /opt/gradle/gradle-8.5/bin/gradle --version

# Install SBT (Scala Build Tool)
RUN mkdir -p /opt/sbt && \
    wget -q https://github.com/sbt/sbt/releases/download/v1.9.7/sbt-1.9.7.tgz -O /tmp/sbt.tgz && \
    tar -xzf /tmp/sbt.tgz -C /opt/sbt --strip-components=1 && \
    rm /tmp/sbt.tgz && \
    /opt/sbt/bin/sbt --version 2>&1 | head -n 1

# Install Kotlin
RUN mkdir -p /opt/kotlin && \
    wget -q https://github.com/JetBrains/kotlin/releases/download/v2.3.21/kotlin-compiler-2.3.21.zip -O /tmp/kotlin.zip && \
    unzip -q /tmp/kotlin.zip -d /opt/kotlin && \
    rm /tmp/kotlin.zip && \
    /opt/kotlin/kotlinc/bin/kotlinc -version

# Set working directory
WORKDIR /workspace

# Default command
CMD ["/bin/bash"]
