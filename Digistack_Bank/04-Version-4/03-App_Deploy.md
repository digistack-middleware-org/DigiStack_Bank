# Rollback the Deployment LAB

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
## Version-3 Application to Build {Version-4 Fail need to redeploy Version-3}

01- Goto Version-3 Project directory.
```
mvn clean package
```
Generated artifact ==> digistack-bank-ear/target/digistack-bank-v1.ear

02- Move the V3.ear file to /opt
```
sudo cp digistack-bank-ear/target/digistack-bank-v1.ear /opt
```
## Version-4 Application to Build 
01- Goto Version-4 Project directory.
```
mvn clean package
```
Generated artifact ==> digistack-bank-ear/target/digistack-bank-v4.ear

02- Move the V3.ear file to /opt
```
sudo cp digistack-bank-ear/target/digistack-bank-v4.ear /opt
```
## Check we have Both Versions in /opt
```
la -altr /opt
```


# Deploy the Application
```
1. Log into Admin Console ==> https://<vm-ip>:9043/ibm/console
2. Go to ==> Applications → All Applications
		Find the existing application:
			digistack-bank
3. Open the application and click Update.
4. On the Preparing for the application update screen, choose -> Replace the entire application
			This tells WebSphere to replace the currently deployed EAR contents with the new EAR while keeping the existing application identity and configuration.
5. Select the new EAR:
		Choose Remote file system because the EAR is already on the WebSphere VM → Browse → navigate to: /opt/staging/ears/digistack-bank-v4.ear → Next
6. On the Select Installation Options / Update Options screen:
		Leave the existing application configuration unchanged.
		Confirm the application being updated is still -> digistack-bank-v1
		Do not create a new application name such as digistack-bank-v4.
		Click Next.

7. On Map Modules to Servers:
	Confirm the existing mapping is still:

		Module: digistack-bank-web
		Target: server1
		Node: devdsbinnode01

			Do not change the deployment target.
			This is one of the key things we're verifying with Update: the existing deployment mapping is preserved.

				Click Next.

8. On Map Virtual Hosts for Web Modules:
	Confirm:
			Module: digistack-bank-web
			Virtual host: default_host

9. Do not change the virtual host.
	The existing virtual-host mapping should remain intact.

		Click Next.

Continue through the remaining screens.
Confirm the existing context root remains:

		/digistack-bank

```
# Verification
1. Open a browser and go to:
```
http://dsb-dmgr.digistack.cloud:9080/digistack-bank/login
```
2. Login with Username and Password

```
Username: testuser
Password: Password123!
```

