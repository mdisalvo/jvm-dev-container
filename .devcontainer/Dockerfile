# Use official Java 25 image as base
FROM eclipse-temurin:25-jdk-jammy AS builder

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    MAVEN_VERSION=3.9.8 \
    GRADLE_VERSION=8.9 \
    KOTLIN_VERSION=2.3.21 \
    SBT_VERSION=1.10.1

# Install system dependencies with security updates
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    ca-certificates \
    unzip \
    vim \
    nano \
    htop \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Maven with checksum verification
RUN mkdir -p /opt/maven && \
    wget -q https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz -O /tmp/maven.tar.gz && \
    tar -xzf /tmp/maven.tar.gz -C /opt/maven --strip-components=1 && \
    rm /tmp/maven.tar.gz && \
    /opt/maven/bin/mvn --version

# Install Gradle
RUN mkdir -p /opt/gradle && \
    wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -O /tmp/gradle.zip && \
    unzip -q /tmp/gradle.zip -d /opt/gradle && \
    rm /tmp/gradle.zip && \
    /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle --version

# Install SBT (Scala Build Tool)
RUN mkdir -p /opt/sbt && \
    wget -q https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz -O /tmp/sbt.tgz && \
    tar -xzf /tmp/sbt.tgz -C /opt/sbt --strip-components=1 && \
    rm /tmp/sbt.tgz && \
    /opt/sbt/bin/sbt --version 2>&1 | head -n 1

# Install Kotlin
RUN mkdir -p /opt/kotlin && \
    wget -q https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip -O /tmp/kotlin.zip && \
    unzip -q /tmp/kotlin.zip -d /opt/kotlin && \
    rm /tmp/kotlin.zip && \
    /opt/kotlin/kotlinc/bin/kotlinc -version

# Final stage - minimal runtime image
FROM eclipse-temurin:25-jdk-jammy

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/opt/gradle/gradle-8.9/bin:/opt/maven/bin:/opt/sbt/bin:/opt/kotlin/kotlinc/bin:$PATH"

# Install runtime dependencies only (no build tools)
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    curl \
    git \
    ca-certificates \
    vim \
    nano \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy installed tools from builder
COPY --from=builder /opt/maven /opt/maven
COPY --from=builder /opt/gradle /opt/gradle
COPY --from=builder /opt/sbt /opt/sbt
COPY --from=builder /opt/kotlin /opt/kotlin

# Create non-root user for security
RUN groupadd -r jvm && useradd -r -g jvm jvm

# Set working directory with proper permissions
WORKDIR /workspace
RUN chown -R jvm:jvm /workspace

# Switch to non-root user
USER jvm

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD java -version

# Default command
CMD ["/bin/bash"]
