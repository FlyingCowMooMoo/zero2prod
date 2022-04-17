ARG VARIANT="buster"
FROM mcr.microsoft.com/vscode/devcontainers/rust:0-${VARIANT}


RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
   && apt-get -y install clang lld \
   && apt-get autoremove -y && apt-get clean -y
RUN rustup update
RUN cargo install cargo-edit 
RUN cargo install cargo-expand
RUN cargo install --version=0.5.7 sqlx-cli --no-default-features --features postgres
RUN cargo install cargo-udeps
RUN cargo install bunyan
RUN cargo install cargo-watch
RUN cargo install cargo-tarpaulin
RUN cargo install cargo-audit
RUN apt-get install postgresql-client -y
