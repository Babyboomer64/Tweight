# Architecture Decision Record (ADR)

## 📝 Title

Database Abstraction Layer (PostgreSQL / Oracle / Progress)

------------------------------------------------------------------------

## 🎯 Context

The project **Tweight** must remain **database-agnostic**.\
We intend to support **multiple databases** (initially PostgreSQL,
Oracle, and Progress) without rewriting business logic.\
A clean abstraction ensures: - Long-term flexibility\
- Parallel DB usage (migration, testing, fallback)\
- Reduced vendor lock-in

------------------------------------------------------------------------

## ✅ Decision

We introduce a **Database Abstraction Layer**:\
- Core repositories interact with an **abstract interface**.\
- Specific DB implementations (PostgreSQL, Oracle, Progress) are
encapsulated in separate adapters.\
- SQL-specific code is not exposed to the application layer.

**Alternatives considered:**\
1. Direct SQL in repositories → rejected (hard to swap DB).\
2. ORM (e.g., EF Core) → rejected for now (less control, high
abstraction overhead).

**Chosen approach:** Abstract repositories + hand-optimized SQL per DB
adapter.

------------------------------------------------------------------------

## 📐 Consequences

**Positive:**\
- Enables multi-DB strategy.\
- Easy integration of future DBs.\
- Business logic remains untouched.

**Negative:**\
- Slightly higher initial effort.\
- More code to maintain (separate adapters).

**Risks:**\
- Risk of feature mismatch (e.g., different JSON/Spatial support per
DB).\
- Requires discipline in keeping abstraction clean.

------------------------------------------------------------------------

## 🔄 Status

Accepted ✅

------------------------------------------------------------------------

## 📅 Metadata

-   Date: 2025-08-17\
-   Author: Christian Moser
