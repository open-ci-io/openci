.PHONY: up down

down: 
	docker-compose down -v
	@echo "🛑 OpenCI Controller stopped"

up:
	docker-compose up postgres -d
	sqlx migrate run
	cargo run
	@echo "🚀 OpenCI Controller started"