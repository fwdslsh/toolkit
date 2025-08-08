# Use the stable version of Debian as the base image
FROM debian:stable

# Set the working directory inside the container
WORKDIR /workspace

# Expose port 3000 for external access
EXPOSE 3000

# Define version arguments for various tools
ARG glow_version=2.1.1
ARG giv_version=0.5.2-beta
ARG unify_version=0.4.2
ARG inform_version=0.0.4
ARG gh_version=2.76.2

# Install necessary packages and dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    sudo \
    build-essential \
    libssl-dev \
    pkg-config \
    libclang-dev \
    clang \
    cmake \
    gcc \
    python3.11 \
    python3.11-dev \
    python3-pip \
    pipx

# Download and install Glow, a markdown renderer
RUN curl -L -o glow_linux_amd64.deb https://github.com/charmbracelet/glow/releases/download/v${glow_version}/glow_${glow_version}_amd64.deb && \
    dpkg -i glow_linux_amd64.deb

# Download and install GitHub CLI
RUN curl -L -o gh_linux_amd64.deb https://github.com/cli/cli/releases/download/v${gh_version}/gh_${gh_version}_linux_amd64.deb
RUN dpkg -i gh_linux_amd64.deb

# Clean up downloaded files to reduce image size
RUN rm glow_linux_amd64.deb gh_linux_amd64.deb

# Create a non-root user and grant sudo privileges
RUN useradd -m -s /bin/bash nonroot \
    && echo "nonroot ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the non-root user
USER nonroot

# Install Bun, a fast JavaScript runtime
RUN curl -fsSL https://bun.sh/install | bash

# Install Giv and other tools using pipx and Bun
RUN pipx install giv
RUN $HOME/.bun/bin/bun install -g @fwdslsh/unify@${unify_version} @fwdslsh/inform@${inform_version}

# Add the Giv binary directory to the PATH
ENV PATH="$PATH:/home/nonroot/.local/pipx/venvs/giv/bin"

# Set the default entry point to bash
ENTRYPOINT ["/bin/bash"]