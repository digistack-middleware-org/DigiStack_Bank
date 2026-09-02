# Deploying digistack-bank-v2.ear to WebSphere Application Server (Admin Console)

## Prerequisites
- Admin Console URL: `https://<host>:9043/ibm/console`
- EAR file already staged on the VM at `/opt/staging/ears/digistack-bank-v2.ear`

---

## Step-by-Step Deployment

### 1. Log into the Admin Console
- Open: `https://<host>:9043/ibm/console`
- Authenticate with your admin credentials.

### 2. Start the Install Wizard
- Navigate to: **Applications → New Application → New Enterprise Application**

### 3. Provide the EAR Path
- Choose **Remote file system** (since the EAR is already on the VM, not your browser's machine).
- Click **Browse** → navigate to:
  ```
  /opt/staging/ears/digistack-bank-v2.ear
  ```
- Click **Next**.

### 4. Choose Installation Path
- Select **Fast Path** (the simplified wizard — appropriate for a first deploy).
- Click **Next**.

### 5. Select Installation Options
- Leave defaults.
- Confirm **Application name** shows `digistack-bank-v1` (or similar, auto-derived from the EAR).
- Click **Next**.

### 6. Map Modules to Servers
- Select the checkbox for the `digistack-bank-web` module.
- Confirm the target server shown is:
  ```
  server1 on node devdsbinnode01
  ```
- Click **Next**.

### 7. Map Virtual Host for Web Modules
- Select the checkbox for the `digistack-bank-web` module.
- Set **Virtual host** to `default_host`
  > WAS's built-in virtual host — sufficient for this lab; a dedicated virtual host isn't required until multi-app routing needs it.
- Click **Next**.

### 8. Remaining Screens → Summary
- Continue through the remaining screens (context root should already show `/digistack-bank` from the EAR's `pom.xml`).
- Click **Next** through to the **Summary** page.

### 9. Finish Installation
- Click **Finish**.

### 10. Save the Configuration
- Wait for installation to complete (progress bar / log output appears).
- Click the **Save** link to commit to the master configuration.

---

## ✅ Deployment Complete
The application `digistack-bank-v2` is now installed and committed to the master configuration.
Verify it under **Applications → Application Types → WebSphere enterprise applications**.
