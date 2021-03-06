FROM ubuntu:18.04

ENV USER l4d2
ENV HOME /home/$USER
ENV SERVER $HOME/hlserver

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get -y update \
    && apt-get -y install lib32gcc1 curl net-tools lib32stdc++6 locales unzip lib32z1 screen \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && dpkg-reconfigure --frontend noninteractive locales \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd --create-home $USER

USER $USER

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN mkdir $SERVER
COPY ./l4d2_ds.txt $SERVER/l4d2_ds.txt
COPY ./update.sh $SERVER/update.sh
COPY ./l4d2.sh $SERVER/l4d2.sh
RUN curl --silent --show-error http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C $SERVER -xvz \
    && $SERVER/update.sh
RUN curl --silent --show-error https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git971-linux.tar.gz | tar xvz -C $SERVER/l4d2/left4dead2
RUN curl --silent --show-error https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6498-linux.tar.gz | tar xvz -C $SERVER/l4d2/left4dead2
RUN curl --silent --show-error --location --output $HOME/tmp.zip https://github.com/SirPlease/L4D2-Competitive-Rework/archive/master.zip \
    && unzip -v $HOME/tmp.zip -d $SERVER/l4d2/left4dead2 \
    && rm $HOME/tmp.zip

EXPOSE 27015/udp

WORKDIR $SERVER
ENTRYPOINT ["./l4d2.sh"]
CMD ["-console" "-usercon" "+map" "c1m1_hotel"]
