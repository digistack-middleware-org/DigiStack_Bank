digistack-bank/
│
├── pom.xml
│
├── .gitignore
│
│
├── database/
│   ├── migrations/
│   │   ├── V1__initial_schema.sql
│   │   ├── V2__create_users.sql
│   │   ├── V3__create_accounts.sql
│   │   ├── V4__create_transactions.sql
│   │   └── ...
│   │
│   ├── seeds/
│   │   ├── seed_users.sql
│   │   ├── seed_accounts.sql
│   │   └── seed_transactions.sql
│   │
│   └── scripts/
│       ├── backup.sql
│       └── health_check.sql
│
├── digistack-bank-web/
│   │
│   ├── pom.xml
│   │
│   └── src/
│       │
│       ├── main/
│       │   │
│       │   ├── java/
│       │   │   │
│       │   │   └── com/
│       │   │       └── digistack/
│       │   │           └── bank/
│       │   │
│       │   │               ├── config/
│       │   │               │   ├── DatabaseConfig.java
│       │   │               │   └── AppConfig.java
│       │   │               │
│       │   │               ├── controller/
│       │   │               │   ├── HomeServlet.java
│       │   │               │   ├── LoginServlet.java
│       │   │               │   ├── LogoutServlet.java
│       │   │               │   │
│       │   │               │   ├── dashboard/
│       │   │               │   │   ├── DashboardServlet.java
│       │   │               │   │   └── BalanceJsonServlet.java
│       │   │               │   │
│       │   │               │   ├── account/
│       │   │               │   │   ├── AccountServlet.java
│       │   │               │   │   ├── AccountListServlet.java
│       │   │               │   │   └── AccountDetailsServlet.java
│       │   │               │   │
│       │   │               │   ├── customer/
│       │   │               │   │   ├── CustomerServlet.java
│       │   │               │   │   ├── CustomerListServlet.java
│       │   │               │   │   └── CustomerDetailsServlet.java
│       │   │               │   │
│       │   │               │   └── transfer/
│       │   │               │       ├── TransferServlet.java
│       │   │               │       └── TransactionServlet.java
│       │   │               │
│       │   │               ├── service/
│       │   │               │   ├── AuthService.java
│       │   │               │   ├── CustomerService.java
│       │   │               │   ├── AccountService.java
│       │   │               │   ├── TransferService.java
│       │   │               │   └── TransactionService.java
│       │   │               │
│       │   │               ├── dao/
│       │   │               │   ├── UserDao.java
│       │   │               │   ├── CustomerDao.java
│       │   │               │   ├── AccountDao.java
│       │   │               │   ├── TransferDao.java
│       │   │               │   └── TransactionDao.java
│       │   │               │
│       │   │               ├── model/
│       │   │               │   ├── User.java
│       │   │               │   ├── Customer.java
│       │   │               │   ├── Account.java
│       │   │               │   ├── Transaction.java
│       │   │               │   └── Transfer.java
│       │   │               │
│       │   │               ├── dto/
│       │   │               │   ├── LoginRequest.java
│       │   │               │   ├── AccountResponse.java
│       │   │               │   ├── TransferRequest.java
│       │   │               │   └── TransactionResponse.java
│       │   │               │
│       │   │               ├── exception/
│       │   │               │   ├── InsufficientFundsException.java
│       │   │               │   ├── AccountNotFoundException.java
│       │   │               │   ├── CustomerNotFoundException.java
│       │   │               │   ├── TransferException.java
│       │   │               │   └── ValidationException.java
│       │   │               │
│       │   │               ├── security/
│       │   │               │   ├── PasswordUtil.java
│       │   │               │   ├── AuthenticationUtil.java
│       │   │               │   └── AuthorizationUtil.java
│       │   │               │
│       │   │               ├── util/
│       │   │               │   ├── SeedUsers.java
│       │   │               │   ├── JsonUtil.java
│       │   │               │   ├── DateUtil.java
│       │   │               │   └── MoneyUtil.java
│       │   │               │
│       │   │               └── constant/
│       │   │                   ├── AccountType.java
│       │   │                   ├── TransactionType.java
│       │   │                   ├── TransactionStatus.java
│       │   │                   └── UserRole.java
│       │   │
│       │   ├── resources/
│       │   │   ├── application.properties
│       │   │   └── messages.properties
│       │   │
│       │   └── webapp/
│       │       │
│       │       ├── index.jsp
│       │       │
│       │       ├── WEB-INF/
│       │       │   ├── web.xml
│       │       │   └── views/
│       │       │       ├── home/
│       │       │       │   └── Home.jsp
│       │       │       │
│       │       │       ├── auth/
│       │       │       │   └── Login.jsp
│       │       │       │
│       │       │       ├── dashboard/
│       │       │       │   └── Dashboard.jsp
│       │       │       │
│       │       │       ├── account/
│       │       │       │   ├── Account.jsp
│       │       │       │   ├── AccountList.jsp
│       │       │       │   └── AccountDetails.jsp
│       │       │       │
│       │       │       ├── customer/
│       │       │       │   ├── CustomerList.jsp
│       │       │       │   └── CustomerDetails.jsp
│       │       │       │
│       │       │       └── transfer/
│       │       │           ├── Transfer.jsp
│       │       │           └── TransactionHistory.jsp
│       │       │
│       │       ├── css/
│       │       │   ├── common.css
│       │       │   ├── login.css
│       │       │   ├── dashboard.css
│       │       │   └── banking.css
│       │       │
│       │       ├── js/
│       │       │   ├── common.js
│       │       │   ├── dashboard.js
│       │       │   ├── account.js
│       │       │   └── transfer.js
│       │       │
│       │       └── images/
│       │
│       └── test/
│           └── java/
│               └── com/digistack/bank/
│                   ├── service/
│                   ├── dao/
│                   └── util/
│
