# DB Version-6 Configuration

### Deploy in Localhost {DB server}
```
psql -h localhost -U digistack_app -d digistack_bank -f V4__add_frozen_flag.sql
```
> **Expected result:**
>
> ```
> ALTER TABLE
> COMMENT
> ```
>
> Two lines of output, no errors. `ALTER TABLE` confirms the column was added. `COMMENT` confirms the column description was recorded.

# Verification DB
## 🔍 Step 9 — Verify the Column Exists and Has the Correct Default

Connect to psql:

```bash
psql -U digistack_app -d digistack_bank
```

Describe the `accounts` table:

```sql
\d accounts
```

> **Expected result:** The column list now includes:
>
> ```
>  is_frozen | boolean | not null default false
> ```
>
> The column is present, its type is `boolean`, it is not nullable, and its default is `false`.

---

## 🧾 Step 10 — Verify All Existing Rows Defaulted to FALSE

```sql
SELECT account_id, account_number, is_frozen FROM accounts;
```

> **Expected result:** Every row in the table shows `f` (PostgreSQL prints `f` for false) in the `is_frozen` column. No row is frozen. All existing accounts defaulted to unfrozen exactly as intended.

---

## 🚪 Step 11 — Exit psql

```
\q
```

---
