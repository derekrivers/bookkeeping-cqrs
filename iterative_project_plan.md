# 📌 Iterative Project Plan — Bookkeeping CQRS

## Phase 0 — Foundation

**Goal:** Establish core project infrastructure and readiness.

**Steps:**

1. GitHub repo & branches set up (done)
2. Rails 8 app scaffold (done)
3. Domain Glossary documented (done)
4. CI/CD skeleton (Circle/GitHub Actions)

**Deliverables:**

* Working Rails app skeleton
* `domain_glossary.md` finalized
* CI/CD workflow skeleton

---

## Phase 1 — Core Aggregates & Event Store

**Goal:** Implement minimal event-sourced backbone with one aggregate.

**Iteration 1 — Business & LedgerAccount**

* Create `Business` aggregate with basic attributes and address
* Create `LedgerAccount` creation command + event
* Simple projection to list accounts

**Iteration 2 — Contact**

* Implement `Contact` aggregate with mandatory country
* Commands/events for `ContactCreated` and optional update
* Projection to list contacts per business

**Iteration 3 — Artefacts**

* Implement minimal `Artefact` (draft state only)
* Add simple LineItems as value objects
* Event: `ArtefactCreated`

**Deliverables for Phase 1:**

* Event Store integrated
* Business, LedgerAccounts, and Contacts are fully event-sourced
* Artefact creation works and is persisted

---

## Phase 2 — Transactions & Posting

**Goal:** Enable posting of artefacts to generate financial transactions.

**Iteration 1 — Transaction Aggregate**

* Transaction aggregate validates double-entry rule
* Generates `LedgerEntries` based on Artefact LineItems

**Iteration 2 — Artefact Posting**

* Artefact emits `ArtefactPosted`
* Triggers Transaction aggregate
* Projections update LedgerAccount balances

**Deliverables:**

* Artefact posting works for one type (e.g., SalesInvoice)
* Ledger balances are updated via projections
* Audit trail available

---

## Phase 3 — Multi-Artefact & Multi-Business

**Goal:** Expand features to support all artefact types and multiple businesses.

**Iteration 1 — Purchase Artefacts**
**Iteration 2 — Credit Notes**
**Iteration 3 — Multi-business testing & isolation**

**Deliverables:**

* Full coverage of artefact types
* Multi-business validation
* Reporting projections for balances & journals

---

## Phase 4 — Additional Features

**Goal:** Add enhancements, reporting, and usability.

* Tax handling per country
* Payment tracking & reconciliation
* Export reports & dashboards
* Search, filters, and validations

---

### Key Principles

1. Small, independent iterations → each deliverable is testable and deployable
2. Event-sourcing first → everything is logged and replayable from day one
3. Minimal domain per iteration → start with Business → LedgerAccount → Contact → Artefact → Transaction
4. Projections for feedback → always verify business state with read models before adding next complexity
