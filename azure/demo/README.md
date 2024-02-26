# Azure Container Apps Sample application
The sample application consists of two parts,
lagerverwaltung (inventory management) and bestellungsverwaltung (order management).
Both provide a REST-API.
The order management depends on the inventory management.

## Development
### Environment
* NodeJS (tested with 20.9.0)
* npm (testet with 10.1.0)

### Steps
To be executed per application part.

Install dependencies:
```bash
$ npm install
```

Start the development server:
```bash
$ npm run dev
```

Define environment variables by creating a .env file. Just copy the template:
```bash
cp .env.template .env
```
You can then change the values as you wish.

Build the project (generate JS files):
```bash
$ npm run build
```
The output directory is `dist/`.

### Build and Push Docker Image
This requires you to have Docker installed.

Build the Docker Image:
```bash
$ docker build -t lennahht/storage-bestellungsverwaltung:latest .
```

Push the Image to a remote registry:
```bash
$ docker push lennahht/storage-bestellungsverwaltung:latest .
```

You can configure the container by setting the environment variables
defined in the .env files.

You can deploy both application parts in an orchestrated environment using Docker Compose.
An exemplary docker-compose.yaml is given.