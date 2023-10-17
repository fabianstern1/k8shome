FROM ubuntu:22.04
RUN apt update -y && apt install -y openssh-server netstat-nat net-tools curl wget sudo

COPY sshd_config /etc/ssh/sshd_config
ADD keys /keys

# Set up the SSHD configuration
RUN mkdir /var/run/sshd && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# Create a new user and set up SSH authorized_keys
ARG USERNAME=k8s
RUN useradd -m -s /bin/bash ${USERNAME} && \
    mkdir -p /home/${USERNAME}/.ssh && \
    chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh && \
	adduser ${USERNAME} sudo

# Expose the SSH port
EXPOSE 22

# Add a script to set up the authorized_keys file at runtime
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Start the SSHD server
ENTRYPOINT ["/entrypoint.sh"]
