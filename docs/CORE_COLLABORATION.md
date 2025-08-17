# Core Collaboration Manifest

## 🎯 Purpose

To ensure **fast, stable, and transparent development** by combining
**human expertise** with **AI-driven productivity**.\
Our goal: **Build once, scale forever.**

------------------------------------------------------------------------

## 🔑 Principles

1.  **Single Source of Truth**
    -   All code, docs, and architecture live in **Git**.\
    -   **Markdown files** document architecture decisions (ADR),
        workflows, and project philosophy.\
    -   No duplication, no scattered notes -- Git is the truth.
2.  **Human + AI Balance**
    -   **Human (Christian):**
        -   Defines architecture & vision.\
        -   Makes final decisions.\
        -   Performs reviews & merges.\
    -   **AI:**
        -   Generates code and refactors.\
        -   Documents reasoning.\
        -   Assists with debugging and testing.\
    -   Goal: **Max speed, zero loss of control.**
3.  **Iterative Loops**
    -   Development in **small, reviewable units**.\
    -   Each cycle: *Input → AI proposal → Human review → Commit.*\
    -   Prevents unstable big-bang code drops.
4.  **Stable Core, Flexible Features**
    -   **Core modules**: Models, Repositories, Services.\
    -   **Features**: Independent, modular layers (UI, extensions,
        automation).\
    -   **Backend/Frontend Separation**:
        -   Backend = API (C#, PostgreSQL/Oracle/Progress).\
        -   Frontend = Independent project (React/Flutter).\
    -   Easy to swap layers (DB, UI) without breaking the system.
5.  **Database Independence**
    -   Abstraction layer ensures **PostgreSQL, Oracle, Progress** can
        run in parallel.\
    -   SQL-specific parts are encapsulated.\
    -   New DBs can be integrated later without redesign.
6.  **Continuous Documentation**
    -   Every step produces a **short note**:
        -   *Why chosen? What alternatives exist?*\
    -   Stored as `.md` files in `/docs`.\
    -   Ensures transparency for future contributors.
7.  **Error-First Mindset**
    -   Bugs and failed builds = **learning signals**.\
    -   AI assists in root cause analysis.\
    -   Human decides: *Fix vs Redesign*.\
    -   No hacks -- only clean solutions.
8.  **Transparency & Control**
    -   No hidden code changes, no "black box."\
    -   All modifications are explicit and reviewable.\
    -   Human keeps **full final authority**.

------------------------------------------------------------------------

## ⚙️ Tools & Workflow

-   **Editor/IDE:** Cursor + VS Code on macOS.\
-   **Version Control:** GitHub repository, feature branches, pull
    requests.\
-   **Docs:** Markdown (`/docs`), auto-generated & AI-supported.\
-   **Project Mgmt:** Powerlist & structured TODOs (in repo).\
-   **AI Integration:**
    -   AI supports coding, refactoring, documentation, architecture
        sketches.\
    -   Always in **dialogue**, never in isolation.

------------------------------------------------------------------------

## 📏 Coding Guidelines

-   **Naming:**
    -   DB: `snake_case` (e.g., `item_id`).\
    -   C#: `PascalCase` for classes, `camelCase` for locals.\
-   **Structure:**
    -   Models → Repositories → Services → API → UI.\
    -   Clean separation of concerns.\
-   **Commits:**
    -   Small, meaningful, one purpose per commit.\
    -   Linked to docs if architecture decision.\
-   **Tests:**
    -   AI helps generate unit tests where useful.\
    -   Priority: stability of core modules.

------------------------------------------------------------------------

## ✅ Outcomes

-   **Clarity:** Everyone knows what the system does and why.\
-   **Speed:** AI accelerates, human ensures quality.\
-   **Stability:** Core remains solid, features evolve flexibly.\
-   **Scalability:** Easy onboarding for devs, partners, investors.\
-   **Future-Proof:** Backend and frontend independent, DB-agnostic.
