#!/bin/bash

exec zg --server run \
    --listen 0.0.0.0:${HTTP_PORT} \
    --mcp-toolset ${ZVEC_GREP_MCP_TOOLSET} \
    --hostname ${ZVEC_GREP_HOSTNAME} \
    $ZG_EXTRA_MCP_ARGS