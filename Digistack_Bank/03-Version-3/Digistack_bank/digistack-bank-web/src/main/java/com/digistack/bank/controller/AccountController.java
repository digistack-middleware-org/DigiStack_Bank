package com.digistack.bank.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.digistack.bank.service.AccountService;

@WebServlet("/account")
public class AccountController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(AccountController.class.getName());

    private final AccountService accountService = new AccountService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        BigDecimal balance = accountService.getBalance(userId);

        request.setAttribute("balance", balance);
        request.getRequestDispatcher("/Account.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");
        String amountStr = request.getParameter("amount");

        String resultMessage;

        try {
            BigDecimal amount = new BigDecimal(amountStr);

            boolean success;
            if ("deposit".equals(action)) {
                success = accountService.deposit(userId, amount);
                resultMessage = success ? "Deposit successful." : "Deposit failed. Enter a valid positive amount.";
            } else if ("withdraw".equals(action)) {
                success = accountService.withdraw(userId, amount);
                resultMessage = success ? "Withdrawal successful." : "Withdrawal failed. Check your balance and amount.";
            } else {
                resultMessage = "Unknown action.";
            }

        } catch (NumberFormatException e) {
            logger.warning("AccountController: invalid amount entered: " + amountStr);
            resultMessage = "Invalid amount entered.";
        }

        BigDecimal balance = accountService.getBalance(userId);
        request.setAttribute("balance", balance);
        request.setAttribute("resultMessage", resultMessage);
        request.getRequestDispatcher("/Account.jsp").forward(request, response);
    }
}