<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DigiStack Bank — Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --db-navy:  #0b2545;
            --db-blue:  #13315c;
            --db-gold:  #c9a227;
            --db-bg:    #f4f6f9;
            --db-card:  #ffffff;
        }
        body {
            background-color: var(--db-bg);
            font-family: 'Segoe UI', Arial, sans-serif;
            min-height: 100vh;
        }

        /* ── Navbar ── */
        .db-navbar {
            background: linear-gradient(90deg, var(--db-navy), var(--db-blue));
            padding: 0.75rem 0;
        }
        .db-navbar .navbar-brand {
            font-weight: 700;
            font-size: 1.2rem;
            color: #fff !important;
            letter-spacing: 0.3px;
        }
        .db-navbar .navbar-brand span { color: var(--db-gold); }
        .db-navbar .nav-username {
            color: rgba(255,255,255,0.75);
            font-size: 0.85rem;
        }
        .db-navbar .btn-logout {
            color: rgba(255,255,255,0.75);
            border: 1px solid rgba(255,255,255,0.3);
            font-size: 0.8rem;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            transition: all 0.2s;
        }
        .db-navbar .btn-logout:hover {
            color: #fff;
            border-color: rgba(255,255,255,0.7);
            background: rgba(255,255,255,0.1);
        }

        /* ── Account Summary Card ── */
        .db-summary-card {
            background: linear-gradient(135deg, var(--db-navy) 0%, var(--db-blue) 100%);
            border-radius: 18px;
            color: #fff;
            padding: 1.75rem;
            box-shadow: 0 8px 32px rgba(11,37,69,0.18);
            opacity: 0;
            animation: fadeInUp 0.6s ease-out forwards;
        }
        .db-account-label {
            font-size: 0.78rem;
            color: rgba(255,255,255,0.55);
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }
        .db-account-number {
            font-size: 0.95rem;
            color: rgba(255,255,255,0.85);
            letter-spacing: 1px;
            font-family: 'Courier New', monospace;
        }
        .db-balance-amount {
            font-size: 2.4rem;
            font-weight: 700;
            color: var(--db-gold);
            letter-spacing: 0.5px;
            line-height: 1.1;
        }
        .db-show-balance-link {
            color: rgba(255,255,255,0.55);
            font-size: 0.8rem;
            text-decoration: none;
            border-bottom: 1px dashed rgba(255,255,255,0.3);
            transition: color 0.2s;
        }
        .db-show-balance-link:hover { color: rgba(255,255,255,0.9); }

        /* ── Quick Actions ── */
        .db-section-title {
            font-size: 0.9rem;
            font-weight: 600;
            color: #555;
            letter-spacing: 0.3px;
            margin-bottom: 0.75rem;
        }
        .db-action-tile {
            background: var(--db-card);
            border-radius: 14px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.07);
            padding: 1.25rem 0.75rem;
            text-align: center;
            text-decoration: none;
            color: var(--db-navy);
            display: block;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            opacity: 0;
            animation: fadeInUp 0.6s ease-out 0.1s forwards;
        }
        .db-action-tile:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.12);
            color: var(--db-navy);
        }
        .db-action-tile .tile-icon {
            font-size: 1.6rem;
            margin-bottom: 0.4rem;
            color: var(--db-gold);
        }
        .db-action-tile .tile-label {
            font-size: 0.78rem;
            font-weight: 600;
            color: #444;
        }

        /* ── Transactions ── */
        .db-txn-card {
            background: var(--db-card);
            border-radius: 14px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.07);
            opacity: 0;
            animation: fadeInUp 0.6s ease-out 0.2s forwards;
        }
        .db-txn-empty {
            color: #aaa;
            font-size: 0.85rem;
            padding: 1.5rem;
            text-align: center;
        }

        /* ── Status Strip ── */
        .db-status-strip {
            background: var(--db-card);
            border-radius: 14px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.07);
            padding: 0.75rem 1rem;
            font-size: 0.8rem;
            color: #777;
            opacity: 0;
            animation: fadeInUp 0.6s ease-out 0.3s forwards;
        }
        .db-online-dot {
            display: inline-block;
            width: 8px;
            height: 8px;
            background: #28a745;
            border-radius: 50%;
            margin-right: 5px;
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.4; }
        }

        /* ── Login State ── */
        .db-login-prompt {
            background: linear-gradient(135deg, var(--db-navy), var(--db-blue));
            border-radius: 18px;
            color: #fff;
            padding: 3rem 2rem;
            text-align: center;
            opacity: 0;
            animation: fadeInUp 0.6s ease-out forwards;
        }

        /* ── Animation ── */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(14px); }
            to   { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<!-- ═══════════════════════════════════════════
     NAVBAR
════════════════════════════════════════════ -->
<nav class="navbar db-navbar shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            DigiStack <span>Bank</span>
        </a>
        <% if (request.getAttribute("username") != null) { %>
            <div class="d-flex align-items-center gap-3">
                <span class="nav-username">
                    <i class="bi bi-person-circle me-1"></i>${username}
                </span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                    Logout
                </a>
            </div>
        <% } %>
    </div>
</nav>

<!-- ═══════════════════════════════════════════
     MAIN CONTENT
════════════════════════════════════════════ -->
<main class="container py-4" style="max-width: 540px;">

<% if (request.getAttribute("username") != null) { %>

    <!-- Account Summary Card -->
    <div class="db-summary-card mb-4">
        <div class="d-flex justify-content-between align-items-start mb-3">
            <div>
                <div class="db-account-label">Savings Account</div>
                <div class="db-account-number mt-1">${accountNumber}</div>
            </div>
            <span class="badge" style="background:rgba(201,162,39,0.2);color:var(--db-gold);font-size:0.7rem;padding:0.4rem 0.7rem;border-radius:20px;">
                Active
            </span>
        </div>

        <div class="mt-3 mb-1">
            <div class="db-account-label mb-1">Available Balance</div>
            <div class="db-balance-amount">
                &#8377;&nbsp;<span id="balanceValue"
                    data-real="${balance}"
                    data-hidden="true">&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;</span>
            </div>
        </div>
        <div class="mt-2">
            <a href="#" class="db-show-balance-link" id="balanceToggle"
               onclick="toggleBalance(event)">
                <i class="bi bi-eye" id="balanceIcon"></i>
                <span id="balanceToggleText">View balance</span>
            </a>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="mb-4">
        <div class="db-section-title">Quick Actions</div>
        <div class="row g-3">
            <div class="col-4">
                <a href="${pageContext.request.contextPath}/account?action=deposit"
                   class="db-action-tile">
                    <div class="tile-icon"><i class="bi bi-arrow-down-circle-fill"></i></div>
                    <div class="tile-label">Deposit</div>
                </a>
            </div>
            <div class="col-4">
                <a href="${pageContext.request.contextPath}/account?action=withdraw"
                   class="db-action-tile">
                    <div class="tile-icon"><i class="bi bi-arrow-up-circle-fill"></i></div>
                    <div class="tile-label">Withdraw</div>
                </a>
            </div>
            <div class="col-4">
                <a href="#" class="db-action-tile" style="opacity:0.45;pointer-events:none;animation-delay:0.15s;">
                    <div class="tile-icon"><i class="bi bi-arrow-left-right"></i></div>
                    <div class="tile-label">Transfer</div>
                </a>
            </div>
        </div>
    </div>

    <!-- Recent Transactions -->
    <div class="mb-4">
        <div class="db-section-title">Recent Transactions</div>
        <div class="db-txn-card">
            <div class="db-txn-empty">
                <i class="bi bi-clock-history d-block mb-2" style="font-size:1.5rem;"></i>
                Transaction history available in a future version.
            </div>
        </div>
    </div>

    <!-- System Status Strip -->
    <div class="db-status-strip">
        <span class="db-online-dot"></span>
        ${welcomeMessage} &nbsp;&mdash;&nbsp; Last login: ${lastLogin}
    </div>

<% } else { %>

    <!-- Not Logged In -->
    <div class="db-login-prompt">
        <h2 class="fw-bold mb-1">DigiStack <span style="color:var(--db-gold);">Bank</span></h2>
        <p class="mb-4" style="color:rgba(255,255,255,0.65);">
            Secure. Reliable. Enterprise-grade.
        </p>
        <a href="${pageContext.request.contextPath}/login"
           class="btn px-4 py-2 fw-semibold"
           style="background:var(--db-gold);color:var(--db-navy);border-radius:25px;">
            Sign In
        </a>
    </div>

<% } %>

</main>

<!-- ═══════════════════════════════════════════
     FOOTER
════════════════════════════════════════════ -->
<footer class="text-center py-4" style="font-size:0.75rem;color:#aaa;">
    &copy; DigiStack Bank &mdash; Training Environment
</footer>

<!-- Balance Toggle Script -->
<script>
function toggleBalance(e) {
    e.preventDefault();
    var span   = document.getElementById('balanceValue');
    var icon   = document.getElementById('balanceIcon');
    var text   = document.getElementById('balanceToggleText');
    var hidden = span.getAttribute('data-hidden') === 'true';

    if (hidden) {
        span.textContent = '\u20B9 ' + span.getAttribute('data-real');
        icon.className   = 'bi bi-eye-slash';
        text.textContent = 'Hide balance';
        span.setAttribute('data-hidden', 'false');
    } else {
        span.innerHTML   = '&bull;&bull;&bull;&bull;&bull;&bull;';
        icon.className   = 'bi bi-eye';
        text.textContent = 'View balance';
        span.setAttribute('data-hidden', 'true');
    }
}
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>