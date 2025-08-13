#! /bin/bash

# Build the Docker image
docker build -t fwdslsh/toolkit:latest .

# Run the container with host networking to allow curl requests to the host machine
docker run --rm -it --network host -p 3000:3000 -v $(pwd):/workspace fwdslsh/toolkit:latest