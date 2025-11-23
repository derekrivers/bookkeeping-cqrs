# Bookkeeping CQRS — Double-Entry Accounting with Rails 8

A learning-driven project that implements a **double-entry bookkeeping system**
using **event-sourcing** and **CQRS** patterns in **Ruby on Rails 8**.

This repository is part of a hands-on software engineering journey exploring
domain-driven design, event modeling, and financial correctness in modern
Rails applications.

---

## 🚀 Goals

- Model a correct double-entry accounting domain.
- Learn how to apply **Event Sourcing** and **CQRS** patterns in Rails.
- Explore command handlers, aggregates, and projections.
- Build a transparent, auditable accounting system from first principles.

---

## 🧱 Architecture Overview

- **Rails 8.0**
- **PostgreSQL** for persistence and projections.
- **Rails Event Store** for event sourcing.
- **AggregateRoot** for enforcing invariants.
- **CQRS** separation between write models (commands) and read models (queries).
- **RSpec** for testing.

---

## 🧭 Project Structure

| Directory | Purpose |
|------------|----------|
| `app/commands/` | Command objects representing user intent |
| `app/aggregates/` | Aggregates enforcing business rules |
| `app/events/` | Domain events stored in the event store |
| `app/projectors/` | Build read models from events |
| `app/queries/` | Read models and query handlers |
| `spec/` | RSpec test suite |

---

## 🧩 Planned Sprints

| Sprint | Focus |
|--------|--------|
| Week 0 | Project setup and documentation |
| Sprint 1 | Event Store setup |
| Sprint 2 | Aggregates and command handling |
| Sprint 3 | Projection and query layer |
| Sprint 4 | Transaction validation (double-entry rule) |
| Sprint 5+ | Reports, API, and UI |

---

## 🛠 Setup
## 🚀 Requirements

* Docker Desktop
* Git
* Bash (WSL, Git Bash, Linux, macOS)

No local Ruby or PostgreSQL installation required.

---

## 🧰 First Time Setup

Clone the repository:

```bash
git clone <repo>
cd <repo>
```

Ensure Docker is running, then start the environment:

```bash
./scripts/start.sh --clean
```

This will:

* build Docker images
* create the database
* run migrations
* start the Rails server
* stream logs

Once running, open:

```
http://localhost:3000
```

---

## 🧪 Development Scripts

This project includes helper scripts to make working with Docker and the Rails app easier during development.

---

### `scripts/start.sh`

Used for running the Rails server inside Docker and viewing logs and incoming requests.

#### Usage

```bash
./scripts/start.sh
```

Starts the server and streams logs (similar to `docker compose up`), allowing you to see requests as they come in.

#### Clean Start

```bash
./scripts/start.sh --clean
```

This will:

* stop and remove all containers and volumes
* rebuild images
* start the server
* stream logs

Use this when:

* dependencies or images have changed
* you want a clean environment

#### Restart Without Cleanup

```bash
./scripts/start.sh --go
```

Restarts the server without tearing anything down.

Use this for fast restarts during development.

---

### `scripts/test.sh`

Used for running the application environment and manually executing tests inside the container.

#### Usage

```bash
./scripts/test.sh
```

Starts the database and app container, then opens a bash session inside the app container.

You can then run:

```bash
bundle exec rspec
rails console
bin/rails db
```

#### Clean Reset

```bash
./scripts/test.sh --clean
```

This will:

* stop and remove containers
* remove Docker volumes (including the database)
* rebuild images
* recreate and migrate the database
* open a bash session inside the app container

Use this when:

* migrations have changed
* the database becomes inconsistent
* you want a fully fresh environment

---

### 🧭 Script Summary

| Command                      | Action                               |
| ---------------------------- | ------------------------------------ |
| `./scripts/start.sh`         | Start server + stream logs           |
| `./scripts/start.sh --clean` | Full teardown + rebuild + run server |
| `./scripts/start.sh --go`    | Restart server only                  |
| `./scripts/test.sh`          | Start environment + open bash        |
| `./scripts/test.sh --clean`  | Full teardown + rebuild + bash       |

---

## ✅ Running Tests

To enter the container and run tests manually:

```bash
./scripts/test.sh
```

Then inside the container:

```bash
bundle exec rspec
```

---

## 🐛 Common Issues (Windows / Docker)

### 🔹 "A server is already running"

Cause: a stale PID file

Fix:

```bash
rm -f tmp/pids/server.pid
./scripts/start.sh
```

`entrypoint.sh` also removes this automatically.

---

### 🔹 Database already exists / migrations not applying

Run:

```bash
./scripts/test.sh --clean
```

---

### 🔹 CRLF line ending warnings

Example:

```
warning: CRLF will be replaced by LF
```

Fix:

```bash
git config --global core.autocrlf input
git add --renormalize .
git commit -m "Normalize line endings"
```

Also set VS Code to `LF`.

---

### 🔹 Permission denied when running scripts

```bash
chmod +x scripts/*.sh
```

---

### 🔹 PostgreSQL connection errors

If you see:

```
could not connect to server: Connection refused
```

The DB may still be starting.

Fix:

```bash
./scripts/start.sh --go
```

or retry after a few seconds.

---

If issues persist, reset everything:

```bash
./scripts/test.sh --clean
```

---

## ✅ Development Workflow (recommended)

Typical loop:

```
edit code
./scripts/start.sh --go
check logs / browser
./scripts/test.sh
run rspec
repeat
```

This keeps development fast and isolated within Docker.

---

## 📄 License

MIT
