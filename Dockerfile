FROM opensuse/microos:latest

# Installer les outils nécessaires
RUN zypper --non-interactive install -y kiwi kiwi-desc-netboot kiwi-tools ostree

# Cloner le référentiel MicroOS-desktop
RUN git clone https://github.com/openSUSE/microOS-desktop.git

# Construire l'image OSTree personnalisée
RUN cd microOS-desktop && sudo kiwi-ng --type ostree system build --description kiwi-desc-netboot

# Déplacer l'image OSTree résultante
RUN sudo mv microOS-desktop/result/* /workspace
