# Dev Setup

My everyday development setup: editor settings, shell config, Git defaults,
terminal profiles, useful tools, and local Docker helpers.

## Structure

```text
editors/            Editor settings and extension lists
  vscode/           VS Code settings, keybindings, snippets, extensions
  zed/              Zed settings and keymaps
git/                Git configuration templates and ignore rules
shell/              Shell profiles, aliases, functions, and prompt config
terminal/           Terminal app profiles and themes
tools/              CLI tool configuration backups
docker/             Local development Docker utilities
  databases/        ClickHouse, MySQL, and Postgres compose stack
```

## Docker Databases

The existing local database stack is now under `docker/databases/`.

```sh
make up        # start all databases
make info      # show connection details
make down      # stop all databases
```

Run `make` to see all database commands.

## Backup Notes

- Do not commit secrets, tokens, SSH private keys, or machine-specific passwords.
- Prefer `*.example` files when a config contains private values.
- Keep exported extension lists in plain text so they are easy to diff and restore.
