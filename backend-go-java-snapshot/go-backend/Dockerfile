# Build stage
FROM golang:1.21-bookworm AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y gcc libc6-dev

# Copy go mod files
COPY go.mod ./

# Download dependencies and create go.sum
RUN go mod download && go mod tidy

# Copy source code
COPY . .

# Ensure all dependencies are in go.sum and build
RUN go mod tidy && CGO_ENABLED=1 GOOS=linux go build -a -installsuffix cgo -o main .

# Runtime stage
FROM debian:bookworm-slim

WORKDIR /app

# Install runtime dependencies for SQLite
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates wget sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Copy the binary from builder
COPY --from=builder /app/main .

# Create data directory for SQLite database
RUN mkdir -p /app/data

# Environment variables
ENV PORT=8081
ENV DB_PATH=/app/data/highscores.db
ENV GIN_MODE=release

# Expose port
EXPOSE 8081

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8081/health || exit 1

# Run the application
CMD ["./main"]
