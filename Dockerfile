FROM maven:3-jdk-11-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_HOME_11_X64=${JAVA_HOME}
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes
VOLUME /mvn2m

WORKDIR /temp_pom
COPY pom.xml .
COPY src .
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        git \
        iputils-ping \
        libcurl3 \
        libicu57 \
        gnupg2 && apt-get clean

RUN mkdir -p /mvn2m/.m2/repository && mvn dependency:resolve -Dmaven.repo.local=/mvn2m/.m2/repository && \
        rm -rf /temp_pom && \
        chmod -R 777 /mvn2m

WORKDIR /azp

COPY deployment/start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]

