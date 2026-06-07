# Tag-Based Docker Publishing Workflow

Complete guide for the automatic Docker Hub publishing workflow that triggers on git tag push.

## How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                    Developer Workflow                        │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  1. Make code changes                                         │
│     git add .                                                 │
│     git commit -m "Your changes"                              │
│                                                               │
│  2. Push a version tag                                        │
│     git tag v1.0.0                                            │
│     git push origin v1.0.0                                    │
│                    │                                          │
│                    ▼                                          │
│     ┌─────────────────────────────────────┐                  │
│     │   GitHub Detects Tag Push           │                  │
│     └────────────┬────────────────────────┘                  │
│                  │                                            │
│                  ▼                                            │
│     ┌─────────────────────────────────────┐                  │
│     │  Workflow Triggered                 │                  │
│     │  - Extracts version: 1.0.0          │                  │
│     │  - Builds for amd64                 │                  │
│     │  - Builds for arm64                 │                  │
│     │  - Pushes to Docker Hub             │                  │
│     └────────────┬────────────────────────┘                  │
│                  │                                            │
│                  ▼                                            │
│     ┌─────────────────────────────────────┐                  │
│     │  Image Published                    │                  │
│     │  myuser/jvm-devcontainer:1.0.0      │                  │
│     │  myuser/jvm-devcontainer:latest     │                  │
│     └─────────────────────────────────────┘                  │
│                                                               │
│  3. Monitor progress in Actions tab                           │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

## Quick Start

### Step 1: Push a Tag

```bash
# Create a local tag
git tag v1.0.0

# Push the tag to GitHub
git push origin v1.0.0
```

### Step 2: Watch It Build

Go to your repository **Actions** tab and watch the workflow run:
- ✅ Checkout code
- ✅ Login to Docker Hub
- ✅ Build for amd64
- ✅ Build for arm64
- ✅ Push images
- ✅ Create manifests

### Step 3: Verify on Docker Hub

Visit your Docker Hub repository:
```
https://hub.docker.com/r/YOUR_USERNAME/jvm-devcontainer
```

Should see new tags:
- `1.0.0` ← Version tag
- `latest` ← Updated to latest

## Tag Format

The workflow matches these tag patterns:

### Supported Formats

```bash
git tag v1.0.0      # ✅ Matches v*.*.*
git tag v1.0        # ✅ Matches v*.*
git tag v2.3.4      # ✅ Matches v*.*.*
```

### Not Supported (By Default)

```bash
git tag 1.0.0       # ❌ No 'v' prefix
git tag v1.0.0-rc1  # ❌ Pre-release suffix
git tag release/1.0 # ❌ Different pattern
```

### Customize Tag Pattern

To support other patterns, edit `.github/workflows/publish-docker.yml`:

```yaml
on:
  push:
    tags:
      - 'v*.*.*'      # Current
      - 'v*.*'        # Current
      - 'release-*'   # Add new pattern
      - '*'           # OR match any tag
```

## Workflow Triggers

### 1. Tag Push (Primary)

```bash
git push origin v1.0.0
```

Automatically triggers workflow immediately.

### 2. Manual Dispatch (Fallback)

If you want to publish without a tag:

1. Go to **Actions** tab
2. Select "Build and Publish Docker Image"
3. Click **"Run workflow"**
4. Enter tag: `1.0.0`
5. Click **"Run workflow"**

## Working with Tags

### Create a Tag

```bash
# Lightweight tag (simple)
git tag v1.0.0

# Annotated tag (with message)
git tag -a v1.0.0 -m "Release version 1.0.0"

# Tag from specific commit
git tag v1.0.0 abc123def
```

### Push Tags

```bash
# Push single tag
git push origin v1.0.0

# Push all tags
git push origin --tags

# Push all commits and tags
git push origin main --follow-tags
```

### View Tags

```bash
# List all tags
git tag

# List tags matching pattern
git tag -l "v*"

# Show tag details
git show v1.0.0
```

### Delete Tags

```bash
# Delete local tag
git tag -d v1.0.0

# Delete remote tag
git push origin --delete v1.0.0
```

## Release Process

### Method 1: Simple Tag Push

```bash
# 1. Update version in files (optional)
# pom.xml, build.gradle, etc.

# 2. Commit changes
git add .
git commit -m "Bump version to 1.0.0"

# 3. Create and push tag
git tag v1.0.0
git push origin main
git push origin v1.0.0

# Done! Workflow runs automatically
```

### Method 2: Create Release After

```bash
# 1. Push tag (workflow builds image)
git tag v1.0.0
git push origin v1.0.0

# 2. Create release on GitHub (optional)
# Go to Releases → New release → Select tag v1.0.0
# Add release notes → Publish
```

### Method 3: Batch Tags

```bash
# Push multiple commits with different tags
for version in 1.0.0 1.0.1 1.1.0; do
  git tag v$version
done

git push origin --tags
```

## Monitoring Builds

### View Workflow Status

1. Go to **Actions** tab
2. Select workflow run
3. Click on job to expand
4. View step-by-step logs

### Example Output

```
[INFO] Repository: v1.0.0
[INFO] Checking prerequisites...
[SUCCESS] All prerequisites met
[INFO] Building Docker image...
[INFO] Pushing to Docker Hub...
✅ Docker image built and published successfully!

📋 Image Details:
  Registry: docker.io
  Image: username/jvm-devcontainer
  Version Tag: docker.io/username/jvm-devcontainer:1.0.0
  Latest Tag: docker.io/username/jvm-devcontainer:latest
  Platforms: linux/amd64, linux/arm64

🐳 Pull commands:
  docker pull docker.io/username/jvm-devcontainer:1.0.0
  docker pull docker.io/username/jvm-devcontainer:latest
```

## Troubleshooting

### Workflow Didn't Trigger

**Problem:** Pushed a tag but workflow didn't start.

**Solutions:**
```bash
# 1. Check tag format matches pattern (v*.*.* or v*.*)
git tag -l

# 2. Ensure you pushed the tag
git push origin v1.0.0

# 3. Check Actions tab for any recent runs
# Go to Actions → All workflows

# 4. If still not triggered, use manual dispatch:
# Actions → Build and Publish Docker Image → Run workflow
```

### Build Failed

**Problem:** Workflow started but build failed.

**Solutions:**
1. Click on the failed workflow run
2. View the logs to find error
3. Common issues:
   - `.devcontainer/Dockerfile` not found
   - Docker Hub credentials incorrect
   - Network issues (retry)

### Image Not on Docker Hub

**Problem:** Build succeeded but image not visible.

**Solutions:**
```bash
# 1. Check repository is public
# Docker Hub → Repository settings → Visibility

# 2. Check correct username
docker pull username/jvm-devcontainer:1.0.0

# 3. Check tags were created
# Docker Hub → Repository → Tags tab
```

## Advanced Usage

### Automatic Version Tagging

Create a script to automate tagging:

```bash
#!/bin/bash
# auto-release.sh

VERSION="${1:-1.0.0}"

git tag -a "v${VERSION}" -m "Release ${VERSION}"
git push origin main
git push origin "v${VERSION}"

echo "✅ Released v${VERSION}"
```

Usage:
```bash
./auto-release.sh 1.0.0
```

### Multi-Version Support

Tag the same commit multiple times:

```bash
git tag v1.0
git tag v1.0.0
git tag latest-stable

git push origin --tags
```

Each tag triggers a separate workflow build.

### Scheduled Releases

Use GitHub Actions schedule to rebuild periodically:

```yaml
on:
  schedule:
    - cron: '0 0 * * 0'  # Weekly Sunday
```

## Integration with CI/CD

### Before Release

```bash
# 1. Run tests
npm test

# 2. Build project
mvn clean install

# 3. Only tag if all passes
git tag v1.0.0
git push origin v1.0.0
```

### Automation

Create a release script:

```bash
#!/bin/bash
set -e

echo "Running tests..."
mvn test

echo "Building..."
mvn clean install

echo "Creating release..."
VERSION=$1
git tag "v${VERSION}"
git push origin main
git push origin "v${VERSION}"

echo "✅ Released v${VERSION}"
```

## Best Practices

1. **Use Semantic Versioning**
   ```bash
   git tag v1.0.0    # Major.Minor.Patch
   git tag v2.1      # Short form also works
   ```

2. **Use Annotated Tags for Releases**
   ```bash
   git tag -a v1.0.0 -m "Release 1.0.0"
   ```

3. **Keep Latest Updated**
   - Latest tag automatically updates
   - Always points to newest release

4. **Push Commits Before Tags**
   ```bash
   git push origin main
   git push origin v1.0.0
   ```

5. **Document Releases**
   - Create GitHub Release with notes
   - Link to Docker Hub image
   - List breaking changes

## Summary

| Task | Command |
|------|---------|
| Create tag | `git tag v1.0.0` |
| Push tag | `git push origin v1.0.0` |
| Push all tags | `git push origin --tags` |
| View tags | `git tag` |
| Delete tag | `git tag -d v1.0.0` |
| Monitor build | GitHub Actions tab |
| Test image | `docker pull user/image:1.0.0` |

That's it! Just push tags and let GitHub Actions handle the rest. 🚀
