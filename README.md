# Docker Databases

Local development databases (ClickHouse, MySQL, Postgres) managed with Docker
Compose and a small Makefile. Data persists in named volumes.

## Requirements

- Docker (with the Compose plugin)
- `make`

## Quick start

```sh
make up        # start everything
make info      # connection details (host, port, user, password)
make down      # stop everything
```

Run `make` on its own to see all commands.

## Common commands

| Command             | What it does                          |
| ------------------- | ------------------------------------- |
| `make up` / `down`  | Start / stop all services             |
| `make restart`      | Restart all services                  |
| `make status`       | Show running services                 |
| `make logs`         | Tail logs                             |
| `make pull`         | Pull latest images                    |
| `make clean`        | Stop and **delete all data volumes**  |
| `make up-ch`        | Start one service (`ch`/`my`/`pg`)    |
| `make shell-my`     | Open a shell in a service             |
| `make cli-pg`       | Open the DB client for a service      |
| `make info`         | Connection details                    |

## Password

Every database uses one password, `root`, defined at the top of
`database/docker-compose.yml` (`x-pw`) and the `Makefile` (`PW`).

## Adding a database

1. Add a service block in `database/docker-compose.yml`.
2. Map its short name in the `Makefile` (e.g. `rd := redis`, add `rd` to `SERVICES`).
3. Optionally add a client command (e.g. `cli-rd := redis-cli`).

The `up-`, `down-`, `shell-`, and `cli-` targets then work for it automatically.
