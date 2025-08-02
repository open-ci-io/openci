.PHONY: all clean test down up-dev full-up-dev up-prod ensure-env build rebuild db-schema prepare

all: build

clean: down
	@echo "🧹 Cleaning up project..."
	rm -rf target
	rm -f schema.sql
	@echo "✅ Cleanup complete"

test: ensure-env
	@echo "🧪 Running tests..."
	@set -a; . ./.env; set +a; cargo test
	@echo "✅ Tests passed"

down: 
	docker-compose down -v
	@echo "🛑 OpenCI Controller stopped"

ensure-env:
	@if [ ! -f .env ]; then \
		echo "⚠️  .env file not found, creating with random ports..."; \
		echo "🔐 Generating configuration..."; \
		\
		OPENCI_PORT=$$(( 49152 + $$(od -An -N2 -i /dev/urandom | tr -d ' ') % 16384 )); \
		POSTGRES_PORT=$$(( 49152 + $$(od -An -N2 -i /dev/urandom | tr -d ' ') % 16384 )); \
		\
		while [ $$OPENCI_PORT -eq $$POSTGRES_PORT ]; do \
			POSTGRES_PORT=$$(( 49152 + $$(od -An -N2 -i /dev/urandom | tr -d ' ') % 16384 )); \
		done; \
		\
		POSTGRES_PASSWORD=$$(LC_ALL=C tr -dc 'A-Za-z0-9!^*_+\-=' < /dev/urandom | head -c 25); \
		\
		echo "# OpenCI Controller Configuration" > .env; \
		echo "# Generated on $$(date)" >> .env; \
		echo "" >> .env; \
		echo "# Database Configuration" >> .env; \
		echo "POSTGRES_USER=openci_user" >> .env; \
		echo "POSTGRES_PASSWORD=$$POSTGRES_PASSWORD" >> .env; \
		echo "POSTGRES_DB=openci_db" >> .env; \
		echo "DATABASE_URL=postgres://openci_user:$$POSTGRES_PASSWORD@localhost:$$POSTGRES_PORT/openci_db" >> .env; \
		echo "DATABASE_MAX_CONNECTIONS=5" >> .env; \
		echo "" >> .env; \
		echo "# Port Configuration" >> .env; \
		echo "OPENCI_PORT=$$OPENCI_PORT" >> .env; \
		echo "POSTGRES_PORT=$$POSTGRES_PORT" >> .env; \
		echo "" >> .env; \
		echo "# Server Configuration" >> .env; \
		echo "SERVER_HOST=0.0.0.0" >> .env; \
		echo "SERVER_PORT=8080" >> .env; \
		echo "" >> .env; \
		echo "# Logging" >> .env; \
		echo "RUST_LOG=info" >> .env; \
		echo "" >> .env; \
		echo "# Initial Admin (Optional)" >> .env; \
		echo "OPENCI_INITIAL_ADMIN_NAME=admin" >> .env; \
		echo "OPENCI_INITIAL_ADMIN_EMAIL=admin@example.com" >> .env; \
		\
		echo "✅ .env file created successfully"; \
		echo "📋 Configuration:"; \
		echo "   - OpenCI Port: $$OPENCI_PORT"; \
		echo "   - PostgreSQL Port: $$POSTGRES_PORT"; \
		echo "   - Database: openci_db"; \
		echo "   - User: openci_user"; \
		echo "⚠️  Please save your .env file securely!"; \
	else \
		echo "✅ .env file already exists"; \
	fi

up-dev: ensure-env
	docker-compose up postgres -d
	sleep 2
	@set -a; . ./.env; set +a; sqlx migrate run
	@set -a; . ./.env; set +a; cargo sqlx prepare
	@set -a; . ./.env; set +a; cargo run

full-up-dev: ensure-env
	docker-compose up postgres -d
	sleep 2
	@set -a; . ./.env; set +a; sqlx migrate run
	docker-compose up openci-controller -d
	@echo "🚀 OpenCI Controller started"

build:
	docker-compose -f docker-compose.yml build openci-controller
	@echo "🔨 OpenCI Controller image built"

rebuild:
	docker-compose -f docker-compose.yml build --no-cache openci-controller
	@echo "🔨 OpenCI Controller image rebuilt (no cache)"

db-schema: ensure-env
	@echo "🔄 Generating database schema file (schema.sql)..."
	@docker-compose ps --services --filter "status=running" | grep -q "^postgres$$" \
		|| { echo "❌ postgres container is not running. Did you run \`make up-dev\`?"; exit 1; }
	@set -a; . ./.env; set +a; \
	docker-compose -f docker-compose.yml -f docker-compose.override.yml exec -T postgres pg_dump -s -U "$$POSTGRES_USER" -d "$$POSTGRES_DB" > schema.sql
	@echo "✅ schema.sql has been successfully generated."

up-prod: ensure-env build
	docker-compose -f docker-compose.yml up postgres -d
	sleep 5 
	# Run migrations inside the container
	docker-compose -f docker-compose.yml run --rm openci-controller sqlx migrate run
	docker-compose -f docker-compose.yml up openci-controller -d
	@echo "🚀 OpenCI Controller started in production mode"
