# Use the official Debian 13 (Trixie) as the base image
FROM debian:trixie

# Set the working directory inside the container
WORKDIR /app

# Copy the setup script from your local machine to the container's /app directory
COPY setup.sh .

# Make the setup script executable
RUN chmod u+x setup.sh

# Upgrade everything in container and install sudo so script can work
RUN apt update && apt install sudo -y

# The command to run when the container starts
CMD ["./setup.sh"]
