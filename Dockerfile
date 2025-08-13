# Use the stable version of Debian as the base image
FROM debian:stable

# Set the working directory inside the container
WORKDIR /workspace

# Expose port 3000 for external access
EXPOSE 3000


# Install necessary packages and dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    git \
    unzip \
    sudo \
    build-essential \
    libssl-dev \
    pkg-config 
# \
# libclang-dev \
# clang \
# cmake \
# gcc \
# python3 \
# python3-dev \
# python3-pip \
# pipx

# Create a non-root user and grant sudo privileges
RUN useradd -m -s /bin/bash nonroot \
    && echo "nonroot ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


# Define version arguments for various tools (use "latest" for latest version)
ARG glow_version=2.1.1
ARG gh_version=2.76.2
ARG giv_version=""
ARG unify_version=""
ARG inform_version=""
ARG catalog_version=""

# Download and install Glow, a markdown renderer
RUN curl -k -L -o glow_linux_amd64.deb https://github.com/charmbracelet/glow/releases/download/v${glow_version}/glow_${glow_version}_amd64.deb && \
    dpkg -i glow_linux_amd64.deb

# Download and install GitHub CLI
RUN curl -k -L -o gh_linux_amd64.deb https://github.com/cli/cli/releases/download/v${gh_version}/gh_${gh_version}_linux_amd64.deb
RUN dpkg -i gh_linux_amd64.deb

# Clean up downloaded files to reduce image size
RUN rm glow_linux_amd64.deb gh_linux_amd64.deb



# Install catalog
RUN curl -fsSL https://raw.githubusercontent.com/fwdslsh/catalog/main/install.sh | bash -s -- --version "${catalog_version:-}"

# Install inform
RUN curl -fsSL https://raw.githubusercontent.com/fwdslsh/inform/main/install.sh | bash -s -- --version "${inform_version:-}"

# Install unify
RUN curl -fsSL https://raw.githubusercontent.com/fwdslsh/unify/main/install.sh | bash -s -- --version "${unify_version:-}"

# Install giv
RUN curl -fsSL https://raw.githubusercontent.com/fwdslsh/giv/main/install.sh | bash

# Switch to the non-root user
USER nonroot

# Install fwdslsh tools using their install scripts
# Add ~/.local/bin to PATH for user installations
ENV PATH="$PATH:/home/nonroot/.local/bin"


# Set the default entry point to bash
ENTRYPOINT ["/bin/bash"]