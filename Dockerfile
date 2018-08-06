FROM ubuntu

ENV TERRAFORM_VERSION=0.11.7
ENV TERRAFORM_SHA256SUM=6b8ce67647a59b2a3f70199c304abca0ddec0e49fd060944c26f666298e23418

ENV GRAYLOG_PROVIDER_VERSION=0.5.0
ENV GRAYLOG_PROVIDER_SHA256SUM=d15940bc8164f7881b550ac53f1c4c7602f02075988f0bb7dba73a7b53c41af4

RUN apt-get update && apt-get install --yes git curl zip && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sha256sum --check --status terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN curl -L https://github.com/rafaeljesus/go-graylog/releases/download/v${GRAYLOG_PROVIDER_VERSION}/terraform-provider-graylog_v${GRAYLOG_PROVIDER_VERSION}_linux_amd64.gz > terraform-provider-graylog_v${GRAYLOG_PROVIDER_VERSION}_linux_amd64.gz && \
    echo "${GRAYLOG_PROVIDER_SHA256SUM}  terraform-provider-graylog_v${GRAYLOG_PROVIDER_VERSION}_linux_amd64.gz" > terraform-provider-graylog_v${GRAYLOG_PROVIDER_VERSION}_SHA256SUMS && \
    sha256sum --check --status terraform-provider-graylog_v${GRAYLOG_PROVIDER_VERSION}_SHA256SUMS && \
    gzip -d terraform-provider-graylog_v${GRAYLOG_PROVIDER_VERSION}_linux_amd64.gz && \
    mkdir -p ~/.terraform.d/plugins && \
    mv terraform-provider-graylog_v${GRAYLOG_PROVIDER_VERSION}_linux_amd64 ~/.terraform.d/plugins/terraform-provider-graylog_v${GRAYLOG_PROVIDER_VERSION} && \
    chmod +x ~/.terraform.d/plugins/terraform-provider-graylog_v${GRAYLOG_PROVIDER_VERSION}
