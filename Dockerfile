# nodejs-0-10-centos
#

FROM centos:centos7

# Pull in updates and install nodejs
RUN yum install -y --enablerepo=centosplus \
    epel-release gettext tar which gcc-c++ automake autoconf curl-devel \
    openssl-devel zlib-devel libxslt-devel libxml2-devel \
    mysql-libs mysql-devel postgresql-devel sqlite-devel && \
    yum install -y --enablerepo=centosplus nodejs npm && \
    yum clean all -y

# Add configuration files, bashrc and other tweaks
ADD ./nodejs         /opt/nodejs/
ADD ./.sti/bin/usage /opt/nodejs/bin/

# Default STI scripts url
ENV STI_SCRIPTS_URL https://raw.githubusercontent.com/openshift/nodejs-0-10-centos/master/.sti/bin

# Set up the nodejs directories
RUN mkdir -p /opt/nodejs/{run,src}

# Create nodejs group and user, set file ownership to that user.
RUN groupadd -r nodejs -g 433 && \
    useradd -u 431 -r -g nodejs -d /opt/nodejs -s /sbin/nologin -c "NodeJS user" nodejs && \
    chown -R nodejs:nodejs /opt/nodejs

ENV APP_ROOT .
ENV HOME     /opt/nodejs
ENV PATH     $HOME/bin:$PATH

WORKDIR     /opt/nodejs/src

EXPOSE 3000

CMD ["/opt/nodejs/bin/sti-helper"]
