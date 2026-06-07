# Dependabot Configuration Quick Reference

## File Location
```
.github/dependabot.yml
```

## Basic Structure

```yaml
version: 2
updates:
  - package-ecosystem: "maven"
    directory: "/"
    schedule:
      interval: "weekly"
```

## Package Ecosystems

```
maven              Java/Maven projects
gradle             Java/Kotlin with Gradle
docker             Dockerfile base images
github-actions     GitHub Actions workflows
npm                Node.js/npm packages
pip                Python packages
composer           PHP packages
cargo              Rust packages
nuget              .NET packages
```

## Schedule Intervals

```yaml
# Check daily
interval: "daily"

# Check once a week on Monday
interval: "weekly"
day: "monday"

# Check once a month
interval: "monthly"
```

## UTC Times

```yaml
time: "00:00"  # Midnight
time: "03:00"  # 3 AM
time: "09:00"  # 9 AM
time: "15:00"  # 3 PM
time: "21:00"  # 9 PM
```

## Common Options

```yaml
open-pull-requests-limit: 5      # Max open PRs
reviewers:
  - "username"                   # Auto-request review
assignees:
  - "username"                   # Auto-assign
labels:
  - "dependencies"               # Add labels
  - "automated"
```

## Commit Message

```yaml
commit-message:
  prefix: "build(deps):"         # Prefix for commits
  include: "scope"               # Include package scope
```

## Allow Updates

```yaml
allow:
  - dependency-type: "all"       # All dependencies
  - dependency-type: "direct"    # Only direct
  - dependency-type: "indirect"  # Only transitive
```

## Complete Example

```yaml
version: 2
updates:
  - package-ecosystem: "maven"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
      time: "03:00"
    open-pull-requests-limit: 5
    reviewers:
      - "your-username"
    labels:
      - "dependencies"
      - "maven"
    commit-message:
      prefix: "build(deps):"
```

## Multiple Ecosystems

```yaml
version: 2
updates:
  - package-ecosystem: "maven"
    directory: "/"
    schedule:
      interval: "weekly"
      time: "03:00"

  - package-ecosystem: "docker"
    directory: ".devcontainer"
    schedule:
      interval: "weekly"
      time: "04:00"

  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
      time: "04:30"
```

## Stagger Schedules

Avoid running all at same time:

```yaml
updates:
  # 3:00 AM
  - package-ecosystem: "maven"
    schedule:
      interval: "weekly"
      time: "03:00"

  # 3:30 AM (30 min later)
  - package-ecosystem: "gradle"
    schedule:
      interval: "weekly"
      time: "03:30"

  # 4:00 AM
  - package-ecosystem: "docker"
    schedule:
      interval: "weekly"
      time: "04:00"

  # 4:30 AM
  - package-ecosystem: "github-actions"
    schedule:
      interval: "weekly"
      time: "04:30"
```

## Setup Steps

1. Create `.github/dependabot.yml`
2. Add configuration
3. Commit: `git add .github/dependabot.yml`
4. Push: `git push`
5. Enable in **Settings → Code security**
6. Monitor **Insights → Dependency graph**

## Check Configuration

Use GitHub's built-in validator:
- Go to **Settings → Code security and analysis**
- Look for any error messages
- Fix and re-push

Or use online YAML validator to check syntax.

## See Updates

1. Go to **Insights** tab
2. Click **Dependency graph**
3. Click **Dependabot**
4. View all updates

## All Available Options

```yaml
version: 2
updates:
  - package-ecosystem: "maven"
    directory: "/"
    
    # Schedule
    schedule:
      interval: "weekly"
      day: "monday"
      time: "03:00"
      timezone: "Europe/London"
    
    # PR limits
    open-pull-requests-limit: 5
    pull-request-branch-name:
      separator: "/"
    
    # Auto review/assign
    reviewers:
      - "username"
    assignees:
      - "username"
    
    # Labels & messaging
    labels:
      - "dependencies"
    commit-message:
      prefix: "build(deps):"
      prefix-development: "build(deps-dev):"
      include: "scope"
    
    # Rebase strategy
    rebase-strategy: "auto"
    
    # Dependencies to update
    allow:
      - dependency-type: "all"
    
    # Ignore versions
    ignore:
      - dependency-name: "example"
        versions: ["1.0", "2.0"]
```

## Common Configurations

### Minimal

```yaml
version: 2
updates:
  - package-ecosystem: "maven"
    directory: "/"
    schedule:
      interval: "weekly"
```

### Full JVM Project

```yaml
version: 2
updates:
  - package-ecosystem: "maven"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
      time: "03:00"
    labels: ["dependencies"]

  - package-ecosystem: "gradle"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
      time: "03:30"
    labels: ["dependencies"]

  - package-ecosystem: "docker"
    directory: ".devcontainer"
    schedule:
      interval: "weekly"
      day: "monday"
      time: "04:00"
    labels: ["dependencies", "docker"]

  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
      time: "04:30"
    labels: ["dependencies", "ci"]
```

### Active Development

```yaml
version: 2
updates:
  - package-ecosystem: "maven"
    directory: "/"
    schedule:
      interval: "daily"
    open-pull-requests-limit: 10
    reviewers:
      - "dev-team"
```

### Stable/Production

```yaml
version: 2
updates:
  - package-ecosystem: "maven"
    directory: "/"
    schedule:
      interval: "monthly"
    open-pull-requests-limit: 2
    reviewers:
      - "maintainer"
```

## Helpful Links

- [Dependabot Docs](https://docs.github.com/en/code-security/dependabot)
- [Configuration Reference](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-dependency-updates)
- [Supported Ecosystems](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/about-dependabot-version-updates)

## Troubleshooting

**PRs not being created?**
- Check file exists: `.github/dependabot.yml`
- Verify YAML syntax (no tabs, proper indentation)
- Confirm manifest files exist (`pom.xml`, `Dockerfile`, etc.)
- Check **Settings → Code security** is enabled

**Too many PRs?**
- Reduce `open-pull-requests-limit`
- Change `interval` to `"monthly"`

**Wrong times?**
- Times are in UTC, not your local timezone
- Use `timezone` option if needed

That's it! Dependabot handles the rest. 🤖
