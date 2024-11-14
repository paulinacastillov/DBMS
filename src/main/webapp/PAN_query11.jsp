<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="jsp_azure_test.DataHandler, java.sql.SQLException, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Retrieve Teams Founded After Date</title>
    <link href="assets/css/style.css" rel="stylesheet"/>
</head>
<body>
    <h2>Retrieve Teams Founded After a Specific Date</h2>
    
    <form action="" method="post">
        <label for="foundationDate">Foundation Date:</label>
        <input type="date" id="foundationDate" name="foundationDate" required>
        <input type="submit" value="Get Teams">
    </form>

    <%
        if (request.getMethod().equalsIgnoreCase("post")) {
            String foundationDate = request.getParameter("foundationDate");
            DataHandler handler = null;

            try {
                handler = new DataHandler();
                List<String> teamNames = handler.getTeamsFoundedAfterDate(foundationDate);

                if (teamNames != null && !teamNames.isEmpty()) {
                    %>
                    <h3>Teams Founded After <%= foundationDate %></h3>
                    <table border="1" cellpadding="8" cellspacing="0">
                        <tr><th>Team Name</th></tr>
                        <%
                        for (String name : teamNames) {
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
                    <p style="color: red;">No teams found founded after the specified date.</p>
                    <%
                }
            } catch (SQLException e) {
                %>
                <p style="color: red;">Error retrieving teams: <%= e.getMessage() %></p>
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
