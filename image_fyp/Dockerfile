FROM handsonsecurity/seed-ubuntu:large

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    iproute2 iputils-ping curl nmap iperf3 netcat-openbsd python3 procps iptables \
    && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
