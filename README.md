# DHBW Tube
This project contains a command file to clone the DHBW Tube microservices and all necessary kubernetes files to deploy the solution. 

### Clone all repositories
```bash
git clone https://github.com/cy-rae/dhbw-tube-frontend.git
git clone https://github.com/cy-rae/dhbw-tube-upload.git
git clone https://github.com/cy-rae/dhbw-tube-stream.git
```

### Anwendung starten
Um die Anwendung / die Kubernetes Umgebung zu starten, führen Sie folgenden Befehl aus:
```bash
bash start-k8s.sh
```


### Application description
DHBW-Tube is a cross-location web video platform for sharing user-generated content for students and employees of the Baden-Württemberg Cooperative State University. Users can search, view, comment on and upload video clips on the portal free of charge. For example, lecturers can upload lecture recordings, which can then be watched by students who are absent due to illness or repeated to prepare for exams. On the other hand, students have the opportunity to record their own learning videos on lecture content and share them with their fellow students. The comments allow viewers to add further information, ask questions about the content and evaluate the quality of the video in terms of the learning effect. This also allows students from different disciplines and DHBW locations to exchange knowledge across the different campuses. The videos can be streamed ad-free from various devices via the web browser on the decentralized platform and are also retained for subsequent semesters. The application was developed with the aim of data minimization and does not require complex registration for uploading content.
