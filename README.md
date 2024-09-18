# DHBW Tube

## Application Description
DHBW-Tube is a cross-location web video platform for the exchange of user-generated content for students and employees of the Baden-Württemberg Cooperative State University.
Users can search, view, and upload video clips on the portal for free.
Lecturers can upload lecture recordings, which can then be viewed by students who are absent due to illness or for exam preparation.
On the other hand, students have the opportunity to record their own learning videos on lecture content and share them with their fellow students.
The video description enables the video creators to add further information, provide suitable exercises and give further tips for successful learning. 
With DHBW-Tube, students from different disciplines and DHBW locations can exchange knowledge across campuses.
The videos can be streamed ad-free from various devices via the web browser on the decentralized platform and remain available for subsequent semesters.
The application was developed with the aim of minimizing data and does not require time-consuming registration to upload content.

<br>

## Application Structure
The DHBW-Tube application consists of the following three microservices, which are deployed in a Kubernetes environment:
- Frontend: The user interface of the application, which allows users to search, view, and upload videos.
- Stream: The streaming service that enables video streaming and metadata retrieval.
- Upload: The upload service that enables video uploads.

This repository contains the Kubernetes resources required to deploy the application in a Kubernetes environment.

The source code of the microservices, on the other hand, is divided into three repositories, allowing the microservices to be developed independently.
To set up the Kubernetes environment, the three repositories should be cloned. The following commands can be used to clone the repositories:
```bash
git clone https://github.com/cy-rae/dhbw-tube-frontend.git
git clone https://github.com/cy-rae/dhbw-tube-upload.git
git clone https://github.com/cy-rae/dhbw-tube-stream.git
```
In the repositories of the microservices, you will find additional README files that describe the microservices.
In this README file, you will find instructions for starting the application and descriptions of the Kubernetes environment.

<br>

## Prerequisites
To start the application (in development mode), the following tools and software components must be installed on your system:
- **Minikube**:
Minikube is required to create and manage a local Kubernetes environment. Install [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/) according to the official instructions.
- **Kubectl**:
Kubectl is the command-line tool for interacting with Kubernetes clusters. If kubectl is not installed with Minikube, you can download and install it separately from the [Kubernetes website](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
- **Skaffold**:
Skaffold is used to automate development and deployment cycles in Kubernetes. Install [Skaffold](https://skaffold.dev/docs/install/) according to the official instructions.
- **Helm**:
Helm is a package manager for Kubernetes that makes it easier to manage applications. Install [Helm](https://helm.sh/docs/intro/install/) according to the official instructions.
- **Docker Desktop**:
Docker is used to build and manage container images. Install [Docker Desktop](https://www.docker.com/products/docker-desktop/) according to the official instructions.
Make sure all the above components are correctly installed and available in your system path to successfully start and develop the application.

<br>

## Starting the Application
To start the application, open Docker Desktop and make sure the Docker Engine is running. 
Then, execute one of the following commands:
#### On MacOS / Linux:
```bash
bash run-dhbw-tube.sh
```
#### On Windows:
```shell
powershell -File run-dhbw-tube.ps1
```

<p style="margin-top: 40px"></p>

These commands each execute a script that automates the setup of a Kubernetes environment using Minikube, Skaffold, and Helm. The script performs the following steps:
1. **Start Minikube**: The script checks if Minikube is already running. If Minikube is not running, it starts Minikube.
2. **Delete Namespace**: If the **dhbw-tube** namespace already exists, it is deleted. The script waits until the namespace is completely removed to ensure a clean environment.
3. **Create Kubernetes Environment**: The script uses **skaffold** to create the Kubernetes environment according to the configuration in the **skaffold.yaml** file.
4. **Add Prometheus Helm Repository**: The script checks if the **Prometheus Helm Repository** has already been added. If not, it adds the repository and updates the Helm repositories.
5. **Add Grafana Helm Repository**: The script checks if the **Grafana Helm Repository** has already been added. If not, it adds the repository and updates the Helm repositories.
6. **Install Prometheus and Grafana**: The script installs Prometheus and Grafana in the **dhbw-tube** namespace with the specified configurations.
7. **Start Minikube Tunnel**: The script starts the Minikube tunnel to allow access to the services in Minikube. You may need to enter your admin password to start the tunnel.

As soon as all resources have been successfully deployed, the application can be accessed via [localhost](http://localhost).

To ensure that all resources are fully deployed, you can check the status of the resources with the following command:
```
kubectl get all -n dhbw-tube
```

<p style="margin-top: 40px"></p>

If you want to access the Prometheus and/or Grafana user interfaces, you can set up the port forwards for the respective services with the following commands:
#### Prometheus:
```
kubectl port-forward svc/prometheus-server 8888:80 -n dhbw-tube
```
#### Grafana:
```
kubectl port-forward svc/grafana 9999:80 -n dhbw-tube
```
You can then access Prometheus at [localhost:8888](http://localhost:8888) and Grafana at [localhost:9999](http://localhost:9999).

<br>

## Starting the Application in Development Mode
To start the application in development mode, open Docker Desktop and make sure the Docker Engine is running. 
Then, execute one of the following commands:
#### On MacOS / Linux:
```bash
bash run-dhbw-tube-dev.sh
```
#### On Windows:
```shell
powershell -File run-k8s-dev.ps1
```

<p style="margin-top: 40px"></p>

These commands each execute a script that automates the setup of a Kubernetes environment using Minikube, Helm, and Skaffold. The script performs the following steps:
1. **Start Minikube**: 
The script checks if Minikube is already running. If Minikube is not running, it starts Minikube.
2. **Delete Namespace**:
If the **dhbw-tube** namespace already exists, it is deleted. The script waits until the namespace is completely removed to ensure a clean environment.
3. **Add Prometheus Helm Repository**:
The script checks if the **Prometheus Helm Repository** has already been added. If not, it adds the repository and updates the Helm repositories.
4. **Add Grafana Helm Repository**:
The script checks if the **Grafana Helm Repository** has already been added. If not, it adds the repository and updates the Helm repositories.
5. **Create Kubernetes Environment**:
The script uses Skaffold to create the Kubernetes environment according to the configuration in the **skaffold.yaml** file.

The script executes the command `skaffold dev`, which fills the terminal with log and status messages for the duration of the development process.
During this process, the terminal is blocked because skaffold dev runs continuously in the background, monitoring the environment.
In addition, skaffold dev responds to changes in the source code and updates the container images and relevant Kubernetes resources accordingly.

To access the application via [localhost](http://localhost), the command `minikube tunnel` must be executed in addition.
This command sets up a tunnel that allows access to services within the Minikube environment.

<p style="margin-top: 40px"></p>

It is important to note that Prometheus and Grafana are not automatically added when using `skaffold dev`.
The reason for this is that skaffold dev may uninstall existing Helm releases.
However, the Helm repositories for Prometheus and Grafana are added so that you can manually install these services if needed.
To add Prometheus and Grafana, you can use the following commands:
```
helm install prometheus prometheus-community/prometheus \
  --namespace dhbw-tube \
  --set server.global.scrape_interval="15s"
helm install grafana grafana/grafana \
  --namespace dhbw-tube \
  --set adminPassword="admin"
```

To access the Prometheus and Grafana user interfaces, you can set up the port forwards for the respective services with the following commands:
#### Prometheus:
```
kubectl port-forward svc/prometheus-server 8888:80 -n dhbw-tube
```
#### Grafana:
```
kubectl port-forward svc/grafana 9999:80 -n dhbw-tube
```
You can then access Prometheus at [localhost:8888](http://localhost:8888) and Grafana at [localhost:9999](http://localhost:9999).

<br>

## Kubernetes environment:
