#!/bin/bash

##############################################################################
# JVM Dev Container Setup Script
# 
# This script clones a GitHub repository and adds a complete JVM dev 
# container configuration to it.
#
# Usage:
#   ./setup-jvm-devcontainer.sh <github-repo>
#   ./setup-jvm-devcontainer.sh owner/repo
#   ./setup-jvm-devcontainer.sh https://github.com/owner/repo
#   ./setup-jvm-devcontainer.sh https://github.com/owner/repo.git
#
##############################################################################

set -euo pipefail

# Color output for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

warning() {
    echo -e "${YELLOW}[WARN]${NC} $1
}

# Print usage information
usage() {
    cat << EOF
${BLUE}JVM Dev Container Setup${NC}

${YELLOW}Usage:${NC}
  $0 <github-repo>

${YELLOW}Examples:${NC}
  $0 owner/repo
  $0 https://github.com/owner/repo
  $0 https://github.com/owner/repo.git

${YELLOW}Arguments:${NC}
  github-repo    GitHub repository reference (required)
                 - Can be "owner/repo" format
                 - Can be full GitHub URL
                 - Can include .git extension

${YELLOW}Options:${NC}
  -h, --help     Show this help message
  -d, --dir      Specify output directory (defaults to repo name)

${YELLOW}What this script does:${NC}
  1. Validates the GitHub repository reference
  2. Clones the repository locally
  3. Creates .devcontainer directory
  4. Copies Dockerfile and devcontainer.json
  5. Copies .gitignore
  6. Displays next steps

EOF
}

# Parse command line arguments
parse_args() {
    if [[ $# -eq 0 ]]; then
        usage
        exit 1
    fi

    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -d|--dir)
                CUSTOM_DIR="$2"
                shift 2
                ;;
            *)
                REPO_REF="$1"
                shift
                ;;
        esac
    done

    if [[ -z "${REPO_REF:-}" ]]; then
        error "GitHub repository reference is required"
    fi
}

# Convert GitHub reference to clone URL
parse_repo_url() {
    local ref="$1"
    
    # If it's already a full URL, use it as-is
    if [[ "$ref" == https://* ]] || [[ "$ref" == git@* ]]; then
        echo "$ref"
        return
    fi
    
    # If it's owner/repo format, convert to HTTPS URL
    if [[ "$ref" == */* ]]; then
        echo "https://github.com/${ref}.git"
        return
    fi
    
    error "Invalid GitHub repository reference: $ref"
}

# Extract repo name from URL
extract_repo_name() {
    local url="$1"
    # Remove .git suffix if present
    local name="${url##*/}"
    name="${name%.git}"
    echo "$name"
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Validate prerequisites
validate_prerequisites() {
    log "Checking prerequisites..."
    
    if ! command_exists git; then
        error "git is not installed. Please install git and try again."
    fi
    
    if ! command_exists cp; then
        error "cp command not found"
    fi
    
    success "All prerequisites met"
}

# Clone the repository
clone_repo() {
    local url="$1"
    local target_dir="$2"
    
    log "Cloning repository: $url"
    
    if [[ -d "$target_dir" ]]; then
        error "Directory '$target_dir' already exists. Please remove it or choose a different name."
    fi
    
    if ! git clone "$url" "$target_dir"; then
        error "Failed to clone repository: $url"
    fi
    
    success "Repository cloned successfully"
}

# Copy devcontainer files
copy_devcontainer_files() {
    local target_dir="$1"
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.devcontainer" 2>/dev/null && pwd || echo ".")"
    
    log "Copying dev container configuration..."
    
    # Create .devcontainer directory
    mkdir -p "$target_dir/.devcontainer"
    
    # Copy Dockerfile
    if [[ -f "$script_dir/Dockerfile" ]]; then
        cp "$script_dir/Dockerfile" "$target_dir/.devcontainer/Dockerfile"
        success "Copied Dockerfile"
    else
        warning "Dockerfile not found at $script_dir/Dockerfile"
    fi
    
    # Copy devcontainer.json
    if [[ -f "$script_dir/devcontainer.json" ]]; then
        cp "$script_dir/devcontainer.json" "$target_dir/.devcontainer/devcontainer.json"
        success "Copied devcontainer.json"
    else
        warning "devcontainer.json not found at $script_dir/devcontainer.json"
    fi
}

# Copy .gitignore if it doesn't exist
copy_gitignore() {
    local target_dir="$1"
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    if [[ ! -f "$target_dir/.gitignore" ]]; then
        if [[ -f "$script_dir/.gitignore" ]]; then
            cp "$script_dir/.gitignore" "$target_dir/.gitignore"
            success "Copied .gitignore"
        fi
    else
        log ".gitignore already exists, skipping"
    fi
}

# Initialize git and add files
setup_git() {
    local target_dir="$1"
    
    log "Setting up git..."
    
    cd "$target_dir"
    
    # Check if devcontainer files exist
    if [[ -d ".devcontainer" ]]; then
        if git status .devcontainer &>/dev/null; then
            git add .devcontainer/
            if [[ -f ".gitignore" ]]; then
                git add .gitignore
            fi
            success "Staged devcontainer files for commit"
        fi
    fi
}

# Print next steps
print_next_steps() {
    local target_dir="$1"
    
    cat << EOF

${GREEN}✓ Dev container setup complete!${NC}

${YELLOW}Next steps:${NC}

1. ${BLUE}Navigate to the repository:${NC}
   cd $target_dir

2. ${BLUE}Review the changes:${NC}
   git status
   git diff .devcontainer/

3. ${BLUE}Open in VS Code:${NC}
   code .

4. ${BLUE}Reopen in dev container:${NC}
   - Press Ctrl+Shift+P (Cmd+Shift+P on Mac)
   - Select "Dev Containers: Reopen in Container"

5. ${BLUE}(Optional) Commit the changes:${NC}
   git commit -m "Add JVM dev container configuration"
   git push

${YELLOW}Files added:${NC}
  .devcontainer/Dockerfile
  .devcontainer/devcontainer.json
  .gitignore (if not present)

${YELLOW}Supported languages/frameworks:${NC}
  • Java (Maven, Gradle)
  • Kotlin
  • Scala (SBT)
  • Any JVM language

${YELLOW}Resources:${NC}
  • Dev Container docs: https://code.visualstudio.com/docs/remote/containers
  • VS Code Remote Dev: https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers

EOF
}

##############################################################################
# Main script execution
##############################################################################

main() {
    # Parse arguments
    parse_args "$@"
    
    # Validate prerequisites
    validate_prerequisites
    
    # Get clone URL and repo name
    CLONE_URL=$(parse_repo_url "$REPO_REF")
    REPO_NAME=$(extract_repo_name "$CLONE_URL")
    TARGET_DIR="${CUSTOM_DIR:-$REPO_NAME}"
    
    log "Repository: $REPO_NAME"
    log "Target directory: $TARGET_DIR"
    
    # Clone the repository
    clone_repo "$CLONE_URL" "$TARGET_DIR"
    
    # Copy devcontainer files
    copy_devcontainer_files "$TARGET_DIR"
    copy_gitignore "$TARGET_DIR"
    
    # Setup git
    setup_git "$TARGET_DIR"
    
    # Print next steps
    print_next_steps "$TARGET_DIR"
}

# Run main function
main "$@"
