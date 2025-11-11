
---

## 🧱 `ARCHITECTURE.md`

```markdown
# Architecture Overview

This document outlines the technical and domain architecture of the
**Bookkeeping CQRS** project.

---

## ⚙️ Core Principles

1. **Event Sourcing**
   - Every change in the system is captured as an immutable domain event.
   - State is rebuilt by replaying events, not by mutating data directly.

2. **CQRS (Command Query Responsibility Segregation)**
   - The system is split into two distinct models:
     - **Command side:** Handles writes, validates business rules, emits events.
     - **Query side:** Handles reads using projections built from events.

3. **Double-Entry Accounting Integrity**
   - Every transaction must maintain:  
     **Σ(debits) = Σ(credits)**
   - This invariant is enforced by aggregates before events are persisted.

---

## 🧩 Main Components

| Component | Responsibility |
|------------|----------------|
| **Command** | Represents user intent, e.g. `CreateTransaction`. |
| **Command Handler** | Validates command and delegates to aggregate. |
| **Aggregate** | Domain entity that enforces invariants (e.g., Ledger or Account). |
| **Event** | Immutable record of something that happened. |
| **Event Store** | Persists and publishes events. |
| **Projector** | Consumes events to build read models (e.g., account balances). |
| **Query** | Fetches precomputed data for display or reporting. |

---

## 🧠 Example Flow

1. User submits a transaction command.
2. Command handler validates and loads the aggregate.
3. Aggregate checks double-entry balance and applies domain logic.
4. If valid, emits a `TransactionRecorded` event.
5. Event is persisted and published to projectors.
6. Projectors update read models (e.g., account summaries).

---

## 🧰 Tech Stack

- **Ruby 3.4**
- **Rails 8**
- **RailsEventStore**
- **AggregateRoot**
- **PostgreSQL**
- **RSpec**
- **GitHub Actions (CI)**

---

## 🧮 Future Extensions

- Web UI for transaction entry and reporting.
- Event replayer for audit and debugging.
- Multi-user and organization support.
- JSON:API or GraphQL endpoints for integration.
