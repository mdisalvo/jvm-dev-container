# Docker Hub Publishing Workflow Guide

This guide explains how to set up automated Docker image builds and publishing to Docker Hub on GitHub releases.

## Overview

Two GitHub Actions workflows are provided:

1. **`publish-docker.yml`** - Direct Docker buildx approach (recommended)
2. **`publish-docker-devcontainer-cli.yml`** - Using devcontainer-cli tool

## Prerequisites

### 1. Docker Hub Account

- Create a free account at [hub.docker.com](https://hub.docker.com)
- Create a public repository named `jvm-devcontainer`

### 2. Docker Hub Credentials

Generate a personal access token:

1. Go to [Docker Hub Account Settings](https://hub.docker.com/settings/security)
2. Click **"New Access Token"**
3. Name: `GITHUB_ACTIONS` (or similar)
4. Permissions: **Read, Write, Delete**
5. Copy the token (you'll need it shortly)

### 3. GitHub Repository Secrets

Add the Docker Hub credentials to your repository:

1. Go to **Settings → Secrets and variables → Actions**
2. Click **"New repository secret"**

Create these secrets:

| Secret Name | Value |
|-------------|-------|
| `DOCKER_HUB_USERNAME` | Your Docker Hub username |
| `DOCKER_HUB_TOKEN` | The PAT token from step 2 |

Example:
```
DOCKER_HUB_USERNAME: michaeldisalvo
DOCKER_HUB_TOKEN: dckr_pat_xxxxxxxxxxxx
```

## Setup Instructions

### Step 1: Choose a Workflow

**Option A: Direct Docker Buildx (Recommended)**
- Simpler and faster
- Uses GitHub Actions' native Docker support
- Best for most use cases
- File: `.github/workflows/publish-docker.yml`

**Option B: Devcontainer CLI**
- Validates devcontainer configuration
- More explicit control over build process
- Better for complex scenarios
- File: `.github/workflows/publish-docker-devcontainer-cli.yml`

### Step 2: Create Workflow File

Copy the desired workflow file to your repository:

```bash
# For direct Docker buildx (recommended)
cp publish-docker.yml .github/workflows/

# OR for devcontainer-cli
cp publish-docker-devcontainer-cli.yml .github/workflows/
```

### Step 3: Customize the Workflow

Edit the workflow file and update:

```yaml
env:
  REGISTRY: docker.io
  IMAGE_NAME: ${{ secrets.DOCKER_HUB_USERNAME }}/jvm-devcontainer
```

If using a different image name:
```yaml
IMAGE_NAME: ${{ secrets.DOCKER_HUB_USERNAME }}/my-custom-image
```

### Step 4: Push to GitHub

```bash
git add .github/workflows/publish-docker.yml
git commit -m "Add Docker Hub publishing workflow"
git push
```

## Usage

### Automatic: On GitHub Release

1. Create a release on GitHub (e.g., v1.0.0)
2. Workflow automatically triggers
3. Docker image is built for amd64 and arm64
4. Image is pushed with tags:
   - `owner/image:1.0.0` (version tag)
   - `owner/image:latest` (latest tag)
5. Release notes are updated automatically

### Manual: Workflow Dispatch

Trigger manually from GitHub Actions UI:

1. Go to **Actions → Build and Publish Docker Image**
2. Click **Run workflow**
3. Enter a tag (e.g., `1.0.0`)
4. Click **Run workflow**

## Workflow Details

### Triggered Events

```yaml
on:
  release:
    types: [published]  # Triggers on GitHub release
  workflow_dispatch:    # Manual trigger option
```

### Build Platforms

Both workflows build for multiple architectures:

```yaml
platforms: linux/amd64,linux/arm64
```

- **linux/amd64** - Standard x86_64 (Intel/AMD processors)
- **linux/arm64** - ARM architecture (Apple Silicon M1/M2, ARM servers)

### Docker Image Tagging

Images are tagged with:

| Tag | Format | Example |
|-----|--------|---------|
| Version | `owner/image:VERSION` | `myuser/jvm-devcontainer:1.0.0` |
| Latest | `owner/image:latest` | `myuser/jvm-devcontainer:latest` |

## Workflow Comparison

### Direct Docker Buildx

**Pros:**
- ✅ Faster build times (native GitHub Actions integration)
- ✅ Simpler configuration
- ✅ Built-in caching support
- ✅ Single workflow step

**Cons:**
- ❌ Less validation of devcontainer config

**Best for:**
- Simple Docker builds
- Frequent releases
- Standard configurations

### Devcontainer CLI

**Pros:**
- ✅ Validates devcontainer.json syntax
- ✅ Explicit control over build process
- ✅ Better for debugging
- ✅ CLI tools available locally

**Cons:**
- ❌ Slightly slower builds
- ❌ More complex setup
- ❌ Manual manifest management

**Best for:**
- Complex scenarios
- Validating configurations
- Development workflows

## Monitoring and Debugging

### View Workflow Status

1. Go to **Actions** in your GitHub repository
2. Select **Build and Publish Docker Image**
3. Click on the latest run

### Check Build Logs

Click the workflow run to see:
- Build steps
- Docker image layers
- Push operations
- Any errors or warnings

### Troubleshooting

#### Build Fails with "Dockerfile not found"
- Ensure `.devcontainer/Dockerfile` exists
- Check file paths in workflow match your structure

#### Docker Hub Login Fails
- Verify secrets are set correctly:
  ```bash
  # In GitHub Actions, secrets won't display in logs
  # but errors will show if they're invalid
  ```
- Test credentials locally:
  ```bash
  docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_TOKEN
  ```

#### Multi-arch Build Fails
- Ensure buildx is properly installed:
  ```bash
  docker buildx ls  # Check available builders
  ```
- Check that arm64 emulation is available

#### Release Notes Comment Fails
- Ensure the token has proper permissions
- Check issue number extraction is working

## Example Release Flow

```bash
# 1. Create a release locally
git tag -a v1.0.0 -m "Release 1.0.0"
git push origin v1.0.0

# 2. GitHub creates release automatically or create via UI
# 3. Workflow automatically triggers
# 4. Docker image is built and pushed
# 5. Release notes are updated with Docker pull commands
```

## Docker Image Usage

### Pull the Image

```bash
docker pull myuser/jvm-devcontainer:1.0.0
docker pull myuser/jvm-devcontainer:latest
```

### Run the Image

```bash
# Interactive shell
docker run -it myuser/jvm-devcontainer:latest /bin/bash

# With current directory mounted
docker run -it -v $(pwd):/workspace myuser/jvm-devcontainer:latest

# Run a specific command
docker run --rm myuser/jvm-devcontainer:latest java -version
```

### Docker Compose

```yaml
version: '3.8'
services:
  jvm-dev:
    image: myuser/jvm-devcontainer:1.0.0
    volumes:
      - .:/workspace
    working_dir: /workspace
    stdin_open: true
    tty: true
```

## Advanced Configuration

### Custom Image Registry

For Docker registries other than Docker Hub:

```yaml
env:
  REGISTRY: ghcr.io  # GitHub Container Registry
  IMAGE_NAME: ${{ github.repository }}/jvm-devcontainer
```

### Building Only on Tag Push

Instead of releases, trigger on version tags:

```yaml
on:
  push:
    tags:
      - 'v*.*.*'
```

### Scheduled Builds

Rebuild with latest dependencies periodically:

```yaml
on:
  schedule:
    - cron: '0 0 * * 0'  # Weekly at midnight UTC
```

## Cleaning Up Old Images

Docker Hub will keep all pushed images. To save space:

1. Go to Docker Hub repository
2. Click on **Tags**
3. Delete old version tags (keep last 5-10)
4. Keep `latest` tag always

## Next Steps

1. ✅ Add secrets to GitHub
2. ✅ Copy workflow file to `.github/workflows/`
3. ✅ Push to repository
4. ✅ Create a release to trigger the workflow
5. ✅ Monitor the Actions tab
6. ✅ Verify image on Docker Hub

## Resources

- [Docker Hub Documentation](https://docs.docker.com/docker-hub/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Buildx Documentation](https://docs.docker.com/build/architecture/)
- [Devcontainer CLI GitHub](https://github.com/stuartleeks/devcontainer-cli)
- [GitHub Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

## Support

For issues:
- Check workflow logs in **Actions** tab
- Verify Docker Hub credentials
- Ensure `.devcontainer/` folder exists
- Review Dockerfile syntax
