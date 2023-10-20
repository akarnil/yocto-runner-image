#!/bin/bash
ORGANIZATION=$ORGANIZATION
ACCESS_TOKEN=$ACCESS_TOKEN
USER=$USER
REPO=$REPO


cd /home/docker/actions-runner

# For use with orgs ie avnet-iotconnect
if [ -z "$ORGANIZATION" ]
then
    REG_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/orgs/${ORGANIZATION}/actions/runners/registration-token | jq .token --raw-output)
    ./config.sh --url https://github.com/${ORGANIZATION} --token ${REG_TOKEN} --labels yocto,x64,linux
else
    REG_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/repos/${USER}/${REPO}/actions/runners/registration-token | jq .token --raw-output)
    ./config.sh --url https://github.com/${USER}/${REPO} --token ${REG_TOKEN} --labels yocto,x64,linux
fi

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
