# Basic Python Webserver
The provided application represents a minimal Flask web server.
When changes to the code base are pushed, a new container image is automatically created using a GitHub action.
## Available routes of the web server
- /
- /dummy

## Build a Container Image
```sh
docker build --tag basic-python-webserver .
```

## Run a Container based on the created Container Image
```sh
docker run --publish 5000:5000 --name python-webserver basic-python-webserver
```

## Testing the web server
```sh
curl http://localhost:5000/
curl http://localhost:5000/dummy
```