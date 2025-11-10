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

```bash
# Clone the repo
git clone git@github.com:derekrivers/bookkeeping-cqrs.git
cd bookkeeping-cqrs

# Install dependencies
bundle install

# Create and migrate the database
rails db:create db:migrate

# Run the test suite
bundle exec rspec
