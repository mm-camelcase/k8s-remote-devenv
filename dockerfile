# Use the official Eclipse Temurin base image for Java 17 (Ubuntu Jammy-based)
FROM eclipse-temurin:17-jdk-jammy

# Add a new user called 'user' with a home directory
RUN useradd -ms /bin/bash user

# Switch to the new user to avoid running as root
USER user

# Set the working directory to the user's home directory
WORKDIR /home/user

# You can add any other necessary commands below as needed, such as copying files or installing additional dependencies
# For example, you might want to copy your source code or install other packages
# COPY ./your-application /home/user/your-application

# Set the default command to run a shell (optional)
CMD ["/bin/bash"]

