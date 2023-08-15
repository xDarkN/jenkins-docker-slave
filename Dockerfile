FROM ubuntu:18.04-slim

RUN apt-get update && \
    apt-get install -qy git && \
    apt-get install -qy openssh-server && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
    # Install JDK 11
    apt-get install -qy default-jdk && \
    # Install maven
    apt-get install -qy maven && \
    # Cleanup old packages
    apt-get -qy autoremove && \
    # Add user jenkins to the image
    adduser --quiet jenkins && \
    RUN echo "jenkins:jenkins" | chpasswd && \
    mkdir /home/jenkins/.m2

# Copy authorized keys
COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys

RUN chown -R jenkins:jenkins /home/jenkins/.m2/ && \
    chown -R jenkins:jenkins /home/jenkins/.ssh/

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
