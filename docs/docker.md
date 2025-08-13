# fwdslsh/toolkit

A comprehensive Docker-based development toolkit containing essential tools for modern software development, documentation, and Git workflow management.

## Overview

This toolkit provides a containerized environment with pre-installed development tools, making it easy to get started with various development tasks without having to install and configure tools individually on your local machine.

## Included Tools

### Core Development Tools
- **Python 3** with pip and pipx for Python development
- **Build tools**: gcc, cmake, clang, build-essential
- **Git**: Version control system
- **curl**: Command-line tool for transferring data
- **sudo**: Administrative privileges

### Specialized Tools
- **[Glow](https://github.com/charmbracelet/glow)** (v2.1.1): Terminal-based markdown renderer for beautiful documentation viewing
- **[GitHub CLI (gh)](https://cli.github.com/)** (v2.76.2): Official GitHub command-line tool
- **[Bun](https://bun.sh/)**: Fast all-in-one JavaScript runtime and toolkit
- **[Giv](https://pypi.org/project/giv/)** (v0.5.2-beta): Python tool installed via pipx
- **[@fwdslsh/unify](https://www.npmjs.com/package/@fwdslsh/unify)** (v0.4.2): JavaScript package for unification tasks
- **[@fwdslsh/inform](https://www.npmjs.com/package/@fwdslsh/inform)** (v0.0.4): JavaScript package for information management

## Quick Start

### Building the Container

```bash
# Clone the repository
git clone https://github.com/fwdslsh/toolkit.git
cd toolkit

# Build the Docker image
docker build -t fwdslsh/toolkit:latest .
```

### Running the Container

#### Using the provided script (recommended):
```bash
./run.sh
```

#### Manual Docker run:
```bash
docker run --rm -it --network host -p 3000:3000 -v $(pwd):/workspace fwdslsh/toolkit:latest
```

#### Running specific commands:
```bash
# Run a specific command in the container
docker run --rm -v $(pwd):/workspace fwdslsh/toolkit:latest glow README.md

# Interactive shell with current directory mounted
docker run --rm -it -v $(pwd):/workspace fwdslsh/toolkit:latest
```

## Usage Examples

### Document Viewing with Glow
```bash
# View a markdown file with beautiful formatting
docker run --rm -v $(pwd):/workspace fwdslsh/toolkit:latest glow README.md

# Start Glow's TUI for browsing markdown files
docker run --rm -it -v $(pwd):/workspace fwdslsh/toolkit:latest glow
```

### GitHub CLI Operations
```bash
# Check GitHub CLI status
docker run --rm -v $(pwd):/workspace fwdslsh/toolkit:latest gh auth status

# Clone a repository
docker run --rm -v $(pwd):/workspace fwdslsh/toolkit:latest gh repo clone owner/repo
```

### JavaScript Development with Bun
```bash
# Run Bun commands
docker run --rm -v $(pwd):/workspace fwdslsh/toolkit:latest /home/nonroot/.bun/bin/bun --version

# Install dependencies
docker run --rm -v $(pwd):/workspace fwdslsh/toolkit:latest /home/nonroot/.bun/bin/bun install
```

### Python Development
```bash
# Run Python scripts
docker run --rm -v $(pwd):/workspace fwdslsh/toolkit:latest python3 script.py

# Install Python packages
docker run --rm -v $(pwd):/workspace fwdslsh/toolkit:latest pip install package-name
```

## Container Details

- **Base Image**: Debian stable
- **Working Directory**: `/workspace`
- **Exposed Port**: 3000
- **Non-root User**: `nonroot` with sudo privileges
- **Entry Point**: `/bin/bash`

## Networking

The container is configured to use host networking mode, allowing applications running inside the container to access services on the host machine. Port 3000 is exposed for web applications or services that need external access.

## Volume Mounting

The container is designed to work with your local files by mounting the current directory to `/workspace`. This allows you to:

- Edit files on your host machine
- Run tools on those files inside the container
- Have results available on your host machine

## Development Workflow

1. **Mount your project directory** as a volume to `/workspace`
2. **Use the included tools** for your development tasks
3. **Access services** running on your host machine through host networking
4. **Install additional tools** as needed using the package managers

## Building and Publishing

This repository includes GitHub Actions workflow for automatic building and publishing:

- **Trigger**: On release creation
- **Registries**: Docker Hub (`fwdslsh/toolkit`)
- **Tags**: Both release version and `latest`
- **Auto-versioning**: Automatically fetches latest versions of included tools at build time

### Version Management

The release workflow automatically determines the latest versions of tools from their respective repositories:
- **Glow**: Latest from [charmbracelet/glow](https://github.com/charmbracelet/glow)
- **GitHub CLI**: Latest from [cli/cli](https://github.com/cli/cli)  
- **Unify**: Latest from [fwdslsh/unify](https://github.com/fwdslsh/unify)
- **Inform**: Latest from [fwdslsh/inform](https://github.com/fwdslsh/inform)
- **Giv**: Uses predefined version (Python package)

If the GitHub API is unavailable, the workflow falls back to default versions defined in the Dockerfile ARG statements.

## Contributing

When contributing to this toolkit:

1. Test any changes to the Dockerfile by building locally
2. The ARG definitions at the top of the Dockerfile serve as fallback versions
3. Verify that all tools install and function correctly
4. Update this README if adding new tools or changing functionality

## License

This project is licensed under the Creative Commons Attribution 4.0 International License (CC BY 4.0). See the [LICENSE](LICENSE) file for details.

## Troubleshooting

### Common Issues

**SSL Certificate Errors**: If you encounter SSL certificate issues during build, this may be due to network configuration. Try building from a different network or check your corporate firewall settings.

**Permission Issues**: The container runs as a non-root user (`nonroot`) with sudo privileges. If you need root access, you can use `sudo` within the container.

**Tool Not Found**: Some tools are installed in user-specific locations:
- Bun: `/home/nonroot/.bun/bin/bun`
- Giv: Available in PATH after installation

### Getting Help

- Check tool-specific documentation for usage details
- Verify volume mounts are correct for file access
- Ensure proper networking configuration for service access