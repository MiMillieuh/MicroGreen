FROM opensuse/tumbleweed

# Installation de Neofetch
RUN zypper --non-interactive install neofetch

# Exécution de Neofetch au démarrage
CMD neofetch

# Définir le WORKDIR à /app
WORKDIR /app

# Copier les fichiers d'image OSTree dans le WORKDIR
COPY . /app

# Commandes pour la construction et l'upload de l'image OSTree
RUN ostree init --repo=/app/repo --mode=bare-user
RUN ostree commit --repo=/app/repo --branch=custom-branch --tree=dir=/app --add-metadata-string=version=1.0
RUN ostree summary --repo=/app/repo
RUN ostree --repo=/app/repo static-delta generate custom-branch
RUN ostree --repo=/app/repo static-delta generate custom-branch
RUN ostree --repo=/app/repo summary --update
RUN ostree --repo=/app/repo commit --link-checkout-speedup --branch=custom-branch
RUN tar -C /app/repo -cvzf /app/repo.tar.gz .

# Installer l'outil ghcr-cli
RUN zypper --non-interactive install ghcr-cli
