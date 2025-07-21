FROM rust:1.87

WORKDIR /app

# sqlx-cliをインストール
RUN cargo install sqlx-cli --no-default-features --features native-tls,postgres

COPY . .

CMD ["cargo", "run"]
