# This Dockerfile is used to build the image available on DockerHub
FROM centos:centos7 as build

# Add everything
ADD . /usr/src/multus-cni

ENV GOARCH "amd64"
ENV GOOS "linux"

ENV INSTALL_PKGS "git wget"
RUN yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    wget https://dl.google.com/go/go1.13.5.linux-$GOARCH.tar.gz -P /tmp && \
    tar xf /tmp/go1.13.5.linux-ppc64le.tar.gz -C /usr/local/ && \
    ln -s /usr/local/go/bin/go /usr/bin/ && \
    cd /usr/src/multus-cni && \
    ./build

FROM centos:centos7
COPY --from=build /usr/src/multus-cni /usr/src/multus-cni
WORKDIR /

ADD ./images/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
