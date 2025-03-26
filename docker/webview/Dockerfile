# ビルド時にプラットフォームを明示的に指定する
FROM --platform=linux/amd64 node:22.7-alpine AS builder

WORKDIR /app
ENV NODE_ENV=production

# Install dependencies for node-gyp and other build tools
RUN apk add --no-cache libc6-compat python3 make g++

# Copy package files
COPY ./packages/webview/package*.json ./

# Install dependencies
RUN npm ci

# Copy source files
COPY ./packages/webview ./

# Build the application
RUN npm run build

# ビルド時にプラットフォームを明示的に指定する
FROM --platform=linux/amd64 node:22.7-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

# Copy necessary files for standalone mode
COPY --from=builder /app/next.config.* ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

# Create a non-root user
RUN addgroup -g 1001 -S next-tstack
RUN adduser -S webview -u 1001
RUN chown -R webview:next-tstack /app
USER webview

EXPOSE 3000

# Use node directly with server.js for standalone mode
CMD ["node", "server.js"]