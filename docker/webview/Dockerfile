FROM node:22.7-alpine AS builder

WORKDIR /app
ENV NODE_ENV=production

# Install dependencies for node-gyp and other build tools
RUN apk add --no-cache libc6-compat python3 make g++

# Copy package files
COPY ./app/webview/package*.json ./

# Install dependencies
RUN npm ci

# Copy source files
COPY ./app/webview ./

# Build the application
RUN npm run build

FROM node:22.7-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

# Install production dependencies only
COPY --from=builder /app/package*.json ./
RUN npm ci --only=production

# Copy built application
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.ts ./

# Create a non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001
RUN chown -R nextjs:nodejs /app
USER nextjs

EXPOSE 3000

CMD ["npm", "start"]