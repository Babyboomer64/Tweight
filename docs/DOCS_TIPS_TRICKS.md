# Tweight – Docs Tips & Tricks

This document collects useful workflows, shortcuts, and setup hints for working with the Tweight project.

---

## 1) Markdown in VS Code / Cursor

### Live Preview
- **Shortcut:** `⇧⌘V` → Preview in the same tab.  
- **Side by Side:** `⌘K V` → left: raw Markdown, right: rendered preview.  
- **Menu:** Right‑click → *Open Preview*.  

### Recommended Extensions
- **Markdown All in One** → auto TOC, shortcuts, formatting helpers.  
- **Markdown Preview Enhanced** → diagrams (Mermaid, PlantUML), LaTeX, PDF/HTML export.  

### Handy Shortcuts
- **Bold:** `⌘B`  
- **Italic:** `⌘I`  
- **Insert TOC:** `⌘⇧P` → *Markdown All in One: Create Table of Contents*  

---

## 2) Obsidian (Optional Knowledge Archive)

- Download [Obsidian](https://obsidian.md).  
- Open the `/docs` folder as a **Vault**.  
- Features:  
  - **Backlinks:** automatic cross‑references between docs.  
  - **Graph View:** visual overview of all docs.  
  - **Wiki‑style links:** `[[Filename]]` to connect notes.  

Perfect if you want to use project docs as a **second brain**.

---

## 3) Git Tips

- **Amend last commit (e.g. message):**
```bash
git commit --amend
```

- **Clean up branches:**
```bash
git fetch --prune
git branch -d feature_branch
```

- **Clone repo with submodules:**
```bash
git clone --recurse-submodules <url>
```

---

## 4) Terminal Comfort

- **Show folder tree:**
```bash
brew install tree
tree -L 2
```

- **Pretty print JSON:**
```bash
cat file.json | jq .
```

- **Search in code:**
```bash
grep -rnw './src' -e "ItemRepository"
```

---

## 5) Flutter & Mobile

- **Start iOS simulator:**
```bash
open -a Simulator
```

- **List iOS devices:**
```bash
xcrun simctl list devices
```

- **List Android emulators:**
```bash
emulator -list-avds
```

- **Start Android emulator:**
```bash
emulator -avd <name>
```

---

## 6) PostgreSQL Tips

- **List all databases:**
```sql
\l
```

- **List all tables in current schema:**
```sql
\dt
```

- **Pretty print JSONB column:**
```sql
select jsonb_pretty(tags) from items limit 1;
```

---

## 7) Growing Document

This document should evolve as we discover new productivity tips.  
Whenever we find a useful trick, add it here.
