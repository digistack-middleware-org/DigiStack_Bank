# SetupDoc-v2.md
# DigiStack Bank — P01 Version 2
# Title: Login & Session

---

## §1 Overview

Version 2 adds authentication and HTTP session management to the
DigiStack Bank application. A `users` table is created in PostgreSQL
with salted SHA-256 password hashing. Three new servlets are introduced:
`LoginServlet` (credential validation, session creation),
`DashboardServlet` (session guard, post-login landing page),
and `LogoutServlet` (session invalidation). The Dashboard shows a
time-of-day greeting, last login timestamp (security signal), account
summary placeholder, and quick action tiles (all disabled until v3).
The EAR is renamed from `digistack-bank-v1.ear` to
`digistack-bank-v2.ear` per the project naming standard. The v1
application (`digistack-bank-v1`) is uninstalled and replaced by
`digistack-bank-v2` — context root `/digistack-bank` is unchanged.

WebSphere topic: JVM/Application startup behaviour, HTTP session
creation, session-scoped logs, EAR redeploy (v2 over v1 — different
application name, same context root).

---

## §2 VM Setup

Same two VMs as v1. No new VMs powered on this version.

| VM | Role | IP | vCPU | RAM | Status |
|---|---|---|---|---|---|
| dsb-dmgr | Standalone WAS AppServer | 192.168.10.10 | 2 | 3 GB | Running |
| dsb-db | PostgreSQL 16 | 192.168.10.30 | 2 | 2 GB | Running |

Version-specific items:
- `V2__create_users.sql` migration added `users` table to `digistack_bank`
- `SeedUsers.java` utility run on Windows laptop to set correct
  SHA-256 password hashes for both seed users
- `digistack-bank-v1` uninstalled from WAS; `digistack-bank-v2`
  installed in its place
- Development: Windows laptop (VSCode + Maven) — code written here,
  EAR built here, copied to dsb-dmgr via scp for deployment

---

## §3 Pre-Deployment Checklist

- [x] **01_Architecture diagram check** — opened `01_Architecture/README.md`.
      Triggers checked for v2:
      `06_Database_ER_Diagram.md` — triggers at v2 (`users` table added).
      Updated to show `users` table alongside `app_config`.
      `03_Request_Flows.md` — extended to include Login flow
      (Browser → LoginServlet → PostgreSQL → Dashboard redirect).
      All other diagrams: no new trigger at v2 — untouched.
- [x] Previous SetupDoc verified — SetupDoc-v1.md reviewed and confirmed
      complete before v2 work began
- [x] VM snapshot taken — dsb-dmgr and dsb-db snapshotted in VMware
      Workstation before Sprint 1 work began
- [x] Git branch created — `feature/v2-login`, created at Sprint 1 Step 8

---

## §4 Step-by-Step Configuration

### §4.1 WebSphere Admin Console Steps

1. Navigated to `http://192.168.10.10:9060/ibm/console`, logged in
   as `wasadmin`. Result: Welcome page loaded.

2. Applications → Application Types → WebSphere enterprise applications
   → tick `digistack-bank-v1` → Stop.
   Result: status changed to red X (Stopped).

3. Tick `digistack-bank-v1` → Uninstall → OK → Save.
   Result: `digistack-bank-v1` removed from application list.

4. Install → Local file system → Browse →
   `digistack-bank-v2.ear` → Next → Next (defaults) →
   Confirm WAR mapped to `server1`, virtual host `default_host` →
   Finish → Save.
   Result: `Application digistack-bank-v2 installed successfully.`

5. Tick `digistack-bank-v2` → Start.
   Result: green arrow ▶ next to `digistack-bank-v2`.

6. Verified Manage Modules: WAR mapped to `server1`,
   virtual host `default_host`. Context root: `/digistack-bank`.

### §4.2 wsadmin / Command-Line Steps

1. Deployment script — `scripts/v2_deploy.py` run via:
