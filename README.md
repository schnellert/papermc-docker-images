# PaperMC Docker Images

[![Release](https://github.com/schnellert/papermc-docker-images/actions/workflows/release.yml/badge.svg)](https://github.com/schnellert/papermc-docker-images/actions/workflows/release.yml)

Docker images for [PaperMC](https://papermc.io) software, built automatically from the official releases provided by the [PaperMC Fill API](https://fill.papermc.io/swagger-ui/index.html#).

Lightweight and ready for Docker, Docker Compose, Docker Swarm, Kubernetes and any other OCI-compatible runtime.

## 📦 Images

| Project                                          | Image                                                                 | Docker Hub                                                                                                                                       |
| ------------------------------------------------ | --------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| [Folia](https://papermc.io/software/folia)       | [`schnellert/folia`](https://hub.docker.com/r/schnellert/folia)       | [![Docker Pulls](https://img.shields.io/docker/pulls/schnellert/folia?label=pulls&logo=docker)](https://hub.docker.com/r/schnellert/folia)       |
| [Paper](https://papermc.io/software/paper)       | [`schnellert/paper`](https://hub.docker.com/r/schnellert/paper)       | [![Docker Pulls](https://img.shields.io/docker/pulls/schnellert/paper?label=pulls&logo=docker)](https://hub.docker.com/r/schnellert/paper)       |
| [Velocity](https://papermc.io/software/velocity) | [`schnellert/velocity`](https://hub.docker.com/r/schnellert/velocity) | [![Docker Pulls](https://img.shields.io/docker/pulls/schnellert/velocity?label=pulls&logo=docker)](https://hub.docker.com/r/schnellert/velocity) |

All images are available for `linux/amd64` and `linux/arm64`. Each image is based on the [Eclipse Temurin](https://hub.docker.com/_/eclipse-temurin) JRE (Ubuntu Jammy) with the minimum Java version its release requires: 8, 17, 21 or 25.

## 🏷️ Tags

- `<version>` - newest stable build for that version, e.g. `paper:1.21.11` or `velocity:4.1.0-SNAPSHOT`
- `<version>@sha256:<digest>` - a specific, immutable build

Every version with a stable build is published. If a version line has no stable build yet (e.g. a new Minecraft release), its newest version is published with its newest experimental build, so it is available early.

Pin `<version>@sha256:<digest>` for reproducible deployments; use `<version>` to follow the newest build in that version.

> [!NOTE]
> Releases that require Java 6, 11 or 16 (e.g. Paper 1.7.10 and 1.17.x, Velocity 3.1.x and 3.2.0) are currently not published.

## 🔄 Updates

The `<version>` tags are rebuilt automatically when:

- PaperMC publishes a new build for that version (checked weekly),
- the Java base image receives an update, e.g. a security patch,
- the image definition in this repository changes.

Only the affected images are rebuilt, e.g. a Java 8 base image update rebuilds only the images that run on Java 8. A rebuild pushes a new digest under the same tag.

## ⚙️ Configuration

| Variable            | Description                                                                    | Default       |
| ------------------- | ------------------------------------------------------------------------------ | ------------- |
| `ACCEPT_EULA`       | Accepts the Minecraft EULA. Folia and Paper will not start until it is `true`. | `false`       |
| `JAVA_TOOL_OPTIONS` | JVM options, e.g. `-Xms2G -Xmx2G`.                                             | JVM defaults  |
| `LANG`              | Locale.                                                                        | `en_US.UTF-8` |

`ACCEPT_EULA` has no effect on Velocity.

The container reports as healthy once the server accepts connections on port `25565`. On stop, the server receives `SIGTERM` and shuts down gracefully. Saving the worlds can take longer than Docker's default 10 seconds, so allow more time, e.g. `docker stop -t 60 paper-1` or `stop_grace_period: 1m` in Docker Compose.

Persistent data lives in `/data`. The container runs as a non-root user (**UID 1000**), so the mounted host directory must be writable by that user:

```bash
mkdir -p /data/paper-1
chown -R 1000:1000 /data/paper-1
```

> [!IMPORTANT]
> The servers are **stateful**. Each instance must use its own persistent volume.
>
> Do **not** share the same writable `/data` directory between multiple instances/replicas.

> [!NOTE]
> These images are regular JRE-based container images, not distroless images. This keeps them flexible for custom runtime requirements, such as overriding the entrypoint to run initialization scripts, modify configuration files, or perform other startup tasks before the server is launched.

## 🚀 Usage

The examples use Paper. For Folia or Velocity, replace the image and name accordingly; Velocity does not need `ACCEPT_EULA`.

### Docker

```bash
docker run -dit \
  --name paper-1 \
  -e ACCEPT_EULA=true \
  -p 25565:25565 \
  -v /data/paper-1:/data \
  schnellert/paper:1.21.11
```

- `-d` - runs the container in **detached mode**.
- `-i` - keeps **STDIN** open for interactive input.
- `-t` - allocates a **pseudo-TTY**, allowing you to attach to the server console.

| Action                                | Command                  |
| ------------------------------------- | ------------------------ |
| Attach to the console                 | `docker attach paper-1`  |
| Detach without stopping the container | `Ctrl+P, Ctrl+Q`         |
| View the logs                         | `docker logs -f paper-1` |

### Docker Compose

```yaml
services:
  paper-1:
    image: schnellert/paper:1.21.11
    volumes:
      - /data/paper-1:/data
    environment:
      ACCEPT_EULA: "true"
    ports:
      - 25565:25565
    stdin_open: true
    tty: true
    stop_grace_period: 1m
```

`stdin_open: true` and `tty: true` correspond to Docker's `-i` and `-t` options. `stop_grace_period` gives the server time to save before it is killed.

| Action                                | Command                          |
| ------------------------------------- | -------------------------------- |
| Start the instance                    | `docker compose up -d`           |
| Attach to the console                 | `docker compose attach paper-1`  |
| Detach without stopping the container | `Ctrl+P, Ctrl+Q`                 |
| View the logs                         | `docker compose logs -f paper-1` |

## 🤝 Contributing

Contributions are welcome.

The recommended development environment is the included [devcontainer.json](.devcontainer/devcontainer.json).

### Requirements

- [Docker](https://docs.docker.com/engine/install)
- [Visual Studio Code](https://code.visualstudio.com)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Development Setup

1. Clone and open the repository in Visual Studio Code.
2. Run `Dev Containers: Reopen in Container` from the command palette.

### Commit Messages

Please open a related issue and reference it in your commit message using `.. (#issue-number)`.

## 📝 License

The files in this repository are released under the [MIT License](LICENSE).
