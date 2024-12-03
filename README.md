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

## Useful complementary tools

These tools are not required but can enhance your development experience:

- [zellij](https://zellij.dev/) - Terminal multiplexer for managing multiple terminal windows.
- [k9s](https://k9scli.io/) - A terminal-based UI to interact with Kubernetes clusters.
- [kubectx](https://github.com/ahmetb/kubectx) - A tool to switch between Kubernetes contexts easily.
- [kubens](https://github.com/ahmetb/kubectx) - A tool to switch between Kubernetes namespaces.

For more information on setting up these tools, refer to [optional-tooling.md](docs/optional-tooling.md)

## How to use this development environment

### Kubernetes Dashboard

![Dev Env](assets/images/k8s-dashboard.png)

Run the following command to access the Kubernetes Dashboard:

```shell
minikube dashboard
```

Then, navigate to the provided URL.

### Deploying code

The environment uses **Skaffold** as a tool to package and deploy source code directly into the local k8s cluster. Each project contains a `skaffold.yaml` definition file that tells Skaffold how to handle local deployments (see example `skaffold.yaml` [here](https://github.com/mm-camelcase/user-service/blob/main/skaffold.yaml))

#### Deploying Pod Resources

Resource deployments use Helm-style Skaffold configs (i.e. Skaffold generates Helm install and update commands).

To deploy source code (assuming code is build first using `./gradlew clean build`) into the local cluster, run the following command from the same location as the `skaffold.yaml` definition file:

```shell
skaffold run --port-forward
```

or Skaffold can monitor your source code for changes using...

```shell
skaffold dev --port-forward
```


### Debugging code

To deploy a service in debug mode, run:

```shell
skaffold debug
```

The deploy will automatically set up a port foward for debugging on port `5005`. Configure your debugger as a remote JVM debugger (e.g. in IntelliJ):

![debugger](assets/images/debugger.jpg)

### Update the cluster

To update services to the latest available versions, simply run the setup script again. Since the script is **idempotent**, it will redeploy or update without causing conflicts.

### Delete the cluster

To remove all traces of your cluster and start over, you can run:

```shell
minikube delete
```


