# Dependabot Configuration Guide

Complete guide for automating dependency updates with GitHub Dependabot.

## Overview

Dependabot automatically creates pull requests to update dependencies when new versions are available. This keeps your project secure and up-to-date.

## Configuration File

**Location:** `.github/dependabot.yml`

**Purpose:** Tells Dependabot which package managers to check and how often.

## Supported Package Ecosystems

For this JVM dev container project:

| Ecosystem | File Types | Best For |
|-----------|-----------|----------|
| `maven` | `pom.xml` | Java projects using Maven |
| `gradle` | `build.gradle`, `build.gradle.kts` | Java/Kotlin projects using Gradle |
| `docker` | `Dockerfile` | Updating base images |
| `github-actions` | `.github/workflows/*.yml` | GitHub Actions versions |
| `npm` | `package.json` | Node.js dependencies |
| `pip` | `requirements.txt`, `pyproject.toml` | Python dependencies |

## Configuration Structure

```yaml
version: 2
updates:
  - package-ecosystem: "maven"      # Which package manager
    directory: "/"                  # Where to look for manifests
    schedule:
      interval: "weekly"            # How often to check
      day: "monday"                 # Which day
      time: "03:00"                 # What time (UTC)
    # Additional options...
```

## Configuration Options Explained

### Package Ecosystem

```yaml
package-ecosystem: "maven"
```

Choose based on your project:
- `maven` - Maven Central Repository
- `gradle` - Gradle plugins and dependencies
- `docker` - Docker Hub base images
- `github-actions` - GitHub Actions actions
- `npm` - npm registry
- `pip` - PyPI registry

### Directory

```yaml
directory: "/"                  # Root of repository
directory: "/backend"           # Specific subdirectory
directory: ".devcontainer"      # For Dockerfile in .devcontainer
```

Points Dependabot to where your package manifest files are located.

### Schedule

```yaml
schedule:
  interval: "weekly"            # weekly, daily, monthly
  day: "monday"                 # monday, tuesday, etc.
  time: "03:00"                 # UTC time in 24-hour format
```

**Common Intervals:**
- `daily` - Check every day
- `weekly` - Check once per week (recommended)
- `monthly` - Check once per month (good for stable projects)

**Example Times (UTC):**
- `"03:00"` - 3 AM UTC
- `"09:00"` - 9 AM UTC
- `"15:00"` - 3 PM UTC

### Open Pull Requests Limit

```yaml
open-pull-requests-limit: 5
```

Maximum number of open dependency update PRs at once. Prevents overwhelming your project with too many PRs.

**Recommendations:**
- `3-5` for active projects
- `1-2` for stable/maintenance projects

### Reviewers & Assignees

```yaml
reviewers:
  - "michaeldisalvo"
  - "maintainer-team"

assignees:
  - "michaeldisalvo"
```

Automatically assign/request review from specific users.

### Labels

```yaml
labels:
  - "dependencies"
  - "maven"
  - "automated"
```

Tags PRs for easy filtering and organization.

### Commit Message

```yaml
commit-message:
  prefix: "build(deps):"
  prefix-development: "build(deps-dev):"
  include: "scope"
```

Customizes commit message format.

**Examples:**
- `build(deps): bump maven from 3.8.1 to 3.9.0`
- `build(deps-dev): bump junit from 4.13 to 5.0`

### Rebase Strategy

```yaml
rebase-strategy: "auto"
```

**Options:**
- `auto` - Rebase if there are conflicts
- `disabled` - Don't rebase
- `no-permissions-disable-rebase` - Rebase only if permissions allow

### Allow

```yaml
allow:
  - dependency-type: "all"
```

Control which dependencies to update.

**Options:**
- `dependency-type: "all"` - Update all dependencies
- `dependency-type: "direct"` - Only direct dependencies
- `dependency-type: "indirect"` - Only transitive dependencies
- `dependency-type: "production"` - Only production dependencies
- `dependency-type: "development"` - Only dev dependencies

## Full Example Configuration

```yaml
version: 2
updates:
  # Maven dependencies
  - package-ecosystem: "maven"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
      time: "03:00"
    open-pull-requests-limit: 5
    reviewers:
      - "michaeldisalvo"
    labels:
      - "dependencies"
      - "maven"
    commit-message:
      prefix: "build(deps):"
      include: "scope"

  # Gradle dependencies
  - package-ecosystem: "gradle"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
      time: "03:30"
    open-pull-requests-limit: 5
    reviewers:
      - "michaeldisalvo"
    labels:
      - "dependencies"
      - "gradle"

  # Docker base images
  - package-ecosystem: "docker"
    directory: ".devcontainer"
    schedule:
      interval: "weekly"
      day: "tuesday"
      time: "04:00"
    open-pull-requests-limit: 3
    reviewers:
      - "michaeldisalvo"
    labels:
      - "dependencies"
      - "docker"
      - "security"

  # GitHub Actions
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "wednesday"
      time: "04:30"
    open-pull-requests-limit: 5
    reviewers:
      - "michaeldisalvo"
    labels:
      - "dependencies"
      - "ci"
```

## Setup Instructions

### Step 1: Create the Configuration File

Copy the provided `dependabot.yml` to your repository:

```bash
cp .github/dependabot.yml your-repo/.github/
```

### Step 2: Customize for Your Project

Edit `.github/dependabot.yml`:

```bash
# Update the reviewer username
sed -i 's/michaeldisalvo/YOUR_USERNAME/g' .github/dependabot.yml

# Or edit manually with your editor
code .github/dependabot.yml
```

### Step 3: Commit and Push

```bash
git add .github/dependabot.yml
git commit -m "Add Dependabot configuration"
git push
```

### Step 4: Enable Dependabot

Go to your GitHub repository:

1. **Settings** → **Code security and analysis**
2. Find **Dependabot alerts** - Click **Enable**
3. Find **Dependabot security updates** - Click **Enable**
4. Find **Dependabot version updates** - Should auto-enable with config

## Dependency Update Intervals

### Recommended Schedule

**For Active Development Projects:**
```yaml
schedule:
  interval: "weekly"
  day: "monday"
  time: "02:00"
```

**For Stable/Production Projects:**
```yaml
schedule:
  interval: "monthly"
```

**For Security-Critical Projects:**
```yaml
schedule:
  interval: "daily"
```

## Best Practices

### 1. **Stagger Update Times**

Don't run all ecosystems at once:

```yaml
updates:
  - package-ecosystem: "maven"
    schedule:
      time: "03:00"    # First

  - package-ecosystem: "gradle"
    schedule:
      time: "03:30"    # 30 min later

  - package-ecosystem: "docker"
    schedule:
      time: "04:00"    # Another 30 min

  - package-ecosystem: "github-actions"
    schedule:
      time: "04:30"    # Last
```

Benefits:
- Spreads load on CI/CD
- Easier to review PRs
- Prevents CI resource exhaustion

### 2. **Limit Open PRs**

```yaml
open-pull-requests-limit: 5
```

Prevents overwhelming your team with updates.

### 3. **Use Labels for Filtering**

```yaml
labels:
  - "dependencies"
  - "maven"
  - "security"
```

Then filter PRs in GitHub:

```
is:pr label:dependencies label:security
```

### 4. **Separate Development Dependencies**

```yaml
commit-message:
  prefix: "build(deps):"            # Production
  prefix-development: "build(deps-dev):"  # Dev only
```

### 5. **Auto-Merge Minor/Patch Updates**

Consider creating rules to auto-merge safe updates:

1. **Settings** → **Merge Automation** (if enabled)
2. Set rules for:
   - Patch version updates (e.g., 1.0.0 → 1.0.1)
   - Only from Dependabot
   - Requires approval still recommended

## Monitoring Updates

### View Update History

1. Go to **Insights** → **Dependency graph** → **Dependabot**
2. See all recent updates and their status

### Create Custom Alerts

Check `Settings → Code security and analysis` for:
- ✅ Dependabot alerts (security vulnerabilities)
- ✅ Dependabot security updates
- ✅ Dependabot version updates

### GitHub Notifications

You'll get notified when:
- New PRs are created
- PRs are ready to merge
- Conflicts occur

## Advanced Configuration

### Skip Certain Versions

```yaml
ignore:
  - dependency-name: "log4j"
    versions: ["1.*", "2.0-2.16"]
```

### Allow Only Major Updates

```yaml
versioning-strategy: "increment-major-only"
```

### Require Approval Before PR

```yaml
# This is automatic - Dependabot PRs require review
```

## Troubleshooting

### Dependabot Not Creating PRs

1. Check that `.github/dependabot.yml` exists
2. Check for YAML syntax errors: use a YAML validator
3. Verify package ecosystem matches your files:
   - `maven` → has `pom.xml`?
   - `gradle` → has `build.gradle`?
   - `docker` → has `Dockerfile`?
4. Check **Insights → Dependency graph** for errors

### PRs Not Being Created on Schedule

1. Verify schedule time is UTC, not local time
2. Check GitHub Actions/CI status
3. Ensure no merge conflicts blocking updates

### Too Many PRs

Reduce `open-pull-requests-limit`:

```yaml
open-pull-requests-limit: 2  # Was 5
```

Or increase interval to `"monthly"`

## Example PRs

Dependabot creates PRs like:

```
Title: build(deps): bump maven-core from 3.8.1 to 3.9.6

Body:
Bumps maven-core from 3.8.1 to 3.9.6
- Release notes
- Commits
- Dependency graph comparison
```

These are automatically labeled and can be:
- Reviewed and merged
- Auto-merged if rules allow
- Closed if not needed

## Security Considerations

### Enable Security Updates

Go to **Settings → Code security and analysis**:
- ✅ Enable **Dependabot alerts**
- ✅ Enable **Dependabot security updates**

This makes Dependabot create emergency PRs for security vulnerabilities.

### Separate Security Updates

Consider running security updates more frequently:

```yaml
updates:
  # Regular updates (weekly)
  - package-ecosystem: "maven"
    schedule:
      interval: "weekly"

  # Could add another entry for daily security checks
  # (or set more frequently)
```

## Cost

✅ **Dependabot is free** on public repositories

## Next Steps

1. ✅ Create `.github/dependabot.yml`
2. ✅ Customize for your project
3. ✅ Commit and push
4. ✅ Monitor **Insights → Dependency graph**
5. ✅ Review and merge PRs as they arrive

## Resources

- [GitHub Dependabot Docs](https://docs.github.com/en/code-security/dependabot)
- [Dependabot Configuration Reference](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-dependency-updates)
- [Best Practices](https://docs.github.com/en/code-security/dependabot/working-with-dependabot)
