# Bruno API Client Collections

This directory contains Bruno collections used to interact with and test the
API endpoints of the bookkeeping-cqrs project.

## Why these are committed to source control

- They serve as living documentation of all API endpoints.
- They allow new developers to test the system immediately.
- They provide reproducible API requests for regression testing.
- They version API contract changes alongside the codebase.

## Structure

bruno/
collections/ # All request definitions
business/
create_business.bru
get_business.bru
environments/ # Environment variables for Bruno
default.json # Commit this (safe)
local.json # Ignored (machine-specific)


## How to use

1. Install Bruno
2. Import the folder `spec/support/api_clients/bruno`
3. Ensure you have a `local.json` file created if you need to override settings.
4. Run the requests against your local Rails server.

## Notes

- Never commit secrets in environment files.
- POST create_business is the first API endpoint implemented.
- As more endpoints are added (Transactions, Corrections, etc.), add collections here.
