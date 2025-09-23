.PHONY: ensure-env run_db_and_migrate up-dev up-prod preview-container down \
	db-schema test test-with-codecov test_local test_local_with_codecov

export PATH := $(HOME)/.cargo/bin:$(PATH)

ENV_FILE ?= .env.dev
DOCKER_COMPOSE := docker compose
CONTROLLER := openci-controller
BRIGHT_GREEN := \033[92m
RESET := \033[0m

ensure-env:
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "❌ $(ENV_FILE) not found. Please create it for this environment."; \
		exit 1; \
	fi

run_db_and_migrate: ensure-env
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) up postgres -d
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) run --rm $(CONTROLLER) sqlx migrate run

up-dev: ensure-env
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) up postgres -d
	sleep 2
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) run --rm $(CONTROLLER) sqlx migrate run
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) run --rm $(CONTROLLER) cargo sqlx prepare
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) up -d $(CONTROLLER) caddy
	@printf '$(BRIGHT_GREEN)Use "%s --env-file %s logs -f %s" to view runtime logs and initial API key output$(RESET)\n' \
	"$(DOCKER_COMPOSE)" "$(ENV_FILE)" "$(CONTROLLER)"

up-prod: ENV_FILE = .env.prod
up-prod: ensure-env
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) -f docker-compose.yml up postgres -d
	sleep 5 
	# Run migrations inside the container
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) -f docker-compose.yml run --rm $(CONTROLLER) sqlx migrate run
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) -f docker-compose.yml up $(CONTROLLER) caddy -d
	@echo "🚀 OpenCI Controller started in production mode"

preview-container:
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) logs -f $(CONTROLLER)

down: 
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) down -v
	@printf '$(BRIGHT_GREEN)Successfully down all containers!$(RESET)'

db-schema: ensure-env
	@echo "🔄 Generating database schema file (schema.sql)..."
	@$(DOCKER_COMPOSE) --env-file $(ENV_FILE) ps --services --filter "status=running" | grep -q "^postgres$$" \
		|| { echo "❌ postgres container is not running. Did you run \`make up-dev\`?"; exit 1; }
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) -f docker-compose.yml -f docker-compose.override.yml exec -T postgres pg_dump -s -U "$$POSTGRES_USER" -d "$$POSTGRES_DB" > schema.sql
	@echo "✅ schema.sql has been successfully generated."

test: ensure-env
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) run --rm $(CONTROLLER) cargo nextest r

test-with-codecov: ensure-env
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) run --rm $(CONTROLLER) cargo llvm-cov nextest

test_local:
	@set -a; . $(ENV_FILE); set +a; cargo nextest run

test_local_with_codecov:
	@set -a; . $(ENV_FILE); set +a; cargo llvm-cov nextest
