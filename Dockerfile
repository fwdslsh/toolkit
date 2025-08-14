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

RUN curl -fsSL -o /workspace/install.sh https://raw.githubusercontent.com/fwdslsh/toolkit/main/install.sh
RUN chmod +x install.sh
RUN ./install.sh unify && ./install.sh inform && ./install.sh catalog
# Install giv
RUN curl -fsSL https://raw.githubusercontent.com/fwdslsh/giv/main/install.sh | bash

RUN mv /root/.local/bin/* /usr/local/bin && \
    rm install.sh && \
    chown -R nonroot:nonroot /workspace

# Switch to the non-root user
USER nonroot

# Install fwdslsh tools using their install scripts
# Add ~/.local/bin to PATH for user installations
ENV PATH="$PATH:/home/nonroot/.local/bin"


# Set the default entry point to bash
ENTRYPOINT ["/bin/bash"]