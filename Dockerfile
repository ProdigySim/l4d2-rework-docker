# Left4DevOps rocky linux-based base image
FROM left4devops/l4d2

USER root
# Install rsync and find to make the copy job easier
RUN microdnf install -y rsync findutils && \
    microdnf clean all

USER louis
RUN curl https://codeload.github.com/SirPlease/L4D2-Competitive-Rework/tar.gz/refs/heads/master | tar -xvz \
  && find L4D2-Competitive-Rework-master/addons -iname "*.dll" -exec rm {} ';' \
  && rsync -K -a L4D2-Competitive-Rework-master/scripts/* $INSTALL_DIR/left4dead2/scripts/ \
  && rsync -K -a L4D2-Competitive-Rework-master/addons/* $INSTALL_DIR/left4dead2/addons/ \
  && rsync -K -a L4D2-Competitive-Rework-master/cfg/* $INSTALL_DIR/left4dead2/cfg/ \
  && rm -rf L4D2-Competitive-Rework-master

# New vars supported
ENV TICKRATE=100 \
    MAXPLAYERS=8 \
    DEFAULT_MAP=c1m1_hotel \
    IP=0.0.0.0

ADD entrypoint.sh .

ENTRYPOINT  ["./entrypoint.sh"]
