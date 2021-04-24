FROM quay.io/team-helium/validator:latest-val-amd64

EXPOSE 2154

ENV AWS_ACCESS_KEY=yourkey
ENV AWS_SECRET_KEY=yoursecret
ENV S3_KEY_PATH=bucket/miner/swarm_key

ENV NAT_EXTERNAL_PORT 2154

ENV AWSCLI_VERSION "1.14.10"

RUN apk add --update \
    python \
    python-dev \
    py-pip \
    build-base \
    && pip install awscli==$AWSCLI_VERSION --upgrade --user \
    && apk --purge -v del py-pip \
    && rm -rf /var/cache/apk/*

ENV PATH="/root/.local/bin/:${PATH}"

WORKDIR /opt/miner
COPY boot.sh ./boot.sh
RUN chmod +x ./boot.sh
ENTRYPOINT ["./boot.sh"]
