# 📘 Domain Glossary — Bookkeeping CQRS

## 1️⃣ Business (Aggregate Root)

**Definition:**
Represents a company using the system; owns all ledger accounts, contacts, artefacts, and transactions.

**Attributes:**

* `business_id` (UUID)
* `name`
* `currency` (optional)
* `timezone` (optional)
* `address`:

  * `street_address`, `city`, `state/region`, `postal_code`, `country` (**required**)
* Optional: `email`, `phone`, `tax_number`

**Responsibilities:**

* Owns chart of accounts and contacts
* Ensures uniqueness and multi-tenancy isolation
* Delegates artefact posting to Transactions

**Events:**

* `BusinessRegistered`
* `BusinessAddressUpdated`
* `LedgerAccountCreated`
* `ContactCreated`

---

## 2️⃣ Contact (Aggregate or Entity)

**Definition:**
A party that the business interacts with financially.

**Attributes:**

* `contact_id` (UUID)
* `business_id`
* `name`
* `type` (`customer` / `supplier`)
* `address`:

  * `street_address`, `city`, `state/region`, `postal_code`, `country` (**required**)
* Optional: `email`, `phone`, `tax_number`

**Relationships:**

* Linked to Artefacts (Invoices / Credit Notes)

**Events:**

* `ContactCreated`
* `ContactUpdated`

---

## 3️⃣ LedgerAccount (Child of Business)

**Definition:**
A financial account within the chart of accounts.

**Attributes:**

* `ledger_account_id` (UUID or code)
* `name`
* `account_type` (Asset, Liability, Equity, Income, Expense)
* `description` (optional)
* `active` (boolean)

**Responsibilities:**

* Hold metadata; balances are derived via projections
* Validation of uniqueness within Business

**Events:**

* `LedgerAccountCreated`
* `LedgerAccountUpdated`

---

## 4️⃣ Artefact (Child of Business)

**Definition:**
A business document representing a financial event (source document).

**Types:**

* `SalesInvoice`
* `SalesCreditNote`
* `PurchaseInvoice`
* `PurchaseCreditNote`

**Attributes:**

* `artefact_id` (UUID)
* `business_id`
* `contact_id`
* `status` (`draft`, `posted`, `voided`, etc.)
* `line_items` (collection of LineItem objects)
* `memo` / `description`
* `issue_date`, `due_date` (optional)

**Responsibilities:**

* Validate line items and contacts
* Emit high-level events (does **not** post directly to ledger)

**Events:**

* `ArtefactCreated`
* `ArtefactPosted`

---

## 5️⃣ LineItem (Value Object)

**Definition:**
A single row in an Artefact representing an amount affecting a LedgerAccount.

**Attributes:**

* `line_item_id` (UUID)
* `reference` (e.g., SKU or service code)
* `net_amount`
* `ledger_account_id`
* `tax_rate`
* `tax_amount` (calculated)

**Responsibilities:**

* Immutable once created
* Used by Transactions to generate LedgerEntries

---

## 6️⃣ Transaction (Aggregate, scoped to Business)

**Definition:**
A financial operation that updates ledger accounts based on an Artefact.

**Attributes:**

* `transaction_id` (UUID)
* `business_id`
* `artefact_id`
* `timestamp`
* `entries` (derived LedgerEntries)

**Responsibilities:**

* Validate double-entry rule (sum debits = sum credits)
* Ensure all LedgerAccounts exist and belong to the Business
* Emit `TransactionRecorded` event

**Events:**

* `TransactionRecorded`

---

## 7️⃣ LedgerEntry (Value Object)

**Definition:**
Atomic debit or credit movement applied to a LedgerAccount.

**Attributes:**

* `ledger_entry_id` (UUID)
* `ledger_account_id`
* `transaction_id`
* `amount`
* `direction` (`debit` / `credit`)

**Responsibilities:**

* Immutable once created
* Used in projections to compute balances

---

## 8️⃣ Chart of Accounts

**Definition:**
The full set of LedgerAccounts available to a business.

**Responsibilities:**

* Validate account codes/names
* Categorize accounts by type

---

## 9️⃣ Journal / Audit Trail

**Definition:**
Chronological record of all Transactions and Artefacts for a business.

**Responsibilities:**

* Immutable
* Replayable for projections or audits
* Scoped by business

**Notes:**

* In event-sourced design, the Event Store **is the journal**

---

## 10️⃣ Events & Commands (Summary)

**Commands:** `CreateBusiness`, `CreateContact`, `CreateLedgerAccount`, `CreateArtefact`, `PostArtefact`, `CreateTransaction`

**Events:** `BusinessRegistered`, `BusinessAddressUpdated`, `ContactCreated`, `LedgerAccountCreated`, `ArtefactCreated`, `ArtefactPosted`, `TransactionRecorded`

