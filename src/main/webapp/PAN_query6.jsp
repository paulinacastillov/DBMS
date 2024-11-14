<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="jsp_azure_test.DataHandler, java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <title>Enter Expense</title>
    <link href="assets/css/style.css" rel="stylesheet"/>
    <script>
        function showPopup(message) {
            alert(message);
        }

        function validateForm() {
            var requiredFields = ['ssn', 'expenseDate', 'amount', 'description'];
            for (var i = 0; i < requiredFields.length; i++) {
                var value = document.getElementById(requiredFields[i]).value;
                if (value === "") {
                    showPopup("All fields must be filled out before submitting.");
                    return false;
                }
            }
            return true;
        }
    </script>
</head>
<body>
    <h2>Enter Expense for Employee</h2>

    <form action="" method="post" onsubmit="return validateForm()">
        <table border="1" cellpadding="8" cellspacing="0">
            <tr>
                <th>Field</th>
                <th>Input</th>
            </tr>
            <tr>
                <td><label for="ssn">SSN:</label></td>
                <td><input type="text" id="ssn" name="ssn" required></td>
            </tr>
            <tr>
                <td><label for="expenseDate">Expense Date:</label></td>
                <td><input type="date" id="expenseDate" name="expenseDate" required></td>
            </tr>
            <tr>
                <td><label for="amount">Amount:</label></td>
                <td><input type="number" id="amount" name="amount" min="0" step="0.01" required></td>
            </tr>
            <tr>
                <td><label for="description">Description:</label></td>
                <td><input type="text" id="description" name="description" required></td>
            </tr>
        </table>

        <p>
            <input type="submit" value="Enter Expense">
            <input type="button" value="Main Page" onclick="window.location.href='PAN_MainPage.jsp'">
        </p>
    </form>

    <%
        if (request.getMethod().equalsIgnoreCase("post")) {
            String ssn = request.getParameter("ssn");
            String expenseDate = request.getParameter("expenseDate");
            String amountParam = request.getParameter("amount");
            String description = request.getParameter("description");
            double amount = 0.0;

            if (amountParam != null && !amountParam.isEmpty()) {
                try {
                    amount = Double.parseDouble(amountParam);
                } catch (NumberFormatException e) {
                    %>
                    <script>
                        showPopup("Error: Amount must be a valid number.");
                    </script>
                    <p style="color: red;">Error: Amount must be a valid number.</p>
                    <%
                    return;
                }
            } 

            if (ssn != null && !ssn.isEmpty() &&
                expenseDate != null && !expenseDate.isEmpty() &&
                amount > 0 &&
                description != null && !description.isEmpty()) {

                DataHandler handler = null;

                try {
                    handler = new DataHandler();
                    handler.insertExpense(ssn, expenseDate, amount, description);

                    %>
                    <script>
                        showPopup("Expense recorded successfully.");
                    </script>
                    <%
                } catch (SQLException e) {
                    %>
                    <script>
                        showPopup("Error recording expense: <%= e.getMessage() %>");
                    </script>
                    <p style="color: red;">Error recording expense: <%= e.getMessage() %></p>
                    <%
                    e.printStackTrace();
                } catch (Exception e) {
                    %>
                    <script>
                        showPopup("Error: Invalid input or unexpected error.");
                    </script>
                    <p style="color: red;">Error: Invalid input or unexpected error.</p>
                    <%
                    e.printStackTrace();
                } finally {
                    if (handler != null) {
                        handler.close();
                    }
                }
            }
        }
    %>
</body>
</html>
