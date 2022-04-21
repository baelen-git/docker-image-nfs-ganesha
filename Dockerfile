FROM ubuntu:focal
#MAINTAINER Boris Aelen <baelen@cisco.com>
#LABEL org.opencontainers.image.source=https://github.com/baelen-git/docker-image-nfs-ganesha

# install prerequisites
RUN DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -y software-properties-common \
 && add-apt-repository -y ppa:nfs-ganesha/nfs-ganesha-3.0 \
 && add-apt-repository -y ppa:gluster/glusterfs-9 \
 && add-apt-repository ppa:nfs-ganesha/libntirpc-3.0

RUN DEBIAN_FRONTEND=noninteractive \
 && apt-get install -y nfs-ganesha nfs-ganesha-vfs \
# && apt-get install -y netbase nfs-common dbus nfs-ganesha nfs-ganesha-vfs glusterfs-common \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

RUN mkdir -p /run/rpcbind /export /var/run/dbus /var/run/ganesha 
#RUN touch /run/rpcbind/rpcbind.xdr /run/rpcbind/portmap.xdr 
#RUN chmod 755 /run/rpcbind/* 
#RUN chown messagebus:messagebus /var/run/dbus

# Add startup script
COPY start.sh /
COPY ganesha.conf /etc/ganesha/ganesha.conf

# NFS ports and portmapper
EXPOSE 2049 2048 111/udp 111 875

# Start Ganesha NFS daemon by default
#CMD ["/start.sh"]

