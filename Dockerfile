FROM quay.io/team-helium/validator:latest-val-amd64

EXPOSE 2154

ENV NAT_EXTERNAL_PORT 80

COPY boot.sh ./boot.sh
RUN chmod +x ./boot.sh
ENTRYPOINT ["./boot.sh"]
