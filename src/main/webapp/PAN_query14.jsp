<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="jsp_azure_test.DataHandler, java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <title>Increase Salary for Employees</title>
    <link href="assets/css/style.css" rel="stylesheet"/>
</head>
<body>
    <h2>Increase Salary by 10% for Employees with Multiple Team Reports</h2>

    <%
        DataHandler handler = null;

        try {
            handler = new DataHandler();
            int rowsAffected = handler.increaseSalaryForMultipleTeams();

            if (rowsAffected > 0) {
                %>
                <p style="color: green;"><%= rowsAffected %> employee(s) had their salary increased by 10%.</p>
                <%
            } else {
                %>
                <p style="color: red;">No employees met the criteria for a salary increase.</p>
                <%
            }
        } catch (SQLException e) {
            %>
            <p style="color: red;">Error updating salaries: <%= e.getMessage() %></p>
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
    %>

    <p>
        <input type="button" value="Main Page" onclick="window.location.href='PAN_MainPage.jsp'">
    </p>
</body>
</html>
