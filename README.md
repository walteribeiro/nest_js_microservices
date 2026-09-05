# nest_js_microservices

![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?logo=typescript&logoColor=white)

## About

Hands-on project following the NestJS Microservices course: an Nx-style monorepo (NestJS's own `apps`/`libs` workspace) with six services that communicate asynchronously over **NATS**, simulating alarm handling for a facility-management platform.

Event flow: `alarms-generator` emits a fake `alarm.created` event every 10s → `alarms-service` receives it and re-emits `alarm.classify` → `alarms-classifier-service` classifies it and emits `notification.send` → `notifications-service` logs the notification. `virtual-facility` (the only HTTP-facing app, with a `buildings` REST resource and a health check) and `workflows-service` (with a shared `workflows` library) round out the domain, each backed by its own PostgreSQL database.

## Services

| Service | Type | Role |
|---|---|---|
| `virtual-facility` | HTTP + microservice | REST API for buildings (`/buildings`), Terminus health check, own Postgres DB |
| `workflows-service` | HTTP + microservice | Workflows resource, consumes shared `@app/workflows` DTOs, own Postgres DB |
| `alarms-generator` | microservice | Emits a random `alarm.created` event every 10s (`@Interval`) |
| `alarms-service` | microservice | Listens for `alarm.created`, forwards to the classifier |
| `alarms-classifier-service` | microservice | Classifies alarms, triggers notifications |
| `notifications-service` | microservice | Listens for `notification.send` and logs it |

## Tech Stack

- TypeScript
- NestJS 12 (monorepo mode, Rspack builder)
- `@nestjs/microservices` over NATS
- `@nestjs/typeorm` + PostgreSQL
- `@nestjs/schedule`, `@nestjs/terminus`
- Docker Compose
- Jest · oxlint · pnpm

## Getting Started

Everything (NATS, two Postgres databases and all six services) runs through Docker Compose:

```bash
git clone https://github.com/walteribeiro/nest_js_microservices.git
cd nest_js_microservices
docker compose up --build
```

`virtual-facility` is the only service exposed on the host, at `http://localhost:3000`. The others talk to each other over the internal NATS broker.

To run a single service locally instead:

```bash
pnpm install
pnpm start:dev <service-name>   # e.g. pnpm start:dev virtual-facility
```

## Scripts

```bash
pnpm build        # nest build
pnpm start:dev     # watch mode (pass the app name, e.g. -- alarms-service)
pnpm test          # unit tests
pnpm test:e2e      # end-to-end tests
pnpm lint          # oxlint
```

## Author

**Walter Ribeiro** · [GitHub](https://github.com/walteribeiro)
