[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
# Glasslabs Yocto Runner image recipe
Docker Image recipe for generating a self-hosted Github organization runner capable of building a Yocto Linux rootfs

### Using this Docker image
This image can be retrived from Docker hub and used to create a new container.
```console
sudo docker pull akarnil/iotc-python:latest
```

The yocto-runner image utilizes a GitHub PAT to request a runner token from Github. A PAT can be generated by going to ```Settings > Developer Settings > Personal access tokens``` on Github. The token needs to have ```repo```, ```workflow``` and ```admin:org``` access rights. Record the token and keep it in a safe place.

Once you have your token, we can spool up our container using the newly retrieved docker image. You can set the ```name``` to whatever you'd like to call your container.
```console
# creates a docker volume on the host called cache-yocto to store downloads and sstate
# github-token is stored as a file here

sudo docker run -d \
--env ACCESS_TOKEN=$(cat ~/github-token) \
--env USER=<YOUR-GITHUB-USER> \
--env REPO=<YOUR-GITHUB-REPO> \
-v cache-yocto:/mnt/resource:Z \
--name runner akarnil/iotc-python

# if using org environment, note that the start.sh must be modified to use the correct REG_TOKEN and ./config lines
sudo docker run -d \
--env ORGANIZATION=<YOUR-GITHUB-ORGANIZATION> \
--env ACCESS_TOKEN=<YOUR-GITHUB-ACCESS-TOKEN> \
-v cache-yocto:/mnt/resource:Z \
--name runner akarnil/iotc-python
```

You can verify the status of the runner by executing the following.
```console
sudo docker logs runner -f
```

You should see something similar to the output below:
```console
--------------------------------------------------------------------------------
|        ____ _ _   _   _       _          _        _   _                      |
|       / ___(_) |_| | | |_   _| |__      / \   ___| |_(_) ___  _ __  ___      |
|      | |  _| | __| |_| | | | | '_ \    / _ \ / __| __| |/ _ \| '_ \/ __|     |
|      | |_| | | |_|  _  | |_| | |_) |  / ___ \ (__| |_| | (_) | | | \__ \     |
|       \____|_|\__|_| |_|\__,_|_.__/  /_/   \_\___|\__|_|\___/|_| |_|___/     |
|                                                                              |
|                       Self-hosted runner registration                        |
|                                                                              |
--------------------------------------------------------------------------------

# Authentication


√ Connected to GitHub

# Runner Registration

Enter the name of the runner group to add this runner to: [press Enter for Default]
Enter the name of runner: [press Enter for 332d0614b5e9]
This runner will have the following labels: 'self-hosted', 'Linux', 'X64'
Enter any additional labels (ex. label-1,label-2): [press Enter to skip]
√ Runner successfully added
√ Runner connection is good

# Runner settings

Enter name of work folder: [press Enter for _work]
√ Settings Saved.


√ Connected to GitHub

2021-10-23 22:36:01Z: Listening for Jobs
```

You are now ready to utilize your Yocto build runner in your own repositories/workflows. See [here](https://docs.github.com/en/actions/hosting-your-own-runners/using-self-hosted-runners-in-a-workflow) for more information on how to use a self-hosted runner in your repository workflow files

### Building this image
To begin building this image you will need to have Docker installed. You can find setup guides for various platforms [here](https://docs.docker.com/get-docker/). Once installed we can begin the build process. To build the docker image execute the following the command below
```console
sudo docker build -t akarnil/iotc-python:latest .
```


### Pushing this image
You will need your own docker hub account for this
```console
docker login #first
docker push akarnil/iotc-python:latest
```
