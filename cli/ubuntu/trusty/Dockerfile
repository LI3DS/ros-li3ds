FROM ubuntu:trusty

# setup environment
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

RUN apt-get update
# Install Oh My Zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
	&& cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
	&& chsh -s /bin/zsh