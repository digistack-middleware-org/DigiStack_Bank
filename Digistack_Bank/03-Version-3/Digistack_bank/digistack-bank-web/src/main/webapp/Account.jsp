<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Account — DigiStack Bank</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --db-navy: #0b2545;
            --db-blue: #13315c;
            --db-gold: #c9a227;
            --db-bg: #f4f6f9;
        }
        body {
            background-color: var(--db-bg);
            font-family: 'Segoe UI', Arial, sans-serif;
        }
        .db-navbar {
            background: linear-gradient(90deg, var(--db-navy), var(--db-blue));
        }
        .db-navbar .navbar-brand {
            font-weight: 700;
            color: #fff !important;
        }
        .db-navbar .navbar-brand span {
            color: var(--db-gold);
        }
        .db-balance-card {
            border: none;
            border-radius: 16px;
            background: linear-gradient(135deg, var(--db-navy) 0%, var(--db-blue) 100%);
            color: #fff;
            box-shadow: 0 8px 28px rgba(0,0,0,0.15);
            opacity: 0;
            animation: fadeInUp 0.6s ease-out forwards;
        }
        .db-balance-amount {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--db-gold);
        }
        .db-form-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            opacity: 0;
            animation: fadeInUp 0.6s ease-out 0.15s forwards;
        }
        .btn-deposit {
            background-color: #1e7e34;
            border: none;
        }
        .btn-deposit:hover {
            background-color: #17652a;
        }
        .btn-withdraw {
            background-color: #a12a2a;
            border: none;
        }
        .btn-withdraw:hover {
            background-color: #841f1f;
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(16px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg db-navbar shadow-sm">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">DigiStack <span>Bank</span></a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm">Logout</a>
        </div>
    </nav>

    <main class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">

                <div class="card db-balance-card mb-4">
                    <div class="card-body text-center py-4">
                        <p class="mb-1 text-white-50 small">Current Balance</p>
                        <div class="db-balance-amount">
                            &#8377; ${balance}
                        </div>
                    </div>
                </div>

                <% if (request.getAttribute("resultMessage") != null) { %>
                    <div class="alert alert-info py-2 small">${resultMessage}</div>
                <% } %>

                <div class="card db-form-card p-4">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/account" method="post">
                            <div class="mb-3">
                                <label for="amount" class="form-label small text-muted">Amount</label>
                                <input type="number" step="0.01" min="0.01" class="form-control" id="amount" name="amount" required>
                            </div>
                            <div class="d-flex gap-2">
                                <button type="submit" name="action" value="deposit" class="btn btn-deposit text-white flex-fill">Deposit</button>
                                <button type="submit" name="action" value="withdraw" class="btn btn-withdraw text-white flex-fill">Withdraw</button>
                            </div>
                        </form>
                    </div>
                </div>

            </div>
        </div>
    </main>

</body>
</html>