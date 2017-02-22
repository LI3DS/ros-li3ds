FROM ros:indigo-ros-core

# Target pour le DEV
# TODO: faudra en faire une (optimisée) pour l'exécution

### CONFIGS
# APT CONF
COPY apt.conf /etc/apt/apt.conf
# GIT CONFIG
COPY .gitconfig /root/.gitconfig

### APT
# Tools for building
RUN apt-get update && 			\
    apt-get install -y 			\
    realpath					\
    build-essential				\
    curl						\
	python-rosinstall-generator	\
	usbutils
# TODO: effacer le cache apt

### CMAKE
COPY cmake-3.8.0-rc1.tar.Z /cmake-3.8.0-rc1.tar.Z
RUN tar xzvf /cmake-3.8.0-rc1.tar.Z
RUN cd cmake-3.8.0-rc1 && ./configure && make -j3 && make install
RUN rm /cmake-3.8.0-rc1.tar.Z && rm -r cmake-3.8.0-rc1

# Install Zsh
# RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
#       && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
#       && chsh -s /bin/zsh

# # Purge/clean apt
# RUN apt-get clean                   \
# 	&& rm -rf /var/lib/apt/lists/*