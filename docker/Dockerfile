
ARG RUST_VERSION=1.98
FROM rust:${RUST_VERSION} AS base

RUN apt-get update && apt-get install -y build-essential libssl-dev pkg-config clang cmake

# optional step for git based install
FROM base AS git-builder

ARG ZVEC_GREP_VERSION=main
ARG ZVEC_GREP_REPO=https://github.com/zvec-ai/zvec-grep.git
RUN git clone --depth 1 --branch $ZVEC_GREP_VERSION --single-branch $ZVEC_GREP_REPO \
    && cd zvec-grep/rust \
    && cargo build --release

# build step for local source code
FROM base AS builder

COPY ./rust /zvec-grep

RUN cd /zvec-grep \
    && cargo build --release

FROM debian:trixie-slim as final

COPY docker/docker-entrypoint.sh /docker-entrypoint.sh

RUN apt-get update && apt-get install -y libssl-dev ca-certificates curl \
    && apt-get clean \
    && mkdir -p /workspace \
    && mkdir -p /zvec-grep/model_cache \
    && chmod +x /docker-entrypoint.sh
    # && groupadd -g 1000 zg \
    # && useradd -m -s /bin/bash zg --uid 1000 --gid 1000 \
    # && chown -R zg:zg /zvec-grep \
    # && chown -R zg:zg /workspace


COPY --from=builder /zvec-grep/target/release/zg /usr/local/bin/zg
COPY --from=builder /zvec-grep/target/release/libzvec_c_api.so /usr/local/lib/libzvec_c_api.so
COPY --from=builder /zvec-grep/target/release/data/jieba_dict /zvec-grep/jieba_dict


ENV HTTP_PORT=80
ENV ZVEC_GREP_MCP_TOOLSET=agent
ENV ZVEC_GREP_HOSTNAME=localhost
ENV ZVEC_GREP_MODE=direct
ENV ZVEC_GREP_HOME=/zvec-grep
ENV ZVEC_GREP_MODEL_CACHE=/zvec-grep/model_cache
ENV ZVEC_GREP_EMBEDDING="local/potion-retrieval-32m"
ENV ZVEC_JIEBA_DICT_DIR=/zvec-grep/jieba_dict
ENV ZVEC_GREP_AUTHORIZATION_KEY_FILE=
ENV DASHSCOPE_API_KEY=
ENV QWEN_API_KEY=
ENV WORKSPACE=/workspace
ENV ZG_EXTRA_MCP_ARGS=

WORKDIR /zvec-grep

ENTRYPOINT ["/docker-entrypoint.sh"]