# JVM Dev Container Setup Script

Automatically clone a GitHub repository and add JVM dev container configuration to it.

## Overview

This bash script automates the process of:
1. Cloning a GitHub repository
2. Setting up a complete JVM dev container configuration
3. Preparing the repo for VS Code remote development

Supports **Java, Kotlin, Scala, and any JVM language**.

## Requirements

- `bash` 4.0+
- `git` installed and configured
- GitHub repository access (public or private with SSH/token)
- VS Code with [Remote - Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## Installation

1. **Download the script**:
   ```bash
   # Copy setup-jvm-devcontainer.sh to your system
   chmod +x setup-jvm-devcontainer.sh
   ```

2. **Keep the script alongside devcontainer files**:
   ```
   your-workspace/
   ├── setup-jvm-devcontainer.sh
   ├── .devcontainer/
   │   ├── Dockerfile
   │   └── devcontainer.json
   └── README.md
   ```

## Usage

### Basic Usage

```bash
./setup-jvm-devcontainer.sh <github-repo>
```

### Repository Reference Formats

The script accepts multiple formats for the GitHub repository:

**Format 1: Short form (owner/repo)**
```bash
./setup-jvm-devcontainer.sh myuser/myrepo
```

**Format 2: Full HTTPS URL**
```bash
./setup-jvm-devcontainer.sh https://github.com/myuser/myrepo
```

**Format 3: Full HTTPS URL with .git**
```bash
./setup-jvm-devcontainer.sh https://github.com/myuser/myrepo.git
```

**Format 4: SSH URL**
```bash
./setup-jvm-devcontainer.sh git@github.com:myuser/myrepo.git
```

### With Custom Output Directory

```bash
./setup-jvm-devcontainer.sh -d /path/to/target myuser/myrepo
./setup-jvm-devcontainer.sh --dir ./my-projects myuser/myrepo
```

### Help

```bash
./setup-jvm-devcontainer.sh -h
./setup-jvm-devcontainer.sh --help
```

## Examples

### Clone a Public Repository

```bash
./setup-jvm-devcontainer.sh spring-projects/spring-boot
```

Output:
```
[INFO] Checking prerequisites...
[SUCCESS] All prerequisites met
[INFO] Repository: spring-boot
[INFO] Target directory: spring-boot
[INFO] Cloning repository: https://github.com/spring-projects/spring-boot.git
...
[SUCCESS] Repository cloned successfully
[SUCCESS] Copied Dockerfile
[SUCCESS] Copied devcontainer.json
[SUCCESS] Dev container setup complete!
```

### Clone to Specific Directory

```bash
./setup-jvm-devcontainer.sh -d ~/projects/myapp myuser/myapp
```

### Clone a Private Repository (SSH)

```bash
./setup-jvm-devcontainer.sh git@github.com:myuser/private-repo.git
```

## What Gets Added

### File Structure

```
cloned-repo/
├── .devcontainer/
│   ├── Dockerfile          # JVM 21, Maven, Gradle, SBT, Kotlin
│   └── devcontainer.json   # VS Code dev container config
├── .gitignore              # Pre-configured for JVM projects
├── src/
├── pom.xml (or build.gradle)
└── [other original files]
```

### Dockerfile Includes

- **Java 25 LTS**
- **Maven 3.9.16** - Classical build tool
- **Gradle 9.5.1** - Modern build system
- **SBT 1.12.12** - Scala Build Tool
- **Kotlin 2.3.21** - Kotlin compiler and REPL
- **Git** - Version control
- **Common utilities** - curl, wget, vim, nano, htop

### VS Code Extensions

Automatically installed when opening in dev container:
- Extension Pack for Java
- Maven for Java
- Gradle for Java
- Kotlin Language
- Metals (Scala IDE)
- GitLens
- GitHub Copilot (optional)

## Workflow Example

```bash
# 1. Setup a new project
./setup-jvm-devcontainer.sh spring-projects/spring-petclinic

# 2. Navigate into the repo
cd spring-petclinic

# 3. Open in VS Code
code .

# 4. In VS Code:
#    - Press Ctrl+Shift+P (Cmd+Shift+P on Mac)
#    - Select "Dev Containers: Reopen in Container"
#    - Wait for container to build (~5-10 minutes first time)

# 5. Inside the container terminal:
mvn clean install
mvn spring-boot:run

# 6. (Optional) Commit the dev container config
git add .devcontainer/ .gitignore
git commit -m "Add JVM dev container configuration"
git push
```

## Troubleshooting

### Script Not Executable
```bash
chmod +x setup-jvm-devcontainer.sh
```

### Permission Denied on Clone
Ensure you have access to the repository:
- For public repos: no action needed
- For private repos: use SSH with configured keys
  ```bash
  git config --global user.name "Your Name"
  git config --global user.email "your@email.com"
  ```

### .devcontainer Files Not Found
Ensure the `.devcontainer/` folder is in the same location as the script:
```bash
ls -la .devcontainer/
# Should show: Dockerfile, devcontainer.json
```

### Docker Build Fails
The container may need to download ~500MB of tools on first build. Ensure:
- Docker Desktop is running
- Sufficient disk space (2GB+)
- Internet connection is stable

## Advanced Usage

### Batch Setup Multiple Repos

```bash
#!/bin/bash
repos=(
  "spring-projects/spring-boot"
  "apache/kafka"
  "gradle/gradle"
)

for repo in "${repos[@]}"; do
  ./setup-jvm-devcontainer.sh "$repo"
done
```

### Custom Directory Structure

```bash
mkdir -p ~/dev/jvm-projects
cd ~/dev/jvm-projects
/path/to/setup-jvm-devcontainer.sh myuser/myrepo
```

### Integration with Dotfiles

If you use dotfiles, you can store the script in your dotfiles repo:
```bash
~/dotfiles/scripts/setup-jvm-devcontainer.sh
```

## Notes

- The script uses `set -euo pipefail` for safety (exits on error)
- Color output for better readability
- Git files are staged but not committed (you control the commit)
- Original repository history is preserved
- Safe to re-run (will error if directory exists)

## Contributing

To improve the script:
1. Test with various repositories
2. Report issues with error messages and outputs
3. Suggest enhancements

## Resources

- [VS Code Dev Containers Docs](https://code.visualstudio.com/docs/remote/containers)
- [Docker Documentation](https://docs.docker.com/)
- [GitHub CLI Installation](https://cli.github.com/manual/installation)

## License

This script is provided as-is for development purposes.
