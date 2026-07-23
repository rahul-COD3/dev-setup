# Docker Databases

Local development databases managed with Docker Compose. Data persists in named
volumes.

## Commands

```sh
make up        # start everything
make info      # connection details
make down      # stop everything
make clean     # stop and delete all data volumes
```

Every database uses the password `root`, defined in `docker-compose.yml` and the
root `Makefile`.
