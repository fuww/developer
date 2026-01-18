FROM oven/bun:1-alpine AS base
WORKDIR /app

# Install build dependencies and runtime libraries for Sharp
RUN apk add --no-cache python3 py3-setuptools make g++ vips-dev vips

FROM base AS deps
COPY package.json bun.lock ./
RUN bun install --frozen-lockfile

FROM base AS prod-deps
COPY package.json bun.lock ./
RUN bun install --frozen-lockfile --production && \
    rm -rf /root/.bun/install/cache

FROM deps AS build
COPY . .
RUN bun run build

FROM oven/bun:1-alpine AS runtime
WORKDIR /app

# Install only runtime dependencies for Sharp (vips, not vips-dev)
RUN apk add --no-cache vips

# Copy production dependencies
COPY --from=prod-deps /app/node_modules ./node_modules
# Copy built application
COPY --from=build /app/dist ./dist
# Copy package.json for any runtime requirements
COPY --from=build /app/package.json ./

ENV HOST=0.0.0.0
ENV PORT=8080
EXPOSE 8080
CMD ["bun", "./dist/server/entry.mjs"]
