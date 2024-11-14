

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="jsp_azure_test.DataHandler"%>
<%@ page import="java.sql.SQLException"%>
<!DOCTYPE html>
<html>
<head>
    <title>Team Addition Result</title>
    <link href="assets/css/style.css" rel="stylesheet"/>
</head>
<body>
    <h2>Team Addition Result</h2>
    <%
        String teamName = request.getParameter("teamName");
        String teamType = request.getParameter("teamType");
        String leaderSSN = request.getParameter("leaderSSN");

        DataHandler handler = null;

        try {
            // Instantiate Query1 and call the method to insert a team
            handler = new DataHandler();
            handler.insertTeam(teamName, teamType, leaderSSN);
            out.println("<p>Team added successfully to the database.</p>");

            // Display the added team's details in a table format
    %>
            <table border="1">
                <tr>
                    <th>Team Name</th>
                    <th>Team Type</th>
                </tr>
                <tr>
                    <td><%= teamName %></td>
                    <td><%= teamType %></td>
                </tr>
            </table>
    <%
        } catch (SQLException e) {
            out.println("<p>Error adding team: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } catch (Exception e) {
            out.println("<p>Error: Invalid input or unexpected error.</p>");
            e.printStackTrace();
        } finally {
            if (handler != null) {
                handler.close();  // Close connection without try-catch as no exception is thrown
            }
        }
    %>

    <!-- Buttons for navigation -->
    <p>
        <button onclick="window.location.href='PAN_query1_input.jsp'">Add Another Team</button>
        <button onclick="window.location.href='goodbye.jsp'">Exit</button>
    </p>
</body>
</html>