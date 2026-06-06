# All-Purpose JVM VS Code Dev Container

A complete VS Code dev container setup for JVM development with Java 21, Maven, Gradle, SBT, and Kotlin.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop) installed and running
- [VS Code](https://code.visualstudio.com/) with the [Remote - Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## Getting Started

### 1. Open in Dev Container

1. Clone or create your JVM project with this `.devcontainer` folder in the root
2. Open the project folder in VS Code
3. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac) and select **"Dev Containers: Reopen in Container"**
4. Wait for the container to build and start (first build takes 5-10 minutes on first run)

### 2. Create a New Project

Choose your language and build tool:

**Maven + Java:**
```bash
mvn archetype:generate -DgroupId=com.example -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
cd my-app
mvn clean package
```

**Gradle + Java:**
```bash
gradle init --type java-application --dsl groovy --package com.example
cd app
gradle build
```

**Kotlin + Gradle:**
```bash
gradle init --type kotlin-application --dsl groovy --package com.example
cd app
gradle build
```

**Scala + SBT:**
```bash
mkdir my-scala-app && cd my-scala-app
sbt new scala/scala-seed.g8
```

## What's Included

- **Java 21 LTS** - Latest stable Java version
- **Maven 3.9.6** - Build automation and dependency management
- **Gradle 8.5** - Advanced build automation with Kotlin DSL support
- **SBT 1.9.7** - Scala build tool
- **Kotlin 1.9.21** - First-class Kotlin support
- **Git & GitHub CLI** - Version control tools
- **Extension Pack for Java** - Full Java IDE support
- **Maven cache mount** - Persistent `.m2` cache
- **Gradle cache mount** - Persistent `.gradle` cache
- **SBT cache mount** - Persistent `.sbt` cache

## Forwarded Ports

The container forwards these ports for convenient access:
- **3000** - Application server (default)
- **5005** - Java remote debug port
- **8080** - HTTP server (e.g., Tomcat, Spring Boot)
- **8888** - Local development server
- **9000** - SonarQube or other analysis tools

## VS Code Extensions

Automatically installed:
- **Extension Pack for Java** - Java IDE with debugging and testing
- **Maven for Java** - Maven support in VS Code
- **Gradle for Java** - Gradle build support
- **Kotlin Language** - Kotlin support and debugger
- **Metals** - Scala IDE with LSP support
- **GitHub Copilot** - AI assistance (optional, requires GitHub account)
- **GitLens** - Git history and blame visualization

## Useful Commands

### Verify Installation
```bash
java -version
mvn --version
gradle --version
sbt --version
kotlinc -version
```

### Maven
```bash
mvn clean install
mvn test
mvn spring-boot:run
```

### Gradle
```bash
gradle build
gradle test
gradle run
gradle bootRun  # For Spring Boot
```

### Kotlin
```bash
kotlinc -help
kotlinc Main.kt -include-runtime -d Main.jar
java -jar Main.jar
```

### Scala + SBT
```bash
sbt compile
sbt test
sbt run
sbt console  # Interactive Scala REPL
```

### Java
```bash
javac MyClass.java
java MyClass
jar cf my-app.jar *.class
```

## Troubleshooting

### Container fails to build
- Ensure Docker is running
- Delete the `.devcontainer` folder from your VS Code workspace and rebuild
- Check Docker logs: `docker logs <container-id>`

### Can't connect to REPL in Calva
- Make sure the REPL is running: `lein repl` in the terminal
- Try disconnecting (Ctrl+Alt+C Ctrl+Alt+D) and reconnecting

### Slow dependency downloads
- Maven downloads are cached in `/root/.m2`
- First build may take time; subsequent builds are faster

### Port already in use
- Modify the port mappings in `devcontainer.json` under `forwardPorts`

## Customization

### Modify Java Version
Edit the `FROM` line in `Dockerfile`:
```dockerfile
FROM eclipse-temurin:21-jdk-jammy  # Change 21 to 17, 11, etc.
```

### Remove Unnecessary Tools
To reduce image size, comment out tools you don't need in `Dockerfile`:
```dockerfile
# RUN mkdir -p /opt/sbt && \  # Skip SBT if not using Scala
#     wget -q https://...
```

### Add More VS Code Extensions
Add extension IDs to the `extensions` array in `devcontainer.json`:
```json
"extensions": [
  "ms-vscode.extension-pack-for-java",
  "your-extension-id"
]
```

### Change Default Port Forwards
Edit `forwardPorts` in `devcontainer.json`:
```json
"forwardPorts": [3000, 5005, 8080, 8888, 9000, 9200]
```

## Resources

- [Java Official Documentation](https://docs.oracle.com/en/java/)
- [Maven Documentation](https://maven.apache.org/guides/index.html)
- [Gradle Documentation](https://docs.gradle.org/)
- [Kotlin Official Site](https://kotlinlang.org/)
- [Scala Official Site](https://www.scala-lang.org/)
- [SBT Documentation](https://www.scala-sbt.org/documentation.html)
- [VS Code Dev Containers](https://code.visualstudio.com/docs/remote/containers)
- [Eclipse Temurin (Java Distribution)](https://adoptium.net/)

## License

This dev container configuration is provided as-is for development purposes.
