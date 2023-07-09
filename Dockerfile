# Utilisez une image de base openSUSE Tumbleweed
FROM opensuse/tumbleweed:latest

# Mettez à jour le système et installez les paquets supplémentaires
RUN zypper --non-interactive update && \
    zypper --non-interactive install <paquet1> <paquet2>

# Nettoyez le cache des paquets
RUN zypper --non-interactive clean -a

# Initialisez le référentiel OSTree
RUN ostree init --repo=/srv/myrepo

# Générez un commit OSTree à partir du système personnalisé
RUN rpm-ostree commit --repo=/srv/myrepo --branch=mybranch container:/ /

# Spécifiez le commit à déployer lors du démarrage du conteneur
CMD ["rpm-ostree", "deploy", "mybranch"]

# Publiez l'image sur GitHub Container Registry
ARG GHCR_USERNAME
ARG GHCR_REPOSITORY
ARG GHCR_TAG

RUN echo "${GHCR_TOKEN}" | docker login ghcr.io -u "${GHCR_USERNAME}" --password-stdin
RUN docker tag mybranch ghcr.io/${GHCR_USERNAME}/${GHCR_REPOSITORY}:${GHCR_TAG}
RUN docker push ghcr.io/${GHCR_USERNAME}/${GHCR_REPOSITORY}:${GHCR_TAG}
