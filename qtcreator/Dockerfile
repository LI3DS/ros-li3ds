FROM li3ds/ros:indigo

# Install Zsh
RUN apt-get install -y zsh &&	\
	git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
      && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
      && chsh -s /bin/zsh

# QtCreator
RUN apt-get install -y qtcreator

COPY .config/QtProject/QtCreator.ini /root/.config/QtProject/QtCreator.ini 

COPY .fonts/SourceCodePro+Powerline+AwesomeRegular+Docker.ttf /root/.fonts/SourceCodePro+Powerline+AwesomeRegular+Docker.ttf
RUN fc-cache fv

RUN export uid=1000 gid=1000 && \
    mkdir -p /root && \
    echo "root:x:${uid}:${gid}:root,,,:/root:/bin/zsh" >> /etc/passwd && \
    echo "root:x:${uid}:" >> /etc/group && \
    echo "root ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/root && \
    chmod 0440 /etc/sudoers.d/root && \
    chown ${uid}:${gid} -R /root

USER root
ENV HOME /root

CMD /usr/bin/qtcreator.sh