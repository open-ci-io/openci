FROM rust:1.87

WORKDIR /app

RUN cargo install sqlx-cli --no-default-features --features native-tls,postgres
RUN cargo install cargo-nextest --locked

COPY . .

CMD ["cargo", "run"]
