# DHBW Tube
Die DHBW-Tube Anwendung besteht aus den drei folgenden Microservices, die in einer Kubernetes-Umgebung bereitgestellt werden:
- Frontend: Die Benutzeroberfläche der Anwendung, die es Benutzern ermöglicht, Videos zu suchen, anzusehen und hochzuladen.
- Stream: Der Streaming-Service, der das Streamen von Videos und Aufrufen von Metadaten ermöglicht.
- Upload: Der Upload-Service, der das Hochladen von Videos ermöglicht.

## Repositories
Dieses Respository enthält die Kubernetes-Ressourcen, die für die Bereitstellung der Anwendung in einer Kubernetes-Umgebung erforderlich sind.

Der Quellcode der Microservices hingegen ist in drei Repositories aufgeteilt.
Um die Kubernetes-Umgebung aufzusetzen, sollten demnach die drei Repositories geklont werden. Mit den folgenden Befehlen können die Repositories geklont werden: 
```bash
git clone https://github.com/cy-rae/dhbw-tube-frontend.git
git clone https://github.com/cy-rae/dhbw-tube-upload.git
git clone https://github.com/cy-rae/dhbw-tube-stream.git
```

## Anwendung starten
Um die Anwendung zu starten, führen Sie den folgenden Befehl aus:
#### Unter MacOS / Linux:
```bash
bash start-k8s.sh
```

#### Unter Windows:
```shell
powershell -File start-k8s.ps1
```

Dieser Befehl führt ein Skript aus, das die Kubernetes-Umgebung einrichtet. Dabei werden die folgenden Schritte durchgeführt:
1. **Überprüfen und Starten von Minikube**: Das Skript prüft, ob Minikube bereits läuft. Falls nicht, wird Minikube gestartet.
2. **Namespace-Verwaltung**: Falls der Namespace _dhbw-tube_ bereits existiert, wird er gelöscht. Das Skript wartet, bis der Namespace vollständig entfernt ist, um eine saubere Umgebung sicherzustellen.
3. **Aktivieren des Ingress-Addons**: Das Ingress-Addon wird aktiviert, um den HTTP- und HTTPS-Zugriff auf die Services im Cluster zu ermöglichen.
4. **Erstellen der Docker-Images**: Docker-Images für die verschiedenen Komponenten (_Frontend_, _Stream_, _Upload_, _MinIO_) werden erstellt. Zuvor wechselt das Skript in den Minikube-Docker-Umgebungskontext, um sicherzustellen, dass die Images im Minikube-Cluster verfügbar sind.
5. **Erstellen des Namespaces**: Der Namespace _dhbw-tube_ wird erstellt, um die Ressourcen der Anwendung zu isolieren.
6. **Anwenden von ConfigMaps**: ConfigMaps werden angewendet, um Konfigurationen für _PostgreSQL_, _MinIO_, _Upload_, _Stream_ und _Frontend_ bereitzustellen.
7. **Erstellen von Persistent Volume Claims**: Persistent Volume Claims werden erstellt, um Speicher für _PostgreSQL_ und _MinIO_ anzufordern.
8. **Anwenden von Deployments**: Deployments werden erstellt, um die verschiedenen Komponenten der Anwendung zu verwalten.
9. **Konfigurieren von Services**: Services werden konfiguriert, um den Zugriff auf die Pods zu ermöglichen.
10. **Anwenden der Ingress-Ressource**: Die Ingress-Ressource wird angewendet, um externen Zugriff auf die Services zu ermöglichen.
11. **Starten des Minikube-Tunnels**: Ein Minikube-Tunnel wird gestartet, um den Zugriff auf die Anwendung über localhost zu ermöglichen.

Da im letzten Schritt ein Minikube-Tunnel gestartet wird, muss ggf. das Admin-Passwort eingegeben werden.
Sofern alle Ressourcen erfolgreich bereitgestellt wurden, kann die Anwendung über [localhost](http://localhost) aufgerufen werden.

Um Sicherzustellen, dass die Anwendung vollständig bereitgestellt wurde, können die Status der Ressourcen über den folgenden Befehl überprüft werden:
```bash
kubectl get all -n dhbw-tube
```
```bash
kubectl get ingress -n dhbw-tube
```

## Anwendungsbeschreibung
DHBW-Tube ist eine standortübergreifende Web-Videoplattform zum Austausch von nutzergenerierten Inhalten für Studierende und Mitarbeiter der Dualen Hochschule Baden-Württemberg.
Nutzer können auf dem Portal kostenlos Videoclips suchen, ansehen und hochladen.
Dozenten können zum Beispiel Vorlesungsaufzeichnungen hochladen, die dann von Studierenden, die krankheitsbedingt abwesend sind oder zur Prüfungsvorbereitung wiederholt werden, angesehen werden können.
Auf der anderen Seite haben Studierende die Möglichkeit, eigene Lernvideos zu Vorlesungsinhalten aufzunehmen und mit ihren Kommilitonen zu teilen.
So können auch Studierende verschiedener Fachrichtungen und DHBW-Standorte ihr Wissen campusübergreifend austauschen.
Die Videos können werbefrei von verschiedenen Geräten über den Webbrowser auf der dezentralen Plattform gestreamt werden und bleiben auch für nachfolgende Semester erhalten.
Die Anwendung wurde mit dem Ziel der Datenminimierung entwickelt und erfordert keine aufwändige Registrierung zum Hochladen von Inhalten.