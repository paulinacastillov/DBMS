<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="jsp_azure_test.DataHandler, java.sql.SQLException, java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Donor Totals</title>
    <link href="assets/css/style.css" rel="stylesheet"/>
</head>
<body>
    <h2>Names and Total Donations by Donors Who Are Also Employees</h2>

    <%
        DataHandler handler = null;

        try {
            handler = new DataHandler();
            List<Map<String, Object>> donorTotals = handler.getEmployeeDonorTotals();

            if (donorTotals != null && !donorTotals.isEmpty()) {
                %>
                <table border="1" cellpadding="8" cellspacing="0">
                    <tr>
                        <th>Name</th>
                        <th>Total Donated</th>
                    </tr>
                    <%
                    for (Map<String, Object> donor : donorTotals) {
                    %>
                    <tr>
                        <td><%= donor.get("Name") %></td>
                        <td><%= String.format("%.2f", donor.get("TotalDonated")) %></td>
                    </tr>
                    <%
                    }
                    %>
                </table>
                <%
            } else {
                %>
                <p style="color: red;">No donations found for employees who are also donors.</p>
                <%
            }
        } catch (SQLException e) {
            %>
            <p style="color: red;">Error retrieving data: <%= e.getMessage() %></p>
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
