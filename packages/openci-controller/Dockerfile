FROM rust:1.87

WORKDIR /app

RUN cargo install sqlx-cli --no-default-features --features native-tls,postgres

COPY . .

CMD ["cargo", "run"]
