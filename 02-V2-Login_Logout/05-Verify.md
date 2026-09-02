# Full End-to-End Flow Test
## Flow 1 — Unauthenticated access guard
Step 5.1 — Open a fresh browser tab and navigate directly to:
```
http://192.168.10.10:9080/digistack-bank/Dashboard
```
Expected result — you are redirected to:
```
http://192.168.10.10:9080/digistack-bank/Login
```
What Achieve ==> The login page appears. You are NOT shown the Dashboard. The session guard is working.
