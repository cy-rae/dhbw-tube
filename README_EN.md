# DHBW Tube
The DHBW-Tube application consists of the following three microservices, which are deployed in a Kubernetes environment:
- Frontend: The application's user interface that allows users to search, view and upload videos.
- Stream: The streaming service that allows streaming of videos and retrieval of metadata.
- Upload: The upload service that allows videos to be uploaded.

## Repositories
This repository contains the Kubernetes resources required to deploy the application in a Kubernetes environment.

The source code of the microservices, on the other hand, is divided into three repositories.
To set up the Kubernetes environment, the three repositories should therefore be cloned. The repositories can be cloned using the following commands: 
```bash
git clone https://github.com/cy-rae/dhbw-tube-frontend.git
git clone https://github.com/cy-rae/dhbw-tube-upload.git
git clone https://github.com/cy-rae/dhbw-tube-stream.git
```

## Start application
To start the application, execute the following command:
#### Under MacOS / Linux:
```bash
bash start-k8s.sh
```

#### Under Windows:
```shell
powershell -File start-k8s.ps1
```

This command executes a script that sets up the Kubernetes environment. The following steps are carried out:
1. **Check and start Minikube**: The script checks if Minikube is already running. If not, Minikube is started.
2. **Namespace management**: If the namespace _dhbw-tube_ already exists, it is deleted. The script waits until the namespace is completely removed to ensure a clean environment.
3. **Activate the Ingress addon**: The ingress addon is activated to enable HTTP and HTTPS access to the services in the cluster.
4. **Creating the Docker images**: Docker images for the various components (_Frontend_, _Stream_, _Upload_, _MinIO_) are created. Before this, the script switches to the Minikube Docker environment context to ensure that the images are available in the Minikube cluster.
5. **Creating the namespace**: The _dhbw-tube_ namespace is created to isolate the application's resources.
6. **Applying ConfigMaps**: ConfigMaps are applied to provide configurations for _PostgreSQL_, _MinIO_, _Upload_, _Stream_ and _Frontend_.
7. **Creating Persistent Volume Claims**: Persistent Volume Claims are created to request storage for _PostgreSQL_ and _MinIO_.
8. **Applying Deployments**: Deployments are created to manage the various components of the application.
9. **Configuring services**: Services are configured to provide access to the pods.
10. **Applying the Ingress resource**: The ingress resource is applied to allow external access to the services.
11. **Starting the minicube tunnel**: A minikube tunnel is started to enable access to the application via localhost.

As a Minikube tunnel is started in the last step, the admin password may need to be entered.
If all resources have been successfully provided, the application can be accessed via [localhost](http://localhost).

To ensure that the application has been fully deployed, the status of the resources can be checked using the following command:
```bash
kubectl get all -n dhbw-tube
```
```bash
kubectl get ingress -n dhbw-tube
```

## Application description
DHBW-Tube is a cross-location web video platform for sharing user-generated content for students and employees of the Baden-Württemberg Cooperative State University. 
Users can search, view and upload video clips on the portal free of charge. 
For example, lecturers can upload lecture recordings, which can then be watched by students who are absent due to illness or repeated to prepare for exams.
On the other hand, students have the opportunity to record their own learning videos on lecture content and share them with their fellow students.
This also allows students from different disciplines and DHBW locations to exchange knowledge across the different campuses.
The videos can be streamed ad-free from various devices via the web browser on the decentralized platform and are also retained for subsequent semesters.
The application was developed with the aim of data minimization and does not require complex registration for uploading content.
