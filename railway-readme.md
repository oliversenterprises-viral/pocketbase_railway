# Deploy and Host pocketbase_railway on Railway

pocketbase_railway is a Go-based PocketBase application that uses PocketBase as a framework, allowing you to extend its functionality with custom Go code. It serves static files from the `pb_public` directory and can be easily customized with additional routes, hooks, and middleware while maintaining all of PocketBase's built-in features like authentication, file storage, and real-time subscriptions.

## About Hosting pocketbase_railway

Hosting pocketbase_railway on Railway involves building a statically-linked Go binary using a multi-stage Docker build process. The application uses PocketBase's embedded SQLite database by default, which requires a persistent volume mount at `/pb_data` to ensure data persistence across deployments. The Dockerfile follows Go best practices by using dependency caching, static linking with `-extldflags "-static"`, and a minimal `busybox:glibc` base image for a small final container size. Railway automatically handles port binding through the `PORT` environment variable, and the application listens on all interfaces (`0.0.0.0`) to work seamlessly with Railway's networking layer.

## Common Use Cases

- Building backend APIs with built-in authentication, file storage, and real-time capabilities for web and mobile applications

- Creating admin dashboards and content management systems with PocketBase's admin UI and custom Go extensions

- Developing rapid prototypes and MVPs that need a database, authentication, and API layer without managing separate services

## Dependencies for pocketbase_railway Hosting

- Go 1.25.0 or later (for building the application binary)

- Railway volume mount at `/pb_data` (for persistent SQLite database storage)

### Deployment Dependencies

- [PocketBase Framework Documentation](https://pocketbase.io/docs/use-as-framework) - Learn how to extend PocketBase with custom Go code
- [Railway Volume Documentation](https://docs.railway.app/storage/volumes) - Configure persistent storage for your PocketBase data
- [Go Module Documentation](https://go.dev/ref/mod) - Understanding Go modules and dependency management

### Implementation Details

- Ensure a volume is mounted at `/pb_data` in Railway's service settings for data persistence
- The application will automatically use Railway's `PORT` environment variable if configured, or default to 8090
- Static files in `pb_public` are served at the root path, making it easy to host a frontend alongside the API

## Why Deploy pocketbase_railway on Railway?

<!-- Recommended: Keep this section as shown below -->

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying pocketbase_railway on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.

<!-- End recommended section -->
