# Production Deployment Guide

This document explains how to build and run all FountainAI services using Docker Compose.

Each generated server already contains a `Dockerfile`. The root `docker-compose.yml` composes these images so they can be started together.

## Building the Containers

Run the following command at the repository root:

```bash
docker-compose build
```

This compiles each service into a minimal Swift container.

## Starting the Services

To start all containers:

```bash
docker-compose up
```

The services currently print a startup message. Networking and persistent storage are not yet implemented.

### Running a Single Service

To build and run only the Baseline Awareness service:

```bash
docker build -f Generated/Server/baseline-awareness/Dockerfile -t baseline-awareness .
docker run -p 8080:8080 baseline-awareness
```

After the container starts, verify the health endpoint:

```bash
curl http://localhost:8080/health
```

## Stopping and Removing Containers

Press `Ctrl+C` to stop the running services, then remove containers with:

```bash
docker-compose down
```

This workflow prepares the project for a production environment once networking and persistence layers are added.
