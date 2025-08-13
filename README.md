# fwdslsh/toolkit

Universal installer and centralized workflows for all fwdslsh CLI tools.

## Overview

This repository provides the essential infrastructure for the fwdslsh CLI ecosystem:

1. **Universal Installer**: A single script that can install any fwdslsh CLI tool with platform detection and version management
2. **Centralized Workflows**: Reusable GitHub Actions workflows for consistent release automation across all projects
3. **Docker Toolkit**: A unified Docker container with all fwdslsh CLI tools pre-installed for development and CI/CD

By centralizing these resources, we maintain consistency, reduce maintenance overhead, and provide a professional user experience.

## Contents

### 📦 Centralized Workflows (`.github/workflows/`)

Reusable GitHub Actions workflows that can be called from any fwdslsh repository:

- **`build-binaries.yml`** - Cross-platform binary builder for Bun projects
- **`create-release.yml`** - GitHub release creator with checksums and release notes
- **`publish.docker.yml`** - Docker Hub multi-platform image publisher
- **`publish.npm.yml`** - NPM package publisher
- **`bun-test.yml`** - Bun test runner for CI/CD

### 🛠️ Universal Installer (`install.sh`)

A single installation script that can install any fwdslsh CLI tool:

```bash
# Quick install any tool
curl -fsSL https://raw.githubusercontent.com/fwdslsh/toolkit/main/install.sh | bash -s catalog
curl -fsSL https://raw.githubusercontent.com/fwdslsh/toolkit/main/install.sh | bash -s unify
curl -fsSL https://raw.githubusercontent.com/fwdslsh/toolkit/main/install.sh | bash -s inform
```

Features:

- Multi-tool support (catalog, inform, unify, giv)
- Automatic platform detection
- Version management
- PATH configuration assistance
- Dry-run mode for testing

### 🐳 Docker Toolkit (`Dockerfile`)

A unified Docker container with all fwdslsh CLI tools pre-installed:

```bash
# Run the toolkit container
docker run --rm -v $(pwd):/workspace fwdslsh/toolkit:latest

# Use specific tools
docker run --rm -v $(pwd):/workspace fwdslsh/toolkit:latest catalog --input docs --output build
docker run --rm -v $(pwd):/workspace fwdslsh/toolkit:latest unify build --source src --output dist
docker run --rm -v $(pwd):/workspace fwdslsh/toolkit:latest inform https://docs.example.com --output-dir content
```

Perfect for CI/CD pipelines and development environments where you need multiple tools.

## Usage

### For Repository Maintainers

To use centralized workflows in your fwdslsh CLI project:

1. **Create minimal workflow files** in your repository:

```yaml
# .github/workflows/release.yml
name: Release

on:
  push:
    tags:
      - "v*"

permissions:
  contents: write
  packages: write

jobs:
  build:
    uses: fwdslsh/toolkit/.github/workflows/build-binaries.yml@main
    with:
      upload-artifacts: true

  release:
    needs: build
    uses: fwdslsh/toolkit/.github/workflows/create-release.yml@main
    with:
      tag: ${{ github.ref_name }}
    secrets: inherit

  docker:
    needs: [build, release]
    uses: fwdslsh/toolkit/.github/workflows/publish.docker.yml@main
    with:
      tag: ${{ github.ref_name }}
    secrets: inherit
```

```yaml
# .github/workflows/test.yml
name: Run Tests

on: [push, pull_request]

jobs:
  run-tests:
    uses: fwdslsh/toolkit/.github/workflows/bun-test.yml@main
```

2. **Configure repository secrets**:
   - `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` for Docker publishing
   - `NPM_TOKEN` for NPM publishing

### For End Users

Install any fwdslsh CLI tool using the universal installer:

```bash
# List available tools
curl -fsSL https://raw.githubusercontent.com/fwdslsh/toolkit/main/install.sh | bash -s -- --list

# Install specific tool
curl -fsSL https://raw.githubusercontent.com/fwdslsh/toolkit/main/install.sh | bash -s unify

# Install specific version
curl -fsSL https://raw.githubusercontent.com/fwdslsh/toolkit/main/install.sh | bash -s catalog -- --version v0.0.7
```

## Supported Projects

Projects currently using these centralized workflows:

| Project                                       | Description                     | Status    |
| --------------------------------------------- | ------------------------------- | --------- |
| [catalog](https://github.com/fwdslsh/catalog) | Documentation catalog generator | ✅ Active |
| [inform](https://github.com/fwdslsh/inform)   | Web content extraction tool     | ✅ Active |
| [unify](https://github.com/fwdslsh/unify)     | Modern static site generator    | ✅ Active |
| [giv](https://github.com/fwdslsh/giv)         | AI-powered Git assistant        | ✅ Active |

## Benefits

### 🔧 Centralized Maintenance

- Update workflows once, benefit all projects
- Consistent behavior across repositories
- Reduced duplication and maintenance burden

### 🎯 Standardization

- Identical release processes
- Consistent binary naming conventions
- Uniform installation experience

### 🚀 Reliability

- Battle-tested workflows
- Continuous improvements
- Shared bug fixes and security updates

### 📈 Scalability

- Easy onboarding for new projects
- Minimal per-project configuration
- Automatic updates for all consumers

## Quick Start

### Install a CLI Tool

```bash
# Install the latest version of any tool
curl -fsSL https://raw.githubusercontent.com/fwdslsh/toolkit/main/install.sh | bash -s catalog

# See all available tools
curl -fsSL https://raw.githubusercontent.com/fwdslsh/toolkit/main/install.sh | bash -s -- --list
```

### Use in CI/CD

```yaml
# GitHub Actions example
- name: Install fwdslsh tools
  run: |
    curl -fsSL https://raw.githubusercontent.com/fwdslsh/toolkit/main/install.sh | bash -s catalog
    curl -fsSL https://raw.githubusercontent.com/fwdslsh/toolkit/main/install.sh | bash -s unify

- name: Generate documentation
  run: |
    inform https://docs.example.com --output-dir content
    catalog --input content --output artifacts
    unify build --source artifacts --output dist
```

### Use with Docker

```bash
# Pull the toolkit image
docker pull fwdslsh/toolkit:latest

# Use in your projects
docker run --rm -v $(pwd):/workspace fwdslsh/toolkit:latest \
  sh -c "inform https://docs.example.com --output-dir /workspace/docs && catalog --input /workspace/docs --output /workspace/build"
```
