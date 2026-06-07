# Docker Hub Publishing - Quick Reference

## 5-Minute Setup

### 1. Create Docker Hub Secrets

In GitHub repository **Settings → Secrets and variables → Actions**, add:

```
DOCKER_HUB_USERNAME = your_docker_username
DOCKER_HUB_TOKEN = dckr_pat_xxxxxxxxxxxxx
```

Get the token from: https://hub.docker.com/settings/security → New Access Token

### 2. Choose a Workflow

**Option A: Direct Docker (Faster, Recommended)**
```bash
cp .github/workflows/publish-docker.yml .github/workflows/
```

**Option B: Devcontainer CLI**
```bash
cp .github/workflows/publish-docker-devcontainer-cli.yml .github/workflows/
```

### 3. Push to GitHub

```bash
git add .github/workflows/
git commit -m "Add Docker Hub publishing workflow"
git push
```

### 4. Create and Push a Version Tag

```bash
# Create a version tag (v1.0.0, v1.0, etc.)
git tag v1.0.0
git push origin v1.0.0
```

Workflow **automatically triggers** on tag push!

### 5. Done! 🎉

Workflow automatically:
- ✅ Detects tag push (v1.0.0)
- ✅ Builds Docker image
- ✅ Creates for amd64 & arm64
- ✅ Pushes both tags to Docker Hub
- ✅ Shows progress in Actions tab

---

## Verify It Worked

### Check GitHub Actions
1. Go to your repo → **Actions** tab
2. Should see "Build and Publish Docker Image" running
3. Wait for it to complete (5-10 minutes)

### Check Docker Hub
1. Go to https://hub.docker.com/r/YOUR_USERNAME/jvm-devcontainer
2. Should see new tags (v1.0.0, latest)

### Test the Image
```bash
docker pull YOUR_USERNAME/jvm-devcontainer:v1.0.0
docker run -it YOUR_USERNAME/jvm-devcontainer:v1.0.0 java -version
```

---

## Workflow Comparison

| Feature | Direct Docker | Devcontainer CLI |
|---------|---------------|------------------|
| Speed | ⚡ Fast | 🔄 Slower |
| Complexity | 📄 Simple | 📋 Complex |
| Validation | ❌ None | ✅ Full |
| Setup Time | 2 min | 5 min |
| Best For | Most cases | Complex builds |

**Recommendation:** Use **Direct Docker** unless you need devcontainer-cli features.

---

## Troubleshooting

### Secrets Not Working
```bash
# Verify secrets are set
# Go to Settings → Secrets and variables
# Should see both secrets listed
```

### Build Fails
- Check GitHub Actions logs: **Actions** → Workflow → Run details
- Verify `.devcontainer/Dockerfile` exists
- Ensure Docker Hub token is valid

### Image Not Pushing
- Verify `DOCKER_HUB_USERNAME` is correct (must match Docker Hub username)
- Check Docker Hub repository exists and is public
- Confirm token has read/write/delete permissions

### Multi-arch Build Issues
- Buildx automatically handles this
- No special configuration needed
- Images for both amd64 and arm64 are built

---

## Release Process

```bash
# 1. Make changes and commit
git add .
git commit -m "Your changes"

# 2. Push a version tag (e.g., v1.0.0, v1.0.1)
git tag v1.0.0
git push origin v1.0.0

# 3. GitHub Actions automatically:
#    - Triggers on tag push
#    - Builds Dockerfile for amd64 and arm64
#    - Pushes to Docker Hub with tags:
#      - your_username/jvm-devcontainer:1.0.0
#      - your_username/jvm-devcontainer:latest
#    - Monitor in Actions tab

# Done! Your image is published.
```

**Supported tag patterns:**
- `v1.0.0` ✅
- `v2.1` ✅
- `v1.0.0-beta` ❌ (requires pattern modification)
- `1.0.0` ❌ (requires pattern modification)

---

## Docker Image Tags

After each release, your image will have:

```bash
# Specific version (use for production)
docker pull your_username/jvm-devcontainer:1.0.0
docker pull your_username/jvm-devcontainer:1.0.1

# Latest (for development)
docker pull your_username/jvm-devcontainer:latest
```

---

## What's In The Image

✅ Java 21 LTS  
✅ Maven 3.9.6  
✅ Gradle 8.5  
✅ SBT 1.9.7  
✅ Kotlin 1.9.21  
✅ Git & GitHub CLI  

---

## Manual Trigger (Without Release)

If you want to publish without creating a release:

1. Go to **Actions** tab
2. Select "Build and Publish Docker Image"
3. Click **Run workflow**
4. Enter tag (e.g., `1.0.0`)
5. Click **Run workflow**

---

## Common Commands

```bash
# Pull the latest version
docker pull your_username/jvm-devcontainer

# Run interactively
docker run -it your_username/jvm-devcontainer /bin/bash

# Mount your code and work
docker run -it -v $(pwd):/workspace your_username/jvm-devcontainer

# Check what's installed
docker run your_username/jvm-devcontainer java -version
docker run your_username/jvm-devcontainer mvn --version
docker run your_username/jvm-devcontainer gradle --version
```

---

## Docker Hub URL

After first push, your repository will be at:

```
https://hub.docker.com/r/YOUR_USERNAME/jvm-devcontainer
```

Share this URL to let others use your image!

---

## Next Release

For future releases, just follow this pattern:

```bash
# Make changes
git add .
git commit -m "Feature X"

# Create release tag
git tag v1.0.1
git push origin v1.0.1

# Workflow does the rest automatically!
```

No need to manually build, push, or update anything. 🤖

---

## Support

See `DOCKER_HUB_SETUP.md` for detailed documentation and troubleshooting.
