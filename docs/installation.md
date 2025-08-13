# Universal fwdslsh CLI Tools Installer

A single, reusable installation script that can install any fwdslsh CLI tool with consistent behavior and options.

## Features

- **Multi-tool support**: Install catalog, inform, unify, giv, and future tools
- **Platform detection**: Automatic OS and architecture detection
- **Version management**: Install latest or specific versions
- **Multiple install modes**: User, system-wide, or custom directory
- **Safety features**: Existing installation detection, dry-run mode
- **PATH assistance**: Helps configure PATH for different shells
- **Tool discovery**: List available tools with descriptions

## Quick Install

Install any tool directly from GitHub:

```bash
# Install latest version of a tool
curl -fsSL https://raw.githubusercontent.com/fwdslsh/.github/main/.github/install.sh | bash -s catalog
curl -fsSL https://raw.githubusercontent.com/fwdslsh/.github/main/.github/install.sh | bash -s unify
curl -fsSL https://raw.githubusercontent.com/fwdslsh/.github/main/.github/install.sh | bash -s inform

# Install specific version
curl -fsSL https://raw.githubusercontent.com/fwdslsh/.github/main/.github/install.sh | bash -s unify -- --version v0.4.8

# Install to custom directory
curl -fsSL https://raw.githubusercontent.com/fwdslsh/.github/main/.github/install.sh | bash -s catalog -- --dir ~/.local/bin
```

## Local Usage

Download and run the installer locally:

```bash
# Download the installer
curl -O https://raw.githubusercontent.com/fwdslsh/.github/main/.github/install.sh
chmod +x install.sh

# Show available tools
./install.sh --list

# Install a tool
./install.sh catalog
./install.sh unify --version v0.4.8
./install.sh inform --dir ~/.local/bin --force
```

## Available Tools

| Tool | Description | Repository |
|------|-------------|------------|
| **catalog** | Documentation catalog generator | [fwdslsh/catalog](https://github.com/fwdslsh/catalog) |
| **inform** | Web content extraction tool | [fwdslsh/inform](https://github.com/fwdslsh/inform) |
| **unify** | Modern static site generator | [fwdslsh/unify](https://github.com/fwdslsh/unify) |
| **giv** | AI-powered Git assistant | [fwdslsh/giv](https://github.com/fwdslsh/giv) |

## Command Line Options

```
USAGE:
    install.sh TOOL [OPTIONS]
    install.sh --list

OPTIONS:
    --help              Show help message
    --list              List available tools
    --version TAG       Install specific version (e.g., v1.0.0)
    --dir PATH          Custom installation directory
    --global            Install globally (system-wide)
    --force             Force reinstall
    --dry-run           Preview installation without changes
```

## Environment Variables

Control installation behavior with environment variables:

```bash
# Custom installation directory
export FWDSLSH_INSTALL_DIR=/opt/bin
./install.sh catalog

# Specific version
export FWDSLSH_VERSION=v0.4.8
./install.sh unify

# Force reinstall
export FWDSLSH_FORCE=1
./install.sh inform
```

## Installation Directories

Default installation locations:

- **User mode** (default): `~/.local/bin`
- **Global mode** (`--global`): `/usr/local/bin`
- **Custom** (`--dir PATH`): Your specified directory

## Platform Support

The installer automatically detects and downloads the correct binary for:

- **Linux**: x86_64, ARM64
- **macOS**: Intel (x86_64), Apple Silicon (ARM64)
- **Windows**: x86_64 (via WSL/Git Bash)

## Binary Naming Convention

Downloaded binaries follow the pattern:
- `{tool}-linux-x86_64`
- `{tool}-darwin-arm64`
- `{tool}-windows-x86_64.exe`

## Examples

### Install Multiple Tools

```bash
# Install all core tools
for tool in catalog inform unify; do
    ./install.sh $tool
done
```

### CI/CD Integration

```yaml
# GitHub Actions example
- name: Install fwdslsh tools
  run: |
    curl -fsSL https://raw.githubusercontent.com/fwdslsh/.github/main/.github/install.sh | bash -s catalog
    curl -fsSL https://raw.githubusercontent.com/fwdslsh/.github/main/.github/install.sh | bash -s unify
```

### Docker Integration

```dockerfile
# Dockerfile example
FROM ubuntu:latest
RUN apt-get update && apt-get install -y curl
RUN curl -fsSL https://raw.githubusercontent.com/fwdslsh/.github/main/.github/install.sh | bash -s catalog -- --dir /usr/local/bin
```

## Tool Detection

The installer can detect if a tool is already installed:

```bash
$ ./install.sh catalog
[INFO] Found existing installation: /usr/local/bin/catalog (version: 0.0.7)
[WARN] catalog is already installed. Use --force to reinstall.

$ ./install.sh catalog --force
[INFO] Force install enabled, proceeding with installation...
```

## PATH Configuration

If the installation directory isn't in your PATH, the installer provides shell-specific instructions:

```bash
[WARN] /home/user/.local/bin is not in your PATH

# For bash
export PATH="/home/user/.local/bin:$PATH"

# For zsh
export PATH="/home/user/.local/bin:$PATH"

# For fish
fish_add_path /home/user/.local/bin
```

## Dry Run Mode

Preview what would be installed without making changes:

```bash
$ ./install.sh unify --dry-run
[INFO] Installation directory: /home/user/.local/bin
[INFO] Fetching latest release information...
[INFO] Installing unify version: v0.4.8
[INFO] [DRY RUN] Would download: curl -fL "https://..." -o "/tmp/..."
[INFO] [DRY RUN] Would install to: /home/user/.local/bin/unify
[INFO] [DRY RUN] Installation simulation complete
```

## Adding New Tools

To add a new tool to the installer, update the `TOOL_CONFIGS` array in the script:

```bash
TOOL_CONFIGS=(
    ["newtool"]="owner/repo|v1.0.0|Tool description"
)
```

Optionally add a custom banner function:

```bash
show_banner_newtool() {
    printf "${CYAN}Your ASCII Art Here${NC}\n"
}
```

## Security

- Downloads are fetched directly from official GitHub releases
- HTTPS is enforced for all downloads
- Path traversal protection included
- No execution of untrusted code

## Troubleshooting

### Permission Denied

```bash
# Use user installation (recommended)
./install.sh tool --user

# Or use sudo for system-wide
sudo ./install.sh tool --global
```

### Network Issues

```bash
# The installer will use fallback versions if GitHub API is unreachable
[WARN] Failed to fetch latest version from GitHub API, using fallback version: v0.0.7
```

### Platform Not Supported

```bash
[ERROR] Unsupported operating system: SunOS
# Contact maintainers for platform support
```

## Maintenance

This universal installer is maintained in the [fwdslsh/.github](https://github.com/fwdslsh/.github) repository. Updates to the installer automatically benefit all tools and users.

## License

MIT License - See [LICENSE](https://github.com/fwdslsh/.github/blob/main/LICENSE) for details.