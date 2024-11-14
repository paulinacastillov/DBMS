<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="jsp_azure_test.DataHandler, java.sql.SQLException, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Retrieve Volunteers Supporting Client</title>
    <link href="assets/css/style.css" rel="stylesheet"/>
</head>
<body>
    <h2>Retrieve Volunteers Supporting a Client</h2>
    
    <form action="" method="post">
        <label for="clientSSN">Client SSN:</label>
        <input type="text" id="clientSSN" name="clientSSN" required>
        <input type="submit" value="Get Volunteers">
    </form>

    <%
        if (request.getMethod().equalsIgnoreCase("post")) {
            String clientSSN = request.getParameter("clientSSN");
            DataHandler handler = null;

            try {
                handler = new DataHandler();
                List<String> volunteerNames = handler.getVolunteersSupportingClient(clientSSN);

                if (volunteerNames != null && !volunteerNames.isEmpty()) {
                    %>
                    <h3>Volunteers Supporting Client (SSN: <%= clientSSN %>)</h3>
                    <table border="1" cellpadding="8" cellspacing="0">
                        <tr><th>Volunteer Name</th></tr>
                        <%
                        for (String name : volunteerNames) {
                        %>
                        <tr>
                            <td><%= name %></td>
                        </tr>
                        <%
                        }
                        %>
                    </table>
                    <%
                } else {
                    %>
                    <p style="color: red;">No volunteers found for the specified client SSN.</p>
                    <%
                }
            } catch (SQLException e) {
                %>
                <p style="color: red;">Error retrieving volunteers: <%= e.getMessage() %></p>
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
