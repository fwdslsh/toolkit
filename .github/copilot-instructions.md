# fwdslsh/toolkit - Development Environment Tools

This is a Docker-based toolkit that provides a curated set of command-line development tools in a containerized environment. The toolkit includes markdown rendering, Git workflows, JavaScript runtime, and development build tools.

**Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.**

## Working Effectively

### Bootstrap and Build
- **Build the Docker image**: `docker build -t fwdslsh/toolkit:latest .`
  - **TIMING**: Clean build takes 57-60 seconds. Cached builds take ~0.1 seconds. NEVER CANCEL. Set timeout to 120+ seconds.
  - **SSL Issues**: In some environments, downloads may fail due to SSL certificate issues. The Dockerfile includes workarounds with `curl -k`.
  - **Python Version**: Uses `python3` and `python3-dev` (not python3.11) as that's what's available in Debian stable.

### Run the Toolkit
- **Quick start**: `./run.sh` - builds and runs the container with host networking
- **Manual run**: `docker run --rm -it --network host -p 3000:3000 -v $(pwd):/workspace fwdslsh/toolkit:latest`
- **Background**: The container runs as user `nonroot` with sudo privileges
- **Working directory**: `/workspace` (mounts current directory)

### Available Tools
The toolkit includes these validated tools:
- **Glow v2.1.1**: Markdown renderer - `glow --version`
- **GitHub CLI v2.76.2**: Git workflow automation - `gh --version` 
- **Python 3**: Default version from Debian stable - `python3 --version`
- **Bun**: Fast JavaScript runtime - installed at `$HOME/.bun/bin/bun`
- **Standard build tools**: gcc, cmake, clang, build-essential, libssl-dev, pkg-config

### Potentially Unavailable Tools
Due to network/SSL restrictions in some environments, these may not be installed:
- **Giv v0.5.2-beta**: Python package via pipx
- **Unify v0.4.2**: @fwdslsh/unify via Bun
- **Inform v0.0.4**: @fwdslsh/inform via Bun

## Build Validation and Troubleshooting

### Build Process Validation
1. **NEVER CANCEL builds** - clean builds take 57-60 seconds, cached builds take ~0.1 seconds
2. **Check build success**: `docker images fwdslsh/toolkit` should show the image
3. **Test basic functionality**: Create a test file: `echo "# Test" > test.md`

### Known Build Issues and Solutions
- **SSL certificate errors**: Dockerfile uses `curl -k` to bypass certificate verification
- **Python 3.11 not found**: Fixed to use default `python3` package
- **pipx installation failures**: May occur due to network restrictions - not critical for basic functionality

### Manual Validation Requirements
After building, ALWAYS test these scenarios:
1. **Container starts successfully**: `./run.sh` should drop you into a bash shell
2. **Tools are accessible**: Test `glow --version` and `gh --version`
3. **File mounting works**: Create a test file in the current directory and verify it's visible in `/workspace`
4. **Network access**: Test `curl -I https://github.com` to verify external connectivity

## Development Workflow

### Making Changes to the Toolkit
1. **Always test build changes**: Run `docker build` after any Dockerfile modifications
2. **Time your changes**: Use `time docker build` to measure impact on build duration
3. **Test in clean environment**: Use `docker build --no-cache` to ensure reproducible builds
4. **Validate tool installation**: After adding new tools, test their functionality interactively

### CI/CD Pipeline
- **Release workflow**: `.github/workflows/release.yml` builds and pushes to Docker Hub on release
- **Build context**: Uses current directory as build context
- **Registry**: Images are published to `fwdslsh/toolkit:latest` and `fwdslsh/toolkit:<version>`

## Common Commands and Expected Timing

### Build Commands
```bash
# Standard build (0.1 seconds if cached, 57-60 seconds if clean)
docker build -t fwdslsh/toolkit:latest .

# Clean build (57-60 seconds) - NEVER CANCEL
docker build --no-cache -t fwdslsh/toolkit:latest .

# Quick run
./run.sh
```

### Tool Usage Examples
```bash
# Inside the container:
glow README.md                    # Render markdown
gh repo list                      # List repositories  
python3 -c "print('Hello')"       # Test Python
$HOME/.bun/bin/bun --version      # Test Bun (if installed)
```

## Repository Structure
```
.
├── Dockerfile              # Main container definition
├── run.sh                  # Build and run script  
├── LICENSE                 # CC Attribution 4.0 license
└── .github/
    ├── workflows/
    │   └── release.yml     # Docker Hub publishing workflow
    └── copilot-instructions.md  # This file
```

## Key Project Information
- **Base image**: Debian stable
- **Primary user**: nonroot (with sudo)
- **Port exposure**: 3000 (though no services currently use it)
- **Volume mount**: Current directory → `/workspace`
- **Network**: Host networking for external access

## Validation Checklist
Before considering the toolkit functional, verify:
- [ ] `docker build` completes successfully (57-60 seconds clean, ~0.1 seconds cached)
- [ ] `./run.sh` starts container and drops to bash prompt
- [ ] `glow --version` shows v2.1.1 (if container execution works)
- [ ] `gh --version` shows v2.76.2 (if container execution works)
- [ ] `python3 --version` shows installed Python version (if container execution works)
- [ ] File in current directory is visible in `/workspace`
- [ ] Container can access external networks (test with curl)

**Note**: Some environments may have container execution limitations. Focus on successful build completion as the primary validation.

**Remember**: NEVER CANCEL long-running builds. Clean Docker builds for this toolkit take 57-60 seconds, cached builds take ~0.1 seconds.