# Build and Deploy the Application

## Install the Build Tool
1. Install Java

```
sudo dnf install -y java-1.8.0-openjdk-devel
java -version
```
2. Install GIT
```
sudo dnf install git -y
```

4. Install Maven

```
sudo dnf install -y maven
mvn -version
```
5. Clone the Repository
```
git clone <Repo-URL>
```
## Build the Application

From the project directory.
```
mvn clean package
```
Generated artifact ==> digistack-bank-ear/target/digistack-bank-v1.ear

# Deploy the Application
<img width="680" height="280" alt="image" src="https://github.com/user-attachments/assets/74ba242d-b2b2-47d6-9216-6b706773c299" />


# Verification
1. Open a browser and go to:
```
http://dsb-dmgr.digistack.cloud:9080/digistack-bank/Home
```
Expected result: Page displays: ==> "DB Read Successful: DigiStack Bank is live - Version 1"

2. Confirm the log entry
On dsb-dmgr, run:
```
grep "AppConfigTestServlet" /apps/IBM/WebSphere/AppServer/profiles/devdsbinappserver01/logs/server1/SystemOut.log
```
