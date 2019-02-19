# docker file for ansible base tools
# escape=`


# ====================================
# build application (temporary stage)
# ====================================
# base image to use
FROM alpine AS buildcontainer

# args: application settings
ARG APP_NAME="tools"
ARG APP_PATH="/opt/tools"
ARG TMP_PATH="/opt/build"

# args: core build dependencies
ARG DOCKER_OS_PACKAGES="bash curl git"

# envs: application build paths
ENV APP_NAME ${APP_NAME}
ENV APP_PATH ${APP_PATH}
ENV TMP_PATH ${TMP_PATH}

# copy build files
COPY . ${TMP_PATH}/

# switch to build dir
WORKDIR ${TMP_PATH}

# install core dependencies
RUN apk update && apk add ${DOCKER_OS_PACKAGES}

# create virtualenv
RUN /bin/bash ${TMP_PATH}/virtualenv.create.sh




# ====================================
# build production image (final stage)
# ====================================
# base image
FROM alpine
MAINTAINER Fidy Andrianaivo (fidy@andrianaivo.org)
LABEL Description="ciborg base image"

# -- set APP environments
# APP name
ARG APP_NAME="tools"
ENV APP_NAME ${APP_NAME}
# APP base path
ARG APP_PATH="/opt/tools"
ENV APP_PATH ${APP_PATH}

# -- set SYS environments
# APP core dependencies
ARG DOCKER_OS_PACKAGES="bash curl git monit python3 tzdata"
# SYS timezone
ARG TZ="Europe/Vienna"
ENV TZ ${TZ}
# SYS path
ENV PATH ${PATH}:${APP_PATH}/bin

# setup application dependencies
RUN apk update \
  && apk add ${DOCKER_OS_PACKAGES} \
  && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone

# get final application release
COPY --from=buildcontainer ${APP_PATH} ${APP_PATH}/

# use wrapper script as entrypoint
ENTRYPOINT ["run.sh"]


# eof
