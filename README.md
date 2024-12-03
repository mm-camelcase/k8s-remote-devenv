//# k8s-remote-devenv
//A remote kubnetes development environment using eclipse che


# Remote Development Environment

A remote kubernetes development environment backed by [Eclipse Che](https://eclipse.dev/che/).

<a href="https://mm-camelcase.github.io/site/k8s_devenv_mini.mp4">
    <img src="assets/images/devenv.png" alt="Project Thumbnail" width="200"/>
</a>

**Click image for a [demo](https://mm-camelcase.github.io/site/k8s_devenv_mini.mp4)**


## Overview

A cloud based development environment that provides a  remote setup for developing, testing, and debugging Kubernetes-based applications. 

### Why remote?  

Remote development environments offer several key benefits  
- **Simplified Onboarding**:  Click on a link and start coding
- **Consistency**: Eliminate the "it works on my machine" problem.
- **Accessibility**: Develop from anywhere without needing a powerful local setup. All you need is a browser and an internet connection.
- **Scalability**: The remote Kubernetes cluster can scale resources as needed, providing more power for compiling and testing without taxing local machines.


### Prefer a local IDE?
Eclipse Che provides a browser-based IDE out of the box, prefer the familiarity and advanced features of your local IDE No problem! A remote workspace can be easily accessed using your local IDE, just like working with a local filesystem. This guide will walk you through setting up and configuring your local IDE to connect seamlessly with a remote Eclipse Che workspace, ensuring you get the best of both worlds: the convenience of cloud resources and the power of your preferred development environment.
(todo: review & shorten)

### Archict...

![Dev Env](assets/images/che.jpeg)

- each developer gets own environment
- controled by docker container 
- e.g. spring boot user service



## Prerequisites

This environment depends on the following tools & services:

- A Developer Sandbox a/c for Red Hat OpenShift, see  [free trial](https://developers.redhat.com/developer-sandbox?source=sso).

- Unix OS
- [Docker](https://docs.docker.com/desktop/setup/install/linux/)
- [OpenShift CLI (oc)](https://docs.redhat.com/en/documentation/openshift_container_platform/4.17/html/cli_tools/openshift-cli-oc#cli-about-cli_cli-developer-commands)

## Project setup

Each project that you wabnt to work on in the remote development environmemnt must contain a `devfile`.
define devfile
The devfile allows you to define your workspace...
- the image to run
- the endpoints to expose for development
- the comands to build test debug and run your target project

see https://github.com/mm-camelcase/user-service/blob/che/devfile.yaml for an example


## Workspace setup

The worksopce is controled by the image referenced in the devfile
All the nesessory tooling required should be installed to the workspace image.

This example uses a stripped down version of `quay.io/devfile/universal-developer-image:ubi8-latest`, see `ubi9/dockerfile`.  

```
docker build -t che-devenv-image .
docker tag che-devenv-image camelcasemm/che-devenv-image:2.0.0
docker push camelcasemm/che-devenv-image:2.0.0
```

Fore details on how to extend the base developer workspace images see https://github.com/devfile/developer-images?tab=readme-ov-file#extending-the-base-image



# oc login
DEV_WORKSPACE_NAME="user-api-example"
DEV_POD_NAME=$(oc get pods -o json | jq -r --arg prefix "$DEV_WORKSPACE_NAME" '.items[] | select(.metadata.labels["controller.devfile.io/devworkspace_name"] | startswith($prefix)) | .metadata.name')
oc port-forward "$DEV_POD_NAME" 3000:3000

To setup the development environment run:

```shell
./devenv.sh
```

The deployed services are primarily Spring Boot applications built using Gradle

For more information on the setup script, see [setup-devenv.md](docs/setup-devenv.md)


