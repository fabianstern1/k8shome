#!/bin/sh

# Loop through all files in the /ssh.pem directory
for FILEPATH in /keys/*; do
    if [ -f "${FILEPATH}" ]; then
                FILE="$(basename ${FILEPATH})"
		AUTHORIZED_KEYS_FILE="/home/${FILE}/.ssh/authorized_keys"
		printf "\n${FILE}\tALL=(ALL) NOPASSWD:ALL\n" >> /etc/sudoers
		useradd -m -s /bin/bash ${FILE} && \
		mkdir -p /home/${FILE}/.ssh && \
		chown ${FILE}:${FILE} /home/${FILE}/.ssh
    
		touch /home/${FILE}/.ssh/authorized_keys
		cat /keys/$FILE >> /home/${FILE}/.ssh/authorized_keys
		chown ${FILE}:${FILE} "${AUTHORIZED_KEYS_FILE}"
		chmod 600 "${AUTHORIZED_KEYS_FILE}"
    fi
done

# Start the SSHD server
exec /usr/sbin/sshd -D
