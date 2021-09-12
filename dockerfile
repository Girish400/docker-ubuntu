FROM python:3.8-slim-buster

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install pip requirements
COPY requirements.txt .

RUN python -m pip install -r requirements.txt

RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

# install the tooks for use
RUN apt-get update && \
  apt-get install -y sudo \
  tzdata \
  curl \
  git-core \
  gnupg \
  locales \
  zsh \
  wget \
  nano \
  npm \
  fonts-powerline \
  git\
  && locale-gen en_US.UTF-8 

  
  # the user we're applying this too (otherwise it most likely install for root)
 
  # terminal colors with xterm
  ENV TERM xterm
  # set the zsh theme
  ENV ZSH_THEME agnoster

  # run the installation script  

  

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo wget \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

USER $USERNAME

  RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
  RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
  RUN echo "source ~/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
  RUN echo "source typeset -g POWERLEVEL9K_VIRTUALENV_GENERIC_NAMES=()" >>~/.p10k.zsh
  RUN cd ~/powerlevel10k
  RUN exec zsh
  
  # start zsh
CMD [ "zsh" ]