# Stage 1: Build
FROM golang:1.22.5 as builder

WORKDIR /app

# Copy go.mod first (go.sum might not exist, so copy only if available)
COPY go.mod ./
RUN go mod tidy

# Copy the rest of the code
COPY . .

# Build for linux/amd64
RUN GOOS=linux GOARCH=amd64 go build -o main .

# Stage 2: Runtime
FROM gcr.io/distroless/base-debian12

WORKDIR /app

COPY --from=builder /app/main .
COPY --from=builder /app/static ./static

EXPOSE 8080

CMD ["./main"]

