#FROM ubuntu:22.04
FROM jrei/systemd-ubuntu:22.04
RUN apt update -y && apt install -y openssh-server netstat-nat net-tools curl wget sudo iproute2 fuse-overlayfs iptables 

COPY sshd_config /etc/ssh/sshd_config
ADD keys /keys

# Set up the SSHD configuration
RUN mkdir -p /var/run/sshd && \
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

# Hack for Kubernetes in Docker: Ignore Swapoff Command
RUN cp /usr/sbin/swapoff /usr/sbin/swapoff2 && cp -f /usr/bin/echo /usr/sbin/swapoff

# Start our entrypoint.sh service for Initialization and Disable onboard sshd.service
ADD entrypoint.service /etc/systemd/system/entrypoint.service
RUN systemctl enable entrypoint.service && systemctl disable sshd.service && systemctl enable systemd-networkd
#RUN printf "[NetDev]\nName=dummy0\nKind=dummy\n" >/etc/systemd/network/10-dummy0.netdev
#RUN printf "[Match]\nName=dummy0\n[Network]\nAddress=192.168.0.1/24\n" >/etc/systemd/network/20-dummy0.network

# Enable legacy iptables as nftables are not available
RUN update-alternatives --set iptables /usr/sbin/iptables-legacy && update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

ENTRYPOINT ["/lib/systemd/systemd"]


