   # What we Achieve From these Version-3
  ### A user logs in, sees their live account on the Dashboard, deposits or withdraws money

  ## Request Flow
```
┌─────────────────────────────────────────────────────┐
│  1. LOGIN                                           │
│     User enters username + password                 │
└──────────────────────┬──────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────────┐
│  2. DASHBOARD             │
│                                                     │
│   Account: Savings ****4567                         │
│   Balance: $600.00                                  │
│   [⚠️ Frozen banner — only if frozen]               │
│                                                     │
│   [ Deposit / Withdraw → ]                          │
└──────────────────────┬──────────────────────────────┘
                       ↓  click
┌─────────────────────────────────────────────────────┐
│  3. ACCOUNT PAGE                        │
│                                                     │
│   Balance: $600.00                                  │
│   [ amount box ]  [Deposit] [Withdraw]              │
└──────┬──────────────────────────┬───────────────────┘
       ↓ Deposit 100↓Withdraw100            ↓ Withdraw100↓Withdraw9999
┌──────────────────────┐   ┌──────────────────────┐
│  ✅ SUCCESS           │   │  ❌ REJECTED          │
│  Redirect (PRG):     │   │  InsufficientFunds   │
│  ?success=Deposit ok │   │  Exception caught    │
│  Balance → $700.00   │   │  ?error=No funds     │
│                      │   │  Balance unchanged   │
│  Press F5 →          │   │                      │
│  NOTHING happens ✅  │   │                      │
│  (PRG protects you)  │   │                      │
└──────────┬───────────┘   └──────────┬───────────┘
           ↓                          ↓
┌─────────────────────────────────────────────────────┐
│  4. BACK TO DASHBOARD                               │
│     Balance shows $700.00 (live data!)              │
└─────────────────────────────────────────────────────┘

```
## Layer-by-Layer Request Flow
```

        BROWSER
           │
           ▼
┌─────────────────────────────┐
│  AccountServlet (Controller)│  "I received the request.
│  GET → show page            │   No SQL here. No rules here.
│  POST → do transaction      │   I just pass things along."
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│  AccountService (Rules)     │  "Is amount positive?
│  Business decisions         │   Is balance enough?
│  Throws InsufficientFunds   │   If bad → throw exception.
│  Exception if overdraft     │   If good → call DAO."
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│  AccountDao (SQL)           │  "The ONLY place SQL exists.
│  UPDATE accounts SET...     │   I take plain Java in,
│  Returns Account object     │   return Account objects out."
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│  PostgreSQL (DB)            │  "accounts table updated.
│  digistack_bank on dsb-db   │   Foreign key keeps data valid."
└─────────────────────────────┘

Then the result travels BACK UP:
DB → DAO → Service → Servlet → redirect (PRG) → fresh GET → JSP shows new balance
                                    ↓
                        log() writes to SystemOut.log 📋

```
