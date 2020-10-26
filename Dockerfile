FROM ubuntu:18.04

ENV USER l4d2
ENV HOME /home/$USER
ENV SERVER $HOME/hlserver

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get --no-install-recommends -y install lib32gcc1 curl net-tools lib32stdc++6 locales unzip lib32z1 screen \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && useradd $USER \
    && mkdir $HOME \
    && chown $USER:$USER $HOME \
    && mkdir $SERVER

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ADD ./l4d2_ds.txt $SERVER/l4d2_ds.txt
ADD ./update.sh $SERVER/update.sh
ADD ./l4d2.sh $SERVER/l4d2.sh

RUN chown -R $USER:$USER $SERVER

USER $USER
RUN curl http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C $SERVER -xvz \
    && $SERVER/update.sh


RUN curl https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git971-linux.tar.gz | tar xvz -C $SERVER/l4d2/left4dead2

RUN curl https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6498-linux.tar.gz | tar xvz -C $SERVER/l4d2/left4dead2

RUN curl -L --output $HOME/tmp.zip https://github.com/SirPlease/L4D2-Competitive-Rework/archive/master.zip \
    && unzip -v $HOME/tmp.zip -d $SERVER/l4d2/left4dead2 \
    && rm $HOME/tmp.zip

EXPOSE 27015/udp

WORKDIR /home/$USER/hlserver
ENTRYPOINT ["./l4d2.sh"]
CMD ["-console" "-usercon" "+map" "c1m1_hotel"]
