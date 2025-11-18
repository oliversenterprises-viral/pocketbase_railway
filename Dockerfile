# ============== Go build stage ==============

FROM golang:1.25-bookworm AS go-build

# Set the working directory for the Go application
WORKDIR /app

# Copy go.mod and go.sum for dependency caching
COPY go.mod go.sum ./

# Download and verify dependencies
RUN go mod download && go mod verify

# Copy go source code
COPY main.go ./

# Build the binary
# Assuming your main package is at the root of /app (where go.mod is)
RUN go build -v -tags timetzdata -trimpath -ldflags '-s -w -buildid="" -extldflags "-static"' -o /rss .


# ============== Final stage ==============

FROM busybox:glibc

# Set the working directory in the final image
WORKDIR /app

# Copy the binary
# Copy from /rss (where we built it in the go-build stage) to /app/rss
COPY --from=go-build /rss ./rss

# Notify Docker that the container wants to expose a port.
EXPOSE 8090

# Start Pocketbase app
# Assuming 'rss' is the name of your binary and it acts like a Pocketbase CLI.
# If your binary is just a standard Go server, this command might need adjustment.
CMD [ "/app/rss", "serve", "--http=0.0.0.0:8090" ]