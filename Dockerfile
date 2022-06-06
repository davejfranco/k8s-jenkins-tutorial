FROM jenkins/jenkins:lts
RUN jenkins-plugin-cli --plugins kubernetes \
    workflow-aggregator \
    git \
    github \
    configuration-as-code \
    matrix-auth \
    prometheus
