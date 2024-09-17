# DHBW Tube

## Anwendungsbeschreibung
DHBW-Tube ist eine standortübergreifende Web-Videoplattform zum Austausch von nutzergenerierten Inhalten für Studierende und Mitarbeiter der Dualen Hochschule Baden-Württemberg.
Nutzer können auf dem Portal kostenlos Videoclips suchen, ansehen und hochladen.
Dozenten können zum Beispiel Vorlesungsaufzeichnungen hochladen, die dann von Studierenden, die krankheitsbedingt abwesend sind oder zur Prüfungsvorbereitung wiederholt werden, angesehen werden können.
Auf der anderen Seite haben Studierende die Möglichkeit, eigene Lernvideos zu Vorlesungsinhalten aufzunehmen und mit ihren Kommilitonen zu teilen.
So können auch Studierende verschiedener Fachrichtungen und DHBW-Standorte ihr Wissen campusübergreifend austauschen.
Die Videos können werbefrei von verschiedenen Geräten über den Webbrowser auf der dezentralen Plattform gestreamt werden und bleiben auch für nachfolgende Semester erhalten.
Die Anwendung wurde mit dem Ziel der Datenminimierung entwickelt und erfordert keine aufwändige Registrierung zum Hochladen von Inhalten.

<br>

## Anwendungsstruktur
Die DHBW-Tube Anwendung besteht aus den drei folgenden Microservices, die in einer Kubernetes-Umgebung bereitgestellt werden:
- Frontend: Die Benutzeroberfläche der Anwendung, die es Benutzern ermöglicht, Videos zu suchen, anzusehen und hochzuladen.
- Stream: Der Streaming-Service, der das Streamen von Videos und Aufrufen von Metadaten ermöglicht.
- Upload: Der Upload-Service, der das Hochladen von Videos ermöglicht.

Dieses Respository enthält die Kubernetes-Ressourcen, die für die Bereitstellung der Anwendung in einer Kubernetes-Umgebung erforderlich sind.

Der Quellcode der Microservices hingegen ist in drei Repositories aufgeteilt, wodurch die Microservices unabhängig voneinander entwickelt werden können.
Um die Kubernetes-Umgebung aufzusetzen, sollten demnach die drei Repositories geklont werden. Mit den folgenden Befehlen können die Repositories geklont werden: 
```bash
git clone https://github.com/cy-rae/dhbw-tube-frontend.git
git clone https://github.com/cy-rae/dhbw-tube-upload.git
git clone https://github.com/cy-rae/dhbw-tube-stream.git
```
In den Repositories der Microservices finden Sie weitere README-Dateien, die die Microservices beschreiben.
In dieser README-Datei finden Sie die Anweisungen zum Starten der Anwendung und Beschreibungen der Kubernetes Umgebung.

<br>

## Voraussetzungen
Um die Anwendung (im Entwicklungsmodus) zu starten, müssen die folgenden Tools und Software-Komponenten auf Ihrem System installiert sein:
- **Minikube**:
Minikube wird benötigt, um eine lokale Kubernetes-Umgebung zu erstellen und zu verwalten. Installieren Sie [Minikube](https://kubernetes.io/de/docs/tasks/tools/install-minikube/) gemäß der offiziellen Anleitung.
- **Kubectl**:
Kubectl ist das Kommandozeilenwerkzeug zur Interaktion mit Kubernetes-Clustern. Falls kubectl nicht mit Minikube installiert wird, können Sie es separat von der [Kubernetes-Website](https://kubernetes.io/de/docs/tasks/tools/install-kubectl/) herunterladen und installieren.
- **Skaffold**:
Skaffold wird verwendet, um die Entwicklungs- und Bereitstellungszyklen in Kubernetes zu automatisieren. Installieren Sie [Skaffold](https://skaffold.dev/docs/install/) gemäß der offiziellen Anleitung.
- **Helm**:
Helm ist ein Paketmanager für Kubernetes, der das Verwalten von Anwendungen erleichtert. Installieren Sie [Helm](https://helm.sh/docs/intro/install/) gemäß der offiziellen Anleitung.
- **Docker Desktop**:
Docker wird verwendet, um Container-Images zu erstellen und zu verwalten. Installieren Sie [Docker Desktop](https://www.docker.com/products/docker-desktop/) gemäß der offiziellen Anleitung.
Vergewissern Sie sich, dass alle oben genannten Komponenten korrekt installiert und in Ihrem Systempfad verfügbar sind, um die Anwendung erfolgreich zu starten und zu entwickeln.

<br>

## Starten der Anwendung
Um die Anwendung zu starten, öffnen Sie Docker Desktop und stellen Sie sicher, dass die Docker Engine läuft. 
Führen Sie anschließend einen der folgenden Befehle aus:
#### Unter MacOS / Linux:
```bash
bash run-dhbw-tube.sh
```

#### Unter Windows:
```shell
powershell -File run-dhbw-tube.ps1
```

<p style="margin-top: 40px"></p>

Diese Befehle führen jeweils ein Skript aus, das die Einrichtung einer Kubernetes-Umgebung unter Verwendung von Minikube, Skaffold und Helm automatisiert. Folgende Schritte werden im Skript ausgeführt:
1. **Minikube starten**: Das Skript prüft, ob Minikube bereits läuft. Falls nicht, wird Minikube gestartet.
2. **Namespace löschen**: Falls der Namespace **dhbw-tube** bereits existiert, wird er gelöscht. Das Skript wartet, bis der Namespace vollständig entfernt ist, um eine saubere Umgebung sicherzustellen. 
3. **Kubernetes-Umgebung erstellen**: Das Skript verwendet **skaffold**, um die Kubernetes-Umgebung gemäß der Konfiguration in der Datei **skaffold.yaml** zu erstellen. 
4. **Prometheus-Helm-Repository hinzufügen**: Das Skript überprüft, ob das **Prometheus-Helm-Repository** bereits hinzugefügt wurde. Falls nicht, wird es hinzugefügt und die Helm-Repositories werden aktualisiert. 
5. **Grafana-Helm-Repository hinzufügen**: Das Skript überprüft, ob das **Grafana-Helm-Repository** bereits hinzugefügt wurde. Falls nicht, wird es hinzugefügt und die Helm-Repositories werden aktualisiert. 
6. **Prometheus und Grafana installieren**: Das Skript installiert Prometheus und Grafana im Namespace dhbw-tube mit den angegebenen Konfigurationen. 
7. **Minikube-Tunnel starten**: Das Skript startet den Minikube-Tunnel, um den Zugriff auf die Dienste in Minikube zu ermöglichen. Möglicherweise müssen Sie Ihr Admin-Passwort eingeben, um den Tunnel zu starten.

Sobald alle Ressourcen erfolgreich bereitgestellt wurden, kann die Anwendung über [localhost](http://localhost) aufgerufen werden.

Um sicherzustellen, dass alle Ressourcen vollständig bereitgestellt sind, können Sie den Status der Ressourcen mit dem folgenden Befehl überprüfen:
```bash
kubectl get all -n dhbw-tube
```

<p style="margin-top: 40px"></p>

Falls Sie auf die Benutzeroberflächen von Prometheus und/oder Grafana zugreifen möchten, können Sie die Port-Forwards für die jeweiligen Services mit den folgenden Befehlen einrichten:
#### Prometheus:
```
kubectl port-forward svc/prometheus-server 8888:80 -n dhbw-tube
```
#### Grafana:
```
kubectl port-forward svc/grafana 9999:80 -n dhbw-tube
```
Daraufhin können Sie Prometheus unter [localhost:8888](http://localhost:8888) und Grafana unter [localhost:9999](http://localhost:9999) aufrufen. 

<br>

## Starten der Anwendung im Entwicklungsmodus
Um die Anwendung im Entwicklungsmodus zu starten, öffnen Sie Docker Desktop und stellen Sie sicher, dass die Docker Engine läuft. 
Führen Sie anschließend einen der folgenden Befehle aus:
#### Unter MacOS / Linux:
```bash
bash run-dhbw-tube-dev.sh
```
#### Unter Windows:
```shell
powershell -File run-k8s-dev.ps1
```

<p style="margin-top: 40px"></p>

Diese Befehle führen jeweils ein Skript aus, das die Einrichtung einer Kubernetes-Umgebung unter Verwendung von Minikube, Helm und Skaffold automatisiert. Folgende Schritte werden durchgeführt:
2. **Minikube starten**:
Das Skript überprüft, ob Minikube bereits läuft. Falls Minikube nicht ausgeführt wird, wird es gestartet.
2. **Namespace löschen**:
Falls der Namespace **dhbw-tube** bereits existiert, wird er gelöscht, um eine saubere Umgebung zu gewährleisten. Das Skript wartet, bis der Namespace vollständig entfernt ist, bevor es fortfährt.
3. **Prometheus Helm-Repository hinzufügen**:
Das Skript prüft, ob das **Prometheus-Helm-Repository** bereits hinzugefügt wurde. Falls nicht, wird das Repository hinzugefügt und die Helm-Repositories werden aktualisiert.
4. **Grafana Helm-Repository hinzufügen**:
Das Skript prüft, ob das **Grafana-Helm-Repository** bereits hinzugefügt wurde. Falls nicht, wird das Repository hinzugefügt und die Helm-Repositories werden aktualisiert.
5. **Kubernetes-Umgebung erstellen**:
Das Skript verwendet Skaffold, um die Kubernetes-Umgebung gemäß der Konfiguration in der Datei skaffold.yaml zu erstellen.

Das Skript führt den Befehl `skaffold dev` aus, der das Terminal für die Dauer des Entwicklungsprozesses mit Protokoll- und Statusmeldungen füllt. 
Während dieses Vorgangs wird das Terminal blockiert, da skaffold dev kontinuierlich im Hintergrund läuft und die Umgebung überwacht.
Außerdem reagiert skaffold dev auf Änderungen im Quellcode und aktualisiert die Container-Images und relevanten Kubernetes Ressourcen entsprechend.

Um auf die Anwendung über [localhost](http://localhost) zugreifen zu können, muss zusätzlich der Befehl `minikube tunnel` ausgeführt werden.
Dieser Befehl richtet einen Tunnel ein, der den Zugriff auf Dienste innerhalb der Minikube-Umgebung ermöglicht.

<p style="margin-top: 40px"></p>

Es ist wichtig zu beachten, dass Prometheus und Grafana nicht automatisch hinzugefügt werden, wenn Sie `skaffold dev` verwenden.
Der Grund dafür ist, dass skaffold dev eventuell die bereits vorhandenen Helm-Releases deinstallieren könnte.
Die Helm-Repositories für Prometheus und Grafana werden jedoch hinzugefügt, damit Sie diese Dienste bei Bedarf manuell installieren können.
Um Prometheus und Grafana hinzuzufügen, können Sie die folgenden Befehle verwenden:

```
helm install prometheus prometheus-community/prometheus \
  --namespace dhbw-tube \
  --set server.global.scrape_interval="15s"
helm install grafana grafana/grafana \
  --namespace dhbw-tube \
  --set adminPassword="admin"
```

Um auf die Benutzeroberflächen von Prometheus und Grafana zuzugreifen, können Sie die Port-Forwards für die jeweiligen Services mit den folgenden Befehlen einrichten:
#### Prometheus:
```
kubectl port-forward svc/prometheus-server 8888:80 -n dhbw-tube
```
#### Grafana:
```
kubectl port-forward svc/grafana 9999:80 -n dhbw-tube
```
Daraufhin können Sie Prometheus unter [localhost:8888](http://localhost:8888) und Grafana unter [localhost:9999](http://localhost:9999) aufrufen.

<br>

## Kubernetes Umgebung
