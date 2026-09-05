# Node Synchronization Deep-Dive
---

## 📖 Concepts First — Read Before Touching Anything

These six terms appear throughout the sprint. Learn them now so every step makes sense.

| Term | Meaning |
|---|---|
| **Cell** | The top-level grouping in a WAS ND environment. Everything belongs to one cell: your DMgr, both nodes, all servers. Your cell is named `devdsbincell01`. |
| **Node** | A logical grouping of one or more application servers on a single host machine. You have two: `devdsbinnode01` (on `dsb-dmgr`, 192.168.10.10) and `devdsbinnode02` (on `dsb-node02`, 192.168.10.11). |
| **Node Agent** | A background WAS process that runs on each node host (not the DMgr). Its sole job is to relay configuration changes from the DMgr down to the app servers on that node, and relay management commands back up. Think of it as a "post office" between the DMgr and your application servers. |
| **DMgr Master Repository** | The DMgr holds the authoritative copy of all configuration for the entire cell at: `/apps/IBM/WebSphere/AppServer/profiles/devdsbindmgr01/config/` — Every change you make in the Admin Console is written here first. |
| **Node Local Repository** | Each node keeps its own local copy of configuration. The app servers on that node read this local copy they do not go to the DMgr directly. Node's local copy lives at: `/apps/IBM/WebSphere/AppServer/profiles/devdsbinappserver01/config/` |
| **Configuration Drift** | When the node's local repository differs from the DMgr master. This happens two ways: **(a)** DMgr made a change but the node hasn't received it yet — *DMgr-side drift*; **(b)** someone directly edited a file on the node, bypassing the DMgr — *node-side drift*. Today's lab covers both, and you will see that they require different remedies. |

### Node Sync vs Full Resync — the core distinction

| | Node Sync | Full Resynchronization |
|---|---|---|
| **What it does** | Pushes only changes (delta) from DMgr → node | Sends DMgr's entire config as a complete overwrite to the node |
| **Fixes DMgr-side drift?** | ✅ Yes | ✅ Yes |
| **Fixes node-side drift?** | ❌ No | ✅ Yes |
| **Speed** | Fast | Slower — transfers everything |
| **When to use** | Routine — after every config change | When a node is suspected to have been manually altered, or is badly out of sync |

---

## ✅ Prerequisites — Confirm the Environment is Running

### Step 1
Open **VMware Workstation** on your Windows laptop.

### Step 2
Confirm these VMs are powered on: `dsb-dmgr`, `dsb-node02`, `dsb-db`. Power on any that are off. (`dsb-ihs` is not needed for this sprint but leave it in whatever state it is.)

### Step 3
Open a terminal on your Windows laptop and SSH into `dsb-dmgr`:

```bash
ssh wasadmin@192.168.10.10
```

> **Expected result:** You land at the Linux shell prompt for `dsb-dmgr`.

### Step 4
Check which WAS Java processes are running on `dsb-dmgr`:

```bash
ps -ef grep java | grep -v grep
```

> **Expected result:** You should see at least **three** Java processes in the output:
> - One process whose arguments include `devdsbindmgr01` — this is the **Deployment Manager**
> - One process whose arguments include `nodeagent` and `devdsbinnode01` — this is the **Node Agent for node01**
> - One process whose arguments include a cluster server name — this is the **cluster member on node01**

### Step 5
Open a second terminal window and SSH into `dsb-node02`:

```bash
ssh wasadmin@192.168.10.11
```

### Step 6
Check WAS processes on `dsb-node02`:

```bash
ps -ef | grep java | grep -v grep
```

> **Expected result:** At least **two** Java processes — a Node Agent process and a cluster member process.

### Step 7
If any process from Steps 4 or 6 is missing, start them in this order. Run each command and wait for **"open for e-business"** confirmation before the next.

**Start the DMgr** (run on `dsb-dmgr`):

```bash
/apps/IBM/WebSphere/AppServer/profiles/devdsbindmgr01/bin/startManager.sh
```

**Start the Node Agent on node01** (run on `dsb-dmgr`):

```bash
/apps/IBM/WebSphere/AppServer/profiles/devdsbinappserver01/bin/startNode.sh
```

**Start the Node Agent on node02** ( on `dsb-node02`):

```bash
/apps/IBM/WebSphere/AppServer/profiles/devdsbinnode02/bin/startNode.sh
```

**Start the cluster members via the Admin Console** after all agents are confirmed running:
`Servers → Clusters → devdsbinappcluster01 → Start`

---

## 🅰️ Part A — Normal Node Sync (Baseline — Everything Working)

We first trigger a healthy Node Sync to confirm the channel works and to give you a reference point before we introduce drift.

### Method 1 — Admin Console (GUI)

### Step 8
On your Windows laptop, open a browser and navigate to:

```
http://192.168.10.10:9060/ibm/console
```

### Step 9
Log in with your WAS admin credentials.

### Step 10
In the left navigation panel expand **System Administration**.

### Step 11
Click **Nodes**.

> **Expected result:** A table appears listing both nodes — `devdsbinnode01` and `devdsbinnode02`. Each shows a status (Synchronized, or a timestamp of last sync).

### Step 12
Click the checkbox to the left of `devdsbinnode01` to select it.

### Step 13
In the action bar directly above the table, click the **Synchronize** button.

> ⚠️ **Do NOT click Full Resynchronize** — that is a different button. We want **Synchronize** for this step.

> **Expected result:** A status message appears at the top of the page ("S was completed successfully for node devdsbinnode01" or similar). The node row shows an updated timestamp.

### Step 14
Click the checkbox to the left of `devdsbinnode02`.

### Step 15
Click **Synchronize** again.

> **Expected result:** Same success message for node02.

**What just happened:** The DMgr compared its master repository against each node's local config and pushed any pending differences. Because the environment is already clean at this point, it was essentially confirming everything is in agreement — like a "nothing to update" comparison. The important thing is the sync channel is open and both nodes responded.

### Method 2 — wsadmin (Jython) — Same Action via Command Line

### Step 16
On your `dsb-dmgr` terminal, navigate to the DMgr bin directory:

```bash
cd /apps/IBM/WebSphere/AppServer/profiles/devdsbindmgr01/bin/
```

### Step 17
Start an interactive wsadmin session:

```bash
./wsadmin.sh -lang jython -host localhost -port 8879 - wasadmin -password <your-wasadmin-password>
```

> 💡 **wsadmin explained:** This is IBM's command-line administration tool. Everything you can do in the Admin Console GUI can be done here via script. `-lang jython` tells it to use Python-style syntax. Port `8879` is the DMgr's SOAP connector port — this is wsadmin communicates with the DMgr.

> **Expected result:** After several seconds of startup messages, you see the prompt:
>
> ```
> wsadmin>
> ```
>
> No error messages. If you see `WASX7246E` (connection refused), the DMgr is not running — go back to Step 7.

### Step 18
At the wsadmin prompt, list the NodeSync MBeans for both nodes:

```python
print AdminControl.queryNames("type=NodeSync,*")
```

> 💡 **MBean explained:** MBean stands for *Managed Bean* — a runtime object inside WAS that you can query and control. Each node agent exposes a NodeSync MBean that represents the sync operation for that node.

> **Expected result:** Two long strings separated by a newline, one per node. They look like:
>
> ```
> WebSphere:name=NodeSync,process=nodeagent,platform=proxy,node=devdsbinnode01,...
> WebSphere:name=NodeSync,process=nodeagent,platform=proxy,node=devdsbinnode02,...
> ```

### Step 19
Synchronize node01 via wsadmin:

```python
sync1 = AdminControl.queryNames("type=NodeSync,node=devdsbinnode01,*")
result1 = AdminControl.invoke(sync1, "sync")
print result1
```

> **Expected result:** The output is `true`. No exception or stack trace.

### Step 20
Synchronize node02 via wsadmin:

```python
sync2 = AdminControl.queryNames("type=NodeSync,node=devdsbinnode02,*")
result2 = AdminControl.invoke(sync2, "sync")
print result2
```

> **Expected result:** `true` again.

### Step 21
Exit wsadmin:

```python
exit
```

**What just happened:** You performed the identical "Synchronize" action from Method 1, but entirely from the command line. In a real enterprise, this exact code lives inside a shell script that an automation system calls after every config change — so nodes stay in sync without anyone touching the GUI.

---

## 🅱️ Part B — Create a Deliberate Configuration Drift (Node-Side)

Now we simulate real-world mischief: someone directly edits a configuration file on the node, bypassing the DMgr entirely. The DMgr has no idea this happened.

We will add a dummy entry to a configuration file that belongs to node01's local repository. The DMgr's copy of this file will remain clean.

### Step 22
On your `dsb-dmgr` terminal, navigate to node01's config directory:

```bash
cd /apps/IBM/WebSphere/AppServer/profiles/devdsbinappserver01/config/cells/devdsbincell01/nodes/devdsbinnode01/
```

### Step 23
List the files here to confirm you are in the right place:

```bash
ls -la
```

> **Expected result:** You see several XML files. One of them is `variables.xml`. This file stores environment variable definitions specific to this node.

### Step 24
Open `variables.xml` in the vi text editor:

```bash
vi variables.xml
```

> **Expected result:** The file opens displaying XML content. You can see a `<variableMap>` element with some `<entries>` lines inside it.

### Step 25
You to add one line inside the `<variableMap>` block. Follow these vi steps exactly — one action per sub-step:

1. Press the **Down arrow key** to move your cursor down through the file until you are on the line that contains `</variableMap>` (the closing tag — it has a forward slash after the opening angle bracket).
2. Press the letter **O** (capital O) — this opens a new blank line directly above your cursor and switches vi into insert mode. You will see `-- INSERT --` at the bottom of the screen.
3. Type this entire line exactly as shown (one continuous line, no line breaks):

```xml
<entries xmi:id="VariableSubstitutionEntry_DRIFT_TEST" symbolicName="DRIFT_TEST_VAR" value="drifted_rogue_value"/>
```

4. Press **Esc** to leave insert mode. The `-- INSERT --` disappears from the bottom.
5. Type `:wq` and press **Enter** to save and quit.

> **Expected result:** The terminal returns to the command prompt. No error from vi.

### Step 26
Confirm the drift entry was written successfully:

```bash
grep "DRIFT_TEST" variables.xml
```

> **Expected result:**
>
> ```
> <entries xmi:id="VariableSubstitutionEntry_DRIFT_TEST" symbolicName="DRIFT_TEST_VAR" value="drifted_rogue_value"/>
> ```

**What just happened:** Node01's local `variables.xml` now has an entry that the DMgr master repository does **NOT** have. The environments have diverged — the node is "drifted." In the real world, this represents a well-meaning (or reckless) admin who SSHed onto the server and edited a config file by hand to "quickly fix" something. This is a well-known anti-pattern in WAS clusters and exactly the kind of incident you will be diagnosing in Sprint 8.

---

## 🔍 Part C — Observe That Normal Sync Cannot Fix Node-Side Drift

### Step 27
Return to the Admin Console in your browser.

### Step 28
Navigate to `System Administration → Nodes`.

### Step 29
Select `devdsbinnode01` and click **Synchronize** (the normal sync, not Full Resynchronize).

> **Expected result:** The sync reports success. Status shows Synchronized with a fresh timestamp. The Admin Console shows no error or warning.

### Step 30
Go back to your `dsb-dmgr` terminal and check whether the drift is still there:

```bash
grep "DRIFT_TEST" /apps/IBM/WebSphere/AppServer/profiles/devdsbinappserver01/config/cells/devdsbincell01/nodes/devdsbinnode01/variables.xml
```

> **Expected result:** The line is **still there**. Normal sync did not remove it.

**Why?** Normal Node Sync is a one-way operation: DMgr pushes its changes to the node. The DMgr has no record of `DRIFT_TEST_VAR` — it was added directly to the node, not through the DMgr. So when DMgr compares its copy against the node's copy, it sees no differences on its side and pushes nothing. The rogue entry survives completely untouched. This is the limitation that Full Resynchronize is designed to solve.

---

## 🛠️ Part D — Full Resynchronization via Admin Console (Corrects the Drift)

### Step 31
In the Admin Console, navigate to `System Administration → Nodes`.

### Step 32
Select the checkbox next to `devdsbinnode01`.

### Step 33
Look in the action bar above the node table. You will see a **Full Resynchronize** button (separate from the Synchronize button). Click **Full Resynchronize**.

> 💡 **Full Resynchronize explained:** Instead of comparing and pushing only deltas, Full Resync sends the DMgr's **entire** configuration for that node as a complete replacement. The node's local config directory is overwritten with what the DMgr holds. Any rogue addition that the DMgr doesn't know about is simply erased — the node ends up with an exact copy of what the DMgr has.

> **Expected result:** A progress indicator appears. This takes 15–45 seconds (longer than normal sync). When complete, you see a success message confirming full resync completed for `devdsbinnode01`.

### Step 34
Verify the drift is gone:

```bash
grep "DRIFT_TEST" /apps/IBM/WebSphere/AppServer/profiles/devdsbinappserver01/config/cells/devdsbincell01/nodes/devdsbinnode01/variables.xml
```

> **Expected result:** No output at all. The command returns to the prompt with nothing printed. The rogue entry no longer exists in the file.

### Step 35
Confirm the rest of `variables.xml` looks clean (no corruption from the overwrite):

```bash
cat /apps/IBM/WebSphere/AppServer/profiles/devdsbinappserver01/config/cells/devdsbincell01/nodes/devdsbinnode01/variables.xml
```

> **Expected result:** The file contains its normal XML structure with no `DRIFT_TEST` entry anywhere. The `<variableMap>` block shows only the original legitimate entries that were there before you started this lab.

---

## ⌨️ Part E — Full Resynchronization via wsadmin (Same Correction, Command-Line Path)

Recreate the drift and fix it again — this time entirely from wsadmin — so you have both paths practiced.

### Step 36
Recreate the drift. Repeat Steps 24–26 to add the `DRIFT_TEST_VAR` entry back into `variables.xml`.

### Step 37
Confirm the drift exists again:

```bash
grep "DRIFT_TEST" /apps/IBM/WebSphere/AppServer/profiles/devdsbinappserver01/config/cells/devdsbincell01/nodes/devdsbinnode01/variables.xml
```

> **Expected result:** The rogue entry appears.

### Step 38
Start a new wsadmin session:

```bash
cd /apps/IBM/WebSphere/AppServer/profiles/devdsbindmgr01/bin/
./wsadmin.sh -lang jython -host localhost -port 8879 -username wasadmin -password <your-wasadmin-password>
```

> **Expected result:** The `wsadmin>` prompt appears.

### Step 39
Perform a Full Resync for node01 via wsadmin:

```python
sync1 = AdminControl.queryNames("type=NodeSync,node=devdsbinnode01,*")
result = AdminControl.invoke(sync1, "syncNode")
print result
```

> 💡 **`syncNode` vs `sync`:** On the NodeSync MBean, `sync` triggers a **delta synchronization**. `syncNode` triggers a **full resynchronization** — the exact equivalent of the "Full Resynchronize" button in the Admin Console. Same operation, different method name.

> **Expected result:** Prints `true`. No exception or stack trace.

### Step 40
Exit wsadmin:

```python
exit
```

### Step 41
Verify the drift is gone:

```bash
grep "DRIFT_TEST" /apps/IBM/WebSphere/AppServer/profiles/devdsbinappserver01/config/cells/devdsbincell01/nodes/devdsbinnode01/variables.xml
```

> **Expected result:** No output. Clean.

---