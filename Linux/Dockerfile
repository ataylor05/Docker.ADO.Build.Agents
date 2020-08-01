FROM ubuntu:18.04

ENV AZP_URL=https://dev.azure.com/allan05
ENV AZP_TOKEN=#{ado-pat}#
ENV AZP_WORK=/vsts/_work
ENV AZP_POOL=aks-linux
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

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
        netcat

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]
