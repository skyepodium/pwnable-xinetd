# environment
FROM ubuntu:16.04
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y lib32z1 xinetd gcc

# add challenger user
RUN useradd -u 8080 -m challenge

# Copy the xinetd configuration to the container
COPY ./xinetd /etc/xinetd.d/xinetd

# Copy pwn script to the container
# when the user connects to the server, the pwn script executes chall binary
COPY pwn /home/challenge/pwn
RUN chown challenge:challenge /home/challenge/pwn && chmod +x /home/challenge/pwn

# Copy flag to the container
COPY ./flag /home/challenge/flag

# Copy the source code to the container
COPY ./src/chall.c /home/challenge/chall.c

# Build the C program
RUN gcc -z norelro -z execstack -no-pie -fno-stack-protector /home/challenge/chall.c -o /home/challenge/chall

CMD ["/usr/sbin/xinetd", "-dontfork"]