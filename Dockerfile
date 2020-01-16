# This Dockerfile is used to build the image available on DockerHub
FROM centos:centos7 as build

# Add everything
ADD . /usr/src/multus-cni

ENV INSTALL_PKGS "git golang"
RUN yum install -y epel-release && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    cd /usr/src/multus-cni && \
    ./build

FROM centos:centos7
COPY --from=build /usr/src/multus-cni /usr/src/multus-cni
WORKDIR /

ADD ./images/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
