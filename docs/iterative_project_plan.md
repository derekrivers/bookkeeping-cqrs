# Plan of Attack — Iterative Roadmap (v2)

This document captures the revised, incremental plan for the **Bookkeeping CQRS** project. The goal is to move in small, testable steps toward a working event-sourced bookkeeping system with an API surface suitable for micro-frontends.

---

## ✅ Iteration 0 — Foundation (complete)
- Rails 8 app scaffolded
- GitHub repo + `project-setup` merged into `main`
- CI (GitHub Actions) configured and green
- Domain glossary and initial docs created
- API-first direction chosen

---

## 🧩 Iteration 1 — Event Store & Transactions (MVP CQRS Core)
**Goal:** Add the event store and the first write-side aggregate to capture transactions.

**Tasks:**
- Add `rails_event_store` and `aggregate_root` gems and configure the ActiveRecord backend.
- Define the first domain event: `TransactionRecorded`.
- Implement `Transaction` aggregate and a `CreateTransaction` command handler.
- Enforce the invariant: **sum(debits) = sum(credits)** before publishing the event.
- Add RSpec tests to assert event persistence and invariant enforcement.
- Expose a minimal JSON API endpoint: `POST /api/transactions` to submit transaction commands.

**Deliverable:** API accepts transaction commands, events are persisted to the event store, and basic tests pass.

---

## 🧱 Iteration 2 — Read Model & Projection
**Goal:** Build the query side (projections) and expose read endpoints.

**Tasks:**
- Implement a `LedgerEntriesProjection` (projector) that consumes `TransactionRecorded` and writes to `ledger_entries`/read tables.
- Create read models for account balances and ledger view.
- Add GET endpoints, e.g. `GET /api/businesses/:id/ledger_accounts` and `GET /api/businesses/:id/ledger_entries`.
- Add integration tests covering the command → event → projection → query round-trip.

**Deliverable:** Full CQRS round-trip working end-to-end.

---

## 🧾 Iteration 3 — Business & Artefacts
**Goal:** Introduce `Business` aggregate and Artefact creation (draft state).

**Tasks:**
- Implement `Business` aggregate with address and required metadata.
- Implement `CreateBusiness` command + `BusinessRegistered` event.
- Implement `Contact` aggregate with required country and address.
- Implement `Artefact` creation (draft) with line items (value objects).
- Expose API endpoints for business/contact/artefact creation.

**Deliverable:** Businesses, contacts, and artefacts can be created via API and persisted as events.

---

## 💳 Iteration 4 — Posting Artefacts → Transactions
**Goal:** Wire artefact posting to transaction creation.

**Tasks:**
- Implement `ArtefactPosted` event emitted by posting an artefact.
- Transaction aggregate consumes the artefact details and emits `TransactionRecorded` after validation.
- Ensure each transaction references its originating artefact for traceability.
- Update projections to reflect posted artefacts in account balances.

**Deliverable:** Posting an artefact triggers ledger transactions and updates read models.

---

## 📊 Iteration 5 — Reporting & Refinements
**Goal:** Add reporting projections and polish read models.

**Tasks:**
- Implement `BusinessSummaryProjection` and trial balance/report endpoints.
- Implement pagination, filtering, and basic access controls (future auth to be added).
- Performance tuning: snapshots, batching, and background projection workers as needed.

**Deliverable:** Useful reporting endpoints for frontend consumption.

---

## 🧪 Iteration 6 — Testing & Hardening
**Goal:** Improve test coverage and prepare the codebase for production-like scenarios.

**Tasks:**
- Expand unit, integration, and property tests for invariants.
- Test event replay and projection rebuilding scripts.
- Add monitoring hooks and error handling strategies for projection failures.

**Deliverable:** High confidence in domain invariants and system resilience.

---

## 🚀 Iteration 7 — Frontends & Integrations
**Goal:** Build micro-frontends and external integrations consuming the API.

**Tasks:**
- Build one or more micro-frontends (React/Vue) that consume the JSON API.
- Add authentication (JWT/OAuth) and API versioning.
- Expose webhooks and integrations for 3rd-party systems.

**Deliverable:** Product-ready frontend(s) and integration endpoints.

---

## Key Principles
1. **Small, independent iterations** — each step is testable and deliverable.
2. **Event-sourcing first** — persist events as the system of record from early on.
3. **API-first** — keep domain logic on the server and expose thin JSON endpoints.
4. **Business-centric** — all aggregates and streams are scoped by `business_id`.
5. **Projections as feedback** — use read models to verify system state before adding complexity.

---

Placeholders:
- `docs/` will contain architecture docs and API plans.
- `spec/` will house tests; CI validates tests on PRs.


*Created as the canonical iterative plan for the bookkeeping-cqrs project.*

