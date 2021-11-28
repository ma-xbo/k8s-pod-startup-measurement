# Beispiel für einen einfachen Webserver mit Python

## Vorbereitungen

Die Projektstruktur sollte wie folgt aussehen:
```
python-docker
|____ app.py
|____ requirements.txt
|____ Dockerfile
```

## Erstellen des Containers
Zum Erstellen des Containers muss folgender Befehl ausgeführt werden:
```sh
docker build --tag basic-python-webserver .
```

## Starten des Containers
Zum Starten des Containers muss folgender Befehl ausgeführt werden:
```sh
docker run --publish 5000:5000 --name python-webserver basic-python-webserver
```

## Testen des Webservers
Der Webserver sollte nun verfügbar sein. Dies kann mit dem nachfolgenden Kommando getestet werden:
```sh
curl http://localhost:5000/
```

## Stoppen der Container Instanz
Zum Stoppen des Containers muss folgender Befehl ausgeführt werden:
```sh
docker stop python-webserver
```

## Löschen der Container Instanz
Um eine Container Instanz löschen zu können, muss diese zuvor gestoppt werden.
Zum Löschen des Containers muss folgender Befehl ausgeführt werden:
```sh
docker rm python-webserver
```

## Löschen des Container Image
Zum Löschen des Containers muss folgender Befehl ausgeführt werden:
```sh
docker image rm basic-python-webserver
```