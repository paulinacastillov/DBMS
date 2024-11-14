<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="jsp_azure_test.DataHandler, java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <title>Delete Clients Without Insurance and Low Transportation Necessity</title>
    <link href="assets/css/style.css" rel="stylesheet"/>
</head>
<body>
    <h2>Delete Clients Without Health Insurance and Low Transportation Necessity</h2>

    <%
        DataHandler handler = null;
        int rowsAffected = 0;
        boolean executed = false;

        try {
            handler = new DataHandler();
            rowsAffected = handler.deleteClientsWithoutInsuranceAndLowTransportNecessity();
            executed = true;
        } catch (SQLException e) {
            %>
            <p style="color: red;">Error deleting clients: <%= e.getMessage() %></p>
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

    <% if (executed) { %>
        <p style="color: green;"><%= rowsAffected %> client(s) were successfully deleted.</p>
    <% } %>

    <p>
        <input type="button" value="Main Page" onclick="window.location.href='PAN_MainPage.jsp'">
    </p>
</body>
</html>
