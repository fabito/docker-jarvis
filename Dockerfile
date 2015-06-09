FROM python:2-onbuild

MAINTAINER Fábio Uechi <fabio.uechi@gmail.com>

RUN sudo apt-get install -y git zsh && \
    sudo pip install rivescript

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer

# Install oh-my-zhs
ENV ZSH ${HOME}/.oh-my-zsh
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh
ADD home/ ${HOME}/
RUN sudo chown -R ${uid}:${gid} ${HOME}

# Install fasd
RUN \
  sudo git clone https://github.com/clvv/fasd.git /usr/local/fasd &&\ 
  sudo ln -s /usr/local/fasd/fasd /usr/bin/fasd

# Define default command.
CMD ["zsh"]