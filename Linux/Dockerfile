FROM ubuntu:18.04

ENV AZP_URL=https://dev.azure.com/allan05
ENV AZP_TOKEN_FILE=/azp/token
ENV AZP_WORK=/vsts/_work
ENV AZP_POOL=aks-linux
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN groupadd -g 1000 azp && useradd -d /azp -u 1000 -g azp azp

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        git \
        iputils-ping \
        libcurl4 \
        libicu60 \
        libunwind8 \
        netcat \
        sudo

WORKDIR /azp

RUN echo "#{ado-pat}#" > /azp/token

COPY ./start.sh .
RUN chmod +x start.sh && chown -R azp:azp /azp

USER azp
CMD ./start.sh
