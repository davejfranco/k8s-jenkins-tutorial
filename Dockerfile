FROM jenkins/jenkins:lts
RUN jenkins-plugin-cli --plugins kubernetes workflow-aggregator git configuration-as-code matrix-auth:3.1.2
