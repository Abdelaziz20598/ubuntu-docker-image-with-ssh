FROM ubuntu:latest
RUN apt update && apt install openssh-server -y
RUN apt-get clean\
&& rm -rf /var/lib/apt/lists/*

#RUN adduser -s /bin/bash -m ansible
#--disabled-password option to prevent a password prompt.--disabled-password: This option explicitly disables the password for the user, meaning the user cannot log in with a password (but can still be used by other means, like SSH keys)
#RUN adduser --disabled-password -s /bin/bash  ansible
RUN useradd -m -s /bin/bash ansible
RUN passwd -d ansible 
#-d for not setting pass
#RUN passwd ansible
#RUN echo "12345" | chpasswd

#RUN service ssh start ,, caanot start ssh while build
#RUN service ssh enable
#RUN service ssh status
# Disable password authentication for SSH
RUN sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
RUN sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config


# Set up SSH key authentication (replace with your public key)
RUN mkdir -p /home/ansible/.ssh && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDcne/qqSTdJgtCYR49g4UYtKdxhGxzE2AJShz5RxTeKn8pHeqf9BghsWDu5A7A4lQBEmhtX3kwenX0/jzZlJqFdtY2OFDaIFxnwmz2rE4XUBFTBqiKT/eKLFoZMT9saOruHNvMpahwEjpirCTAd9pB0TBuy71pxtCuhnJqmH2dbN1/mPSkLn0n5BQfKqiFaJL8o+/raHmEsh/B8N+NNU2d1qfxLUFK0upF73EfJh8njaXsW3u08z+RA9xs20OJ8b8aggRDZRz5KErEoj/+R4uhzOT91L2hivM/XxvYbSiB9DnBpLwhjDkQ8AM5vmqSGE0Iql+4Qgv562u+QtmgkWwFj7Cyie0bK7rDDRQqTrRsid0OEPONfaJQ0VMeFBO+3w7iKhnEnlRiED+wQRdfWObEFMYO6LpxfowmLDkEo/hTBzM8gV9BE/pC3oppnWhZp0dP/nLAyGWSMqIoy98afRSdRpYuFpOAm980yWqJtUhribVQTlcYZ5tDu0wR/gXBYT8= abdelaziz@ubuntu20" > /home/ansible/.ssh/authorized_keys && \
    chown -R ansible:ansible /home/ansible/.ssh && \
    chmod 700 /home/ansible/.ssh && \
    chmod 600 /home/ansible/.ssh/authorized_keys


#  Ensure the SSH directory is correctly created
RUN mkdir /var/run/sshd

# Expose port 22 for SSH
EXPOSE 22


#RUN service ssh status
#RUN ssh omar@172.17.0.2

# Start the SSH service in the foreground (important for Docker containers)

#CMD ["/bin/bash", "-c", "ssh omar@172.17.0.2" ]
# Start SSH service when the container is run
#CMD ["/usr/sbin/sshd", "-D"]

# Create a script to start SSH and Bash
#WORKDIR /home
#RUN echo "#! /bin/bash\n/usr/sbin/sshd -D &\n/bin/bash" > start-ssh.sh
#RUN echo "#! /bin/bash\n service ssh start" > start-ssh.sh
# Make the script executable
#RUN chmod +x start-ssh.sh

#didnt work right
#CMD ["/bin/bash", "/home/start-ssh.sh"]
#CMD ["service ssh start"]
#CMD ["/usr/sbin/sshd", "-D &"]
#CMD ["/bin/bash", ". /home/start-ssh.sh"]
#CMD ["/bin/bash", ". /home/start-ssh.sh"]
# Set ENTRYPOINT to execute the script

#didnt work right
#ENTRYPOINT ["service", "ssh", "start"]
#ENTRYPOINT ["service ssh start && bash"]



#worked right
#ENTRYPOINT ["sh", "-c", "service ssh start && bash"]
ENTRYPOINT ["bash", "-c", "service ssh start && bash"]

#worked right
#ENTRYPOINT service ssh start && bash

#worked right
#ENTRYPOINT ["/bin/bash", "/home/start-ssh.sh"]
#ENTRYPOINT ["/bin/bash", ". /home/start-ssh.sh"]








