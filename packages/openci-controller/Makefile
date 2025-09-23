.PHONY: ensure-env run_db_and_migrate up-dev up-prod preview-container down \
	db-schema test test-with-codecov test_local test_local_with_codecov

export PATH := $(HOME)/.cargo/bin:$(PATH)

ENV_FILE ?= .env.dev
DOCKER_COMPOSE := docker compose
CONTROLLER := openci-controller
BRIGHT_GREEN := \033[92m
RESET := \033[0m
DOCKER_COMPOSE_YAML := docker-compose.yml
DC = $(DOCKER_COMPOSE) --env-file $(ENV_FILE) --file $(DOCKER_COMPOSE_YAML)

ensure-env:
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "❌ $(ENV_FILE) not found. Please create it for this environment."; \
		exit 1; \
	fi

run_db_and_migrate: ensure-env
	$(DC) up -d postgres
	$(WAIT_FOR_POSTGRES)
	$(DC) run --rm $(CONTROLLER) sqlx migrate run

up-dev: ensure-env
	$(DC) up -d postgres
	$(WAIT_FOR_POSTGRES)
	$(DC) run --rm $(CONTROLLER) sqlx migrate run
	$(DC) run --rm $(CONTROLLER) cargo sqlx prepare
	$(DC) up -d $(CONTROLLER) caddy
	@printf '$(BRIGHT_GREEN)Use "%s --env-file %s --file %s logs -f %s" to view runtime logs and initial API key output$(RESET)\n' \
	"$(DOCKER_COMPOSE)" "$(ENV_FILE)" "$(DOCKER_COMPOSE_YAML)" "$(CONTROLLER)"

up-prod: ENV_FILE = .env.prod
up-prod: ensure-env
	$(DC) up -d postgres
	$(WAIT_FOR_POSTGRES)
	$(DC) run --rm $(CONTROLLER) sqlx migrate run
	$(DC) up -d $(CONTROLLER) caddy
	@echo "🚀 OpenCI Controller started in production mode"

preview-container: ensure-env
	$(DC) logs -f $(CONTROLLER)

down: 
	$(DC) down -v
	@printf '$(BRIGHT_GREEN)Successfully down all containers!$(RESET)\n'

db-schema: ensure-env
	@echo "🔄 Generating database schema file (schema.sql)..."
	@$(DC) ps --services --filter "status=running" | grep -q "^postgres$$" \
		|| { echo "❌ postgres container is not running. Did you run \`make up-dev\`?"; exit 1; }
	$(DC) --file docker-compose.override.yml exec -T postgres pg_dump -s -U "$$POSTGRES_USER" -d "$$POSTGRES_DB" > schema.sql
	@echo "✅ schema.sql has been successfully generated."

test: ensure-env
	$(DC) run --rm $(CONTROLLER) cargo nextest run

test-with-codecov: ensure-env
	$(DC) run --rm $(CONTROLLER) cargo llvm-cov nextest

test_local:
	@set -a; . $(ENV_FILE); set +a; cargo nextest run

test_local_with_codecov:
	@set -a; . $(ENV_FILE); set +a; cargo llvm-cov nextest


define WAIT_FOR_POSTGRES
	 $(DC) exec -T postgres \
	 		sh -c 'until pg_isready -U "$$POSTGRES_USER" -d "$$POSTGRES_DB" -h localhost; do sleep 1; done'
endef
