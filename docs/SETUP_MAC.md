# Tweight – macOS Development Setup (Fresh Mac, Apple Silicon)

> Purpose: Get a **brand‑new Mac** ready to build/run **Backend (.NET/C#)**, **Frontend (React/Flutter)**, and **Mobile (iOS + Android)** for the Tweight project.

---

## 0) Assumptions
- macOS 14+ (Sonoma) on Apple Silicon (M‑series).  
- You have admin rights on the machine.

---

## 1) Command Line Tools, Rosetta, Xcode
```bash
# Xcode (install via App Store), then:
sudo xcodebuild -license accept

# Command Line Tools
xcode-select --install

# Rosetta 2 (helps with some Intel-only tools)
softwareupdate --install-rosetta --agree-to-license
```
Open **Xcode** once so it completes first‑run setup.

---

## 2) Homebrew (Package Manager)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update
```
Apple Silicon installs to `/opt/homebrew`. Add to PATH in `~/.zshrc`:
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

---

## 3) Shell & Git
```bash
# Git & useful CLI
brew install git gh wget jq tree

# Configure Git (adjust name/email)
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global pull.rebase false
git config --global init.defaultBranch main

# (Optional) GitHub CLI login
gh auth login
```
SSH key (optional):
```bash
ssh-keygen -t ed25519 -C "you@example.com"
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
pbcopy < ~/.ssh/id_ed25519.pub   # paste into GitHub
```

---

## 4) Editors & Tools
```bash
# VS Code, Cursor, iTerm2
brew install --cask visual-studio-code cursor iterm2

# Helpful VS Code extensions (IDs):
# ms-dotnettools.csharp, ms-dotnettools.csdevkit, GitHub.copilot, GitLens
# dsznajder.es7-react-js-snippets, humao.rest-client, ms-python.python
```
Open VS Code and sign in (sync settings/extensions if you use them).

---

## 5) .NET SDK (C# Backend)
```bash
brew install --cask dotnet-sdk
dotnet --version

# Global tools path (add to ~/.zshrc)
echo 'export PATH="$PATH:$HOME/.dotnet/tools"' >> ~/.zshrc
```
Quick test:
```bash
dotnet new console -o TestApp && cd TestApp && dotnet run
cd .. && rm -rf TestApp
```

---

## 6) Databases
### PostgreSQL (local dev)
```bash
brew install postgresql@16
brew services start postgresql@16
echo 'export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
createdb tweight_dev
psql -d tweight_dev -c "select version();"
```
> Oracle & Progress are **not** installed locally by default. We connect to remote instances or use Docker when needed.

(Optional) GUI clients:
```bash
brew install --cask dbeaver-community
```

---

## 7) Node.js & Package Managers
```bash
# NVM (preferred — easy version switching)
brew install nvm
mkdir -p ~/.nvm
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"' >> ~/.zshrc
source ~/.zshrc
nvm install --lts
node -v
npm -v

# Yarn (optional)
npm i -g yarn
```

---

## 8) Flutter (for iOS/Android apps)
```bash
brew install --cask flutter
flutter --version
flutter doctor
```
Add to PATH (if needed):
```bash
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.zshrc
```

**CocoaPods (iOS deps):**
```bash
sudo gem install cocoapods
pod --version
```

---

## 9) Android Toolchain
```bash
# Android Studio + SDKs
brew install --cask android-studio

# CLI config
echo 'export ANDROID_HOME="$HOME/Library/Android/sdk"' >> ~/.zshrc
echo 'export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools/bin"' >> ~/.zshrc
source ~/.zshrc
```

Open **Android Studio** → **More Actions** → **SDK Manager**:  
- Install latest **Android SDK Platform**, **Build‑Tools**, **Platform‑Tools**, **NDK** (if needed).  
- Accept licenses.

CLI accept (optional):
```bash
yes | sdkmanager --licenses
```

Create an emulator (AVD) via Android Studio (**Device Manager**).

---

## 10) iOS Toolchain
- Ensure **Xcode** is installed and opened once.  
- **Simulators:** Xcode → Settings → Platforms → install latest iOS.  
- Verify:
```bash
xcode-select -p
xcrun simctl list devices
```

---

## 11) Flutter Doctor & Mobile Check
```bash
flutter doctor -v
# Fix any red items it reports (e.g., CocoaPods, Android licenses)
```

Create and run a sample app:
```bash
flutter create sample_app
cd sample_app
flutter run   # choose iOS Simulator or Android Emulator
cd .. && rm -rf sample_app
```

---

## 12) Frontend (React) Basics
```bash
# Create React app (Vite recommended)
npm create vite@latest my-react-app -- --template react
cd my-react-app
npm install
npm run dev
```
Stop with `Ctrl+C` when done.

---

## 13) Project Clone & Environment
```bash
# Example
gh repo clone <your-org>/tweight
cd tweight

# Example env (adjust to your secrets)
cp appsettings.Development.example.json appsettings.Development.json
# set connection strings for PostgreSQL/or remote DBs
```

Run backend:
```bash
dotnet restore
dotnet build
dotnet run
```

---

## 14) Optional: Docker
```bash
brew install --cask docker
open -a Docker

# Example: Postgres via Docker (instead of Homebrew)
docker run --name pg-tweight -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=tweight_dev -p 5432:5432 -d postgres:16
```

---

## 15) Useful Quality Tools
```bash
# Linting & formatting (JS/TS)
npm i -D eslint prettier

# .NET analyzers (add to csproj as needed)
# <PackageReference Include="Microsoft.CodeAnalysis.FxCopAnalyzers" Version="3.3.2" PrivateAssets="all" />
```

---

## 16) Troubleshooting Notes
- **PATH issues**: Re‑open terminal or `source ~/.zshrc`.  
- **Xcode errors**: Open project once in Xcode; ensure command line tools set:  
  *Xcode → Settings → Locations → Command Line Tools*.  
- **Android build fails**: Check Java version (`java -version`), Android licenses, and SDK platforms.  
- **CocoaPods errors**: `sudo gem update --system && sudo gem install cocoapods`.

---

## 17) Verification Checklist
- `dotnet --version` prints a version ✅  
- `psql -d tweight_dev -c "select 1;"` works ✅  
- `flutter doctor -v` shows **no red** ✅  
- iOS Simulator runs a Flutter app ✅  
- Android Emulator runs a Flutter app ✅  
- React dev server runs (`npm run dev`) ✅

---

## FAQ
**Q: Why .NET/C#?**  
A: Strong typing, performance, mature tooling, first‑class DB drivers (PostgreSQL/Oracle/Progress), stable hosting options, and clean API design. It fits our **stable‑core + modular features** strategy.

**Q: Do I need Oracle/Progress locally?**  
A: No. For local dev we use PostgreSQL. Oracle/Progress are accessed via remote instances or containers when needed.

**Q: Which editor?**  
A: VS Code or Cursor (your choice). Keep the same extensions set for consistency.

---

## 🛠️ Roadmap for Technology Usage

### Phase 1 – Local App (Current Focus)
- **Frontend:** Flutter (cross‑platform iOS/Android)  
- **Database:** Drift + SQLite (local, offline‑first)  
- **Backend:** None – app is 100% self‑contained  
- **Use Case:** Personal productivity, offline independence  

### Phase 2 – Cloud/Server Integration (Future)
- **Backend:** C#/.NET Core services  
- **Databases:** PostgreSQL (primary), Oracle & Progress (enterprise integration)  
- **APIs:** Synchronization, team collaboration, reporting  
- **Use Case:** Multi‑user features, shared data, scalability  

### Summary
- **Now:** Local only → no .NET required for mobile developers  
- **Later:** Add backend services → app syncs with central DB via API  


---

## 18) Technology Roadmap – Phased Approach

### Phase 1 — Local‑Only App (NOW)
- **Stack:** Flutter + Drift (SQLite) on device (iOS/Android)
- **Characteristics:**
  - 100% offline capable, no backend required
  - Fast iteration, minimal ops
  - Clear data ownership on device
- **Focus:**
  - Domain model solidify (Items, Tags, Relations, Recalls, Assignees)
  - UX excellence and stability on both platforms
  - Local persistence, migrations, basic import/export

### Phase 2 — Cloud & Sync (LATER)
- **Stack:** .NET (C#) API + PostgreSQL (baseline), Oracle/Progress via adapters
- **Characteristics:**
  - Optional cloud sync, multi‑device, collaboration
  - Role‑based access and team features
  - Observability, CI/CD, versioning
- **Focus:**
  - API contracts (clean DTOs), auth, conflict resolution
  - Repository abstractions (DB‑agnostic)
  - Background sync in Flutter (opt‑in, resilient)

### Design Guardrails
- **Stable Core, Flexible Layers:** Keep the domain model stable so Phase 2 can re‑use it.
- **Sync Optionality:** The app must remain fully usable without a backend.
- **DB‑Agnostic Server:** All DB‑specific logic lives in adapters; business logic stays clean.
- **Migration Mindset:** Plan for schema evolution in SQLite and server DBs.
