# Utilisez une image de base openSUSE Tumbleweed
FROM opensuse/tumbleweed:latest

# Mettez à jour le système et installez les paquets supplémentaires
RUN zypper --non-interactive update && \
    zypper --non-interactive install ostree docker && \
    zypper --non-interactive install neofetch firefox

# Nettoyez le cache des paquets
RUN zypper --non-interactive clean -a

# Initialisez le référentiel OSTree
RUN ostree --repo=/srv/myrepo init --mode=archive-z2

# Copiez le système personnalisé dans un sous-répertoire
COPY . /srv/myrepo/mybranch

# Générez un commit OSTree à partir du système personnalisé
RUN ostree --repo=/srv/myrepo commit --branch=mybranch --tree=dir=/srv/myrepo/mybranch --no-xattrs --no-bindings

# Spécifiez le commit à déployer lors du démarrage du conteneur
CMD ["rpm-ostree", "deploy", "mybranch"]

# Publiez l'image sur GitHub Container Registry
ARG GHCR_REPOSITORY
ARG GHCR_TAG

RUN echo "${GHCR_TOKEN}" | docker login ghcr.io -u "${GHCR_USERNAME}" --password-stdin
RUN docker tag mybranch ghcr.io/${GHCR_REPOSITORY}:${GHCR_TAG}
RUN docker push ghcr.io/${GHCR_REPOSITORY}:${GHCR_TAG}
