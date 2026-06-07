# Quick Start

## 30-Second Setup

```bash
# 1. Run the script with a GitHub repo
./setup-jvm-devcontainer.sh myuser/myrepo

# 2. Open in VS Code
cd myrepo
code .

# 3. Reopen in container
# Press Ctrl+Shift+P → "Dev Containers: Reopen in Container"

# Done! Now you have:
# - Java 21, Maven, Gradle, SBT, Kotlin
# - VS Code Java extensions
# - Ready to build and run
```

## Common Commands

```bash
# Clone and setup
./setup-jvm-devcontainer.sh spring-projects/spring-boot

# With custom directory
./setup-jvm-devcontainer.sh -d ~/projects/myapp myuser/myrepo

# Using SSH (private repos)
./setup-jvm-devcontainer.sh git@github.com:myuser/private.git

# Help
./setup-jvm-devcontainer.sh --help
```

## Inside the Dev Container

```bash
# Maven
mvn clean install
mvn test
mvn spring-boot:run

# Gradle  
gradle build
gradle test
gradle run

# Kotlin
kotlinc MyFile.kt -include-runtime -d app.jar
java -jar app.jar

# Scala + SBT
sbt compile
sbt test
sbt run
```

That's it! 🚀
