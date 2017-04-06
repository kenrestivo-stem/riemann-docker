FROM java:openjdk-8u72

# TODO: version as var

# Download the latest .deb and install
WORKDIR /opt
RUN curl -L https://github.com/riemann/riemann/releases/download/0.2.13/riemann-0.2.13.tar.bz2  > riemann.tar.bz2 \
&& tar -xvjf riemann.tar.bz2 \
&& rm riemann.tar.bz2

RUN mkdir /etc/riemann \
&& cp /opt/riemann-0.2.13/etc/riemann.config /etc/riemann/riemann.config 


# Expose the ports for inbound events and websockets
EXPOSE 5555
EXPOSE 5555/udp
EXPOSE 5556

# Share the config directory as a volume
VOLUME /etc/riemann

# Set the hostname in /etc/hosts so that Riemann doesn't die due to unknownHostException
CMD echo 127.0.0.1 $(hostname) > /etc/hosts \
&& /opt/riemann-0.2.13/bin/riemann /etc/riemann/riemann.config
