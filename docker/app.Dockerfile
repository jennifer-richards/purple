FROM ghcr.io/ietf-tools/rpc-app-base:latest
LABEL maintainer="IETF Tools Team <tools-discuss@ietf.org>"

ENV DEBIAN_FRONTEND=noninteractive

# Install needed packages and setup non-root user.
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID
COPY docker/scripts/app-setup.sh /tmp/library-scripts/docker-setup.sh
RUN sed -i 's/\r$//' /tmp/library-scripts/docker-setup.sh && chmod +x /tmp/library-scripts/docker-setup.sh
RUN bash /tmp/library-scripts/docker-setup.sh "${USERNAME}" "${USER_UID}" "${USER_GID}"

COPY docker/configs/.tmux.conf /home/dev/.tmux.conf

# Copy the startup file
COPY docker/scripts/app-init.sh /docker-init.sh
COPY docker/scripts/app-start.sh /docker-start.sh
RUN sed -i 's/\r$//' /docker-init.sh && chmod +x /docker-init.sh
RUN sed -i 's/\r$//' /docker-start.sh && chmod +x /docker-start.sh

# Fix user UID / GID to match host
RUN groupmod --gid $USER_GID $USERNAME \
    && usermod --uid $USER_UID --gid $USER_GID $USERNAME \
    && chown -R $USER_UID:$USER_GID /home/$USERNAME \
    || exit 0

# Switch to local dev user
USER dev:dev

# Install current python dependencies
COPY requirements.txt /tmp/pip-tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install --user --no-warn-script-location -r /tmp/pip-tmp/requirements.txt
RUN pip3 --disable-pip-version-check --no-cache-dir install --user --no-warn-script-location pylint pylint-common pylint-django
RUN sudo rm -rf /tmp/pip-tmp
