FROM jenkins/jenkins:lts
RUN jenkins-plugin-cli --plugins kubernetes:3636.v84b_a_1dea_6240 \
    workflow-aggregator:581.v0c46fa_697ffd \
    git:4.11.3 \
    github:1.34.3 \
    configuration-as-code:1429.v09b_044a_c93de \
    matrix-auth:3.1.2 \
    prometheus:2.0.11
