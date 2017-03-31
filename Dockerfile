FROM frolvlad/alpine-glibc

ARG KUBECTL_VERSION

# Install kubectl
RUN apk add --no-cache curl ca-certificates \
 && curl -sL https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
