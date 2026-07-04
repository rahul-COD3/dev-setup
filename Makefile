# ─────────────────────────────────────────────────────────────────────
#  Docker database services — manager
#
#  Add a database:
#    1. Add a service block in database/docker-compose.yml
#    2. Map its short name below (in the "short name → service" section)
#    3. Optionally add a cli-<name> client command
#  That's it — the up/down/shell/cli targets work for it automatically.
# ─────────────────────────────────────────────────────────────────────

PW      := root                                     # database password
COMPOSE := docker compose -f database/docker-compose.yml

# short name → compose service
ch := clickhouse
my := mysql
pg := postgres
SERVICES := ch my pg

# short name → interactive client (used by `make cli-<name>`)
cli-ch := clickhouse-client --user default --password $(PW)
cli-my := mysql -u root -p$(PW)
cli-pg := psql -U postgres

# resolve a short name to its service, or fail with a clear message
svc = $(or $($*),$(error unknown service '$*' — one of: $(SERVICES)))

# ── presentation ─────────────────────────────────────────────────────
NC    := \033[0m
BOLD  := \033[1m
DIM   := \033[2m
BLUE  := \033[34m
CYAN  := \033[36m

define header
	@printf "$(BOLD)$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)\n"
	@printf "$(BOLD)$(BLUE)  🐳  $(1)$(NC)\n"
	@printf "$(BOLD)$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)\n"
endef

define footer
	@printf "$(BOLD)$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)\n"
endef

.DEFAULT_GOAL := help
.PHONY: help up down clean info

# ── all services ─────────────────────────────────────────────────────
up:
	$(call header,Starting all services 🚀)
	@$(COMPOSE) up -d
	$(call footer)

down:
	$(call header,Stopping all services ✋)
	@$(COMPOSE) down
	$(call footer)

clean:
	$(call header,Cleaning everything ⚠️)
	@$(COMPOSE) down -v
	$(call footer)

# ── per-service (e.g. up-ch, down-my, shell-pg, cli-my) ──────────────
up-%:
	$(call header,Starting $(svc) 🚀)
	@$(COMPOSE) up -d $(svc)
	$(call footer)

down-%:
	$(call header,Stopping $(svc) ✋)
	@$(COMPOSE) stop $(svc)
	$(call footer)

shell-%:
	$(call header,Shell → $(svc))
	@$(COMPOSE) exec $(svc) bash

cli-%:
	$(call header,Client → $(svc))
	@$(COMPOSE) exec $(svc) $(cli-$*)

# ── help & info ──────────────────────────────────────────────────────
help:
	$(call header,Docker Database Manager)
	@printf "\n"
	@printf "  $(BOLD)Usage:$(NC) make $(CYAN)<target>$(NC)   (services: $(SERVICES))\n\n"
	@printf "  $(BOLD)All services:$(NC)\n"
	@printf "    $(CYAN)up$(NC)  $(CYAN)down$(NC)  $(CYAN)clean$(NC)\n\n"
	@printf "  $(BOLD)Per-service$(NC) (suffix with a short name, e.g. $(CYAN)up-ch$(NC)):\n"
	@printf "    $(CYAN)up-%%$(NC)  $(CYAN)down-%%$(NC)  $(CYAN)shell-%%$(NC)  $(CYAN)cli-%%$(NC)\n\n"
	@printf "  $(BOLD)Info:$(NC)\n"
	@printf "    $(CYAN)info$(NC)             Connection details\n\n"
	$(call footer)

info:
	$(call header,Connection Details)
	@printf "\n"
	@printf "  $(BOLD)ClickHouse (ch)$(NC)\n"
	@printf "    HTTP :$(DIM) http://localhost:8123$(NC)\n"
	@printf "    TCP  :$(DIM) localhost:9000$(NC)\n"
	@printf "    User :$(DIM) default$(NC)     Pass :$(DIM) $(PW)$(NC)\n\n"
	@printf "  $(BOLD)MySQL (my)$(NC)\n"
	@printf "    Host :$(DIM) localhost:3306$(NC)\n"
	@printf "    User :$(DIM) root$(NC)        Pass :$(DIM) $(PW)$(NC)\n\n"
	@printf "  $(BOLD)Postgres (pg)$(NC)\n"
	@printf "    Host :$(DIM) localhost:5432$(NC)\n"
	@printf "    User :$(DIM) postgres$(NC)    Pass :$(DIM) $(PW)$(NC)\n\n"
	$(call footer)
