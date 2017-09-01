FROM ruby

ENV TERRAFORM_SHORT_VERSION 0.9.11
ENV TERRAFORM_VERSION terraform_${TERRAFORM_SHORT_VERSION}
ENV MONGO_VERSION 3.4

# Mongo
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
    echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/${MONGO_VERSION} main" | tee /etc/apt/sources.list.d/mongodb-org-${MONGO_VERSION}.list

RUN apt-get -y -q update && \
    apt-get -y -q install wget unzip mongodb-org-shell jq python-setuptools python-dev build-essential && \
    apt-get clean

# AWS CLI
RUN easy_install pip && \
    pip install awscli

RUN gem update --system --no-ri --no-rdoc && \
    gem install bundler --no-ri --no-rdoc

# terraform
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_SHORT_VERSION}/${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip ${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/bin/

