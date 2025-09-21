.PHONY: all clean test down up-dev full-up-dev up-prod ensure-env build rebuild db-schema ensure-sqlx add-migration-files

# Ensure Cargo bin is in PATH for sqlx/cargo-sqlx
export PATH := $(HOME)/.cargo/bin:$(PATH)

ENV_FILE ?= .env.dev
DOCKER_COMPOSE := docker compose

all: build

clean: down
	@echo "🧹 Cleaning up project..."
	rm -rf target
	rm -f schema.sql
	@echo "✅ Cleanup complete" 

run_db_and_migrate: ensure-env
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) up postgres -d
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) run --rm openci-controller sqlx migrate run

test: ensure-env
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) run --rm openci-controller cargo nextest run

test-with-codecov: ensure-env
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) run --rm openci-controller cargo llvm-cov nextest


down: 
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) down -v
	@echo "🛑 OpenCI Controller stopped"

ensure-env:
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "❌ $(ENV_FILE) not found. Please create it for this environment."; \
		exit 1; \
	fi


up-dev: ensure-env
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) up postgres -d
	sleep 2
	$(MAKE) ensure-sqlx
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) run --rm openci-controller sqlx migrate run
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) run --rm openci-controller cargo sqlx prepare
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) run --rm openci-controller cargo run

full-up-dev: ensure-env
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) up postgres -d
	sleep 2
	$(MAKE) ensure-sqlx
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) run --rm openci-controller sqlx migrate run
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) up openci-controller -d
	@echo "🚀 OpenCI Controller started"

build:
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) -f docker-compose.yml build openci-controller
	@echo "🔨 OpenCI Controller image built"

rebuild:
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) -f docker-compose.yml build --no-cache openci-controller
	@echo "🔨 OpenCI Controller image rebuilt (no cache)"

db-schema: ensure-env
	@echo "🔄 Generating database schema file (schema.sql)..."
	@$(DOCKER_COMPOSE) --env-file $(ENV_FILE) ps --services --filter "status=running" | grep -q "^postgres$$" \
		|| { echo "❌ postgres container is not running. Did you run \`make up-dev\`?"; exit 1; }
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) -f docker-compose.yml -f docker-compose.override.yml exec -T postgres pg_dump -s -U "$$POSTGRES_USER" -d "$$POSTGRES_DB" > schema.sql
	@echo "✅ schema.sql has been successfully generated."

up-prod: ENV_FILE = .env.prod
up-prod: ensure-env build
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) -f docker-compose.yml up postgres -d
	sleep 5 
	# Run migrations inside the container
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) -f docker-compose.yml run --rm openci-controller sqlx migrate run
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) -f docker-compose.yml up openci-controller -d
	@echo "🚀 OpenCI Controller started in production mode"

add-migration-files: ensure-sqlx
	sqlx migrate add

ensure-sqlx:
	@command -v cargo >/dev/null 2>&1 || { \
		echo "❌ cargo not found. Please install Rust toolchain (https://rustup.rs)."; \
		exit 1; \
	}
	@command -v sqlx >/dev/null 2>&1 || command -v cargo-sqlx >/dev/null 2>&1 || { \
		echo "⬇️  Installing sqlx-cli (features: postgres,rustls)..."; \
		cargo install sqlx-cli --no-default-features --features postgres,rustls || { \
			echo "❌ Failed to install sqlx-cli"; \
			exit 1; \
		}; \
	}
	@echo "✅ sqlx-cli is available"
