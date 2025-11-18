# Deploy Pocketbase on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/pocketbaserailway?referralCode=XR5Br6&utm_medium=integration&utm_source=template&utm_campaign=generic)

This template includes a go module `pocketbase_railway` (you can find and replace all instances of this with your `github.com/<username>/<project>`) and a volume `/pb_data` which is where Pocketbase stores data.

This template supposes that you might want to extend pocketbase at somepoint so it follows the "[use-as-framework](https://pocketbase.io/docs/use-as-framework)" official doc. You could never touch the go side and use this as a normal pocketbase binary deployment, but they option is easily available.

## Details

- go version 1.25.0
- pocketbase version 0.33.0

> latest minor versions as of 2025/11/18

---

## Optional Additions

### Embed Frontend Single-Page Application

This example will show how to add a vite application in the `web` folder which when built will place the SPA code inside of `web/dist`.

```go
// main.go

// Add this embed to the root, note "//go:embed" is required and is not a comment
//go:embed web/dist
var frontendFS embed.FS

// Modify your OnServe hook
app.OnServe().BindFunc(func(se *core.ServeEvent) error {
  filesystem, err := fs.Sub(frontendFS, "web/dist")
  if err != nil {
    log.Fatal(err)
  }

  // Same as base template except we use our created file system
  se.Router.GET("/{path...}", apis.Static(filesystem, false))

  return se.Next()
})
```

Add this docker stage

```dockerfile
# ============== Node build stage ==============

FROM node:22-slim AS node-build
# Enable corepack for pnpm
RUN corepack enable

# Set the working directory for the frontend
WORKDIR /app/web

# Copy package.json and pnpm-lock.yaml for dependency caching
COPY web/package.json web/pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy source code
COPY web/ ./

# Build the frontend
RUN pnpm run build
```

Modify the go-build stage to include the SPA files

```dockerfile
# Copy the frontend so it can be embedded in the binary
# The path needs to be relative to the WORKDIR /app, so ./web/dist is correct
COPY --from=node-build /app/web/dist ./web/dist
```

You can remove `pb_public` since we've replaced it with our SPA.
