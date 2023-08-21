FROM frolvlad/alpine-glibc:glibc-2.34

RUn apk --update add --no-cache g++ shadow && \
        groupadd -g 1000 mesh && useradd -ml -u 1000 -g 1000 mesh

RUN wget https://github.com/mate-dev/mmrelaynode/releases/latest/download/meshtasticd_linux_amd64 -O /home/mesh/meshtasticd_linux_amd64
RUN chmod +x /home/mesh/meshtasticd_linux_amd64

USER mesh
WORKDIR /home/mesh
CMD sh -cx "./meshtasticd_linux_amd64 --hwid '$HWID'"

HEALTHCHECK NONE
