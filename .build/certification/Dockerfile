FROM google/cloud-sdk:alpine

LABEL "com.github.actions.name"="cfssl"
LABEL "com.github.actions.description"="Generate & Distribute Kubernetes Certificates"
LABEL "com.github.actions.icon"="lock"
LABEL "com.github.actions.color"="orange"

LABEL "repository"="https://github.com/hreeder/k8s-the-hard-way"
LABEL "homepage"="http://github.com/hreeder/k8s-the-hard-way"
LABEL "maintainer"="Harry Reeder <harry@harryreeder.co.uk>"

RUN apk --no-cache add cfssl

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]