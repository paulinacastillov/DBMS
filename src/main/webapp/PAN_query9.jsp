<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="jsp_azure_test.DataHandler, java.sql.SQLException, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <title>Retrieve Employee Expenses</title>
    <link href="assets/css/style.css" rel="stylesheet"/>
</head>
<body>
    <h2>Retrieve Total Expenses by Employee</h2>
    
    <form action="" method="post">
        <label for="startDate">Start Date:</label>
        <input type="date" id="startDate" name="startDate" required>
        
        <label for="endDate">End Date:</label>
        <input type="date" id="endDate" name="endDate" required>
        
        <input type="submit" value="Get Expenses">
    </form>

    <%
        if (request.getMethod().equalsIgnoreCase("post")) {
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            DataHandler handler = null;

            try {
                handler = new DataHandler();
                Map<String, Double> employeeExpenses = handler.getTotalExpensesByEmployee(startDate, endDate);

                if (employeeExpenses != null && !employeeExpenses.isEmpty()) {
                    %>
                    <h3>Total Expenses by Employee (from <%= startDate %> to <%= endDate %>)</h3>
                    <table border="1" cellpadding="8" cellspacing="0">
                        <tr><th>Employee SSN</th><th>Total Expense</th></tr>
                        <%
                        for (Map.Entry<String, Double> entry : employeeExpenses.entrySet()) {
                            String ssn = entry.getKey();
                            Double totalExpense = entry.getValue();
                        %>
                        <tr>
                            <td><%= ssn %></td>
                            <td><%= String.format("%.2f", totalExpense) %></td>
                        </tr>
                        <%
                        }
                        %>
                    </table>
                    <%
                } else {
                    %>
                    <p style="color: red;">No expense data found for the specified period.</p>
                    <%
                }
            } catch (SQLException e) {
                %>
                <p style="color: red;">Error retrieving expense data: <%= e.getMessage() %></p>
                <%
                e.printStackTrace();
            } catch (Exception e) {
                %>
                <p style="color: red;">Unexpected error occurred.</p>
                <%
                e.printStackTrace();
            } finally {
                if (handler != null) {
                    handler.close();
                }
            }
        }
    %>
         <p>
           
            <input type="button" value="Main Page" onclick="window.location.href='PAN_MainPage.jsp'">
        </p>
</body>
</html>
