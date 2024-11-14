<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="jsp_azure_test.DataHandler"%>
<%@ page import="java.sql.SQLException"%>
<!DOCTYPE html>
<html>
<head>
    <title>Team Management</title>
    <link href="assets/css/style.css" rel="stylesheet"/>
    <script>
        function showPopup(message) {
            alert(message);
        }
    </script>
</head>
<body>
    <h2>Add New Team</h2>

    <form action="" method="post" onsubmit="return validateForm()">
        <table border="1" cellpadding="8" cellspacing="0">
            <tr>
                <th>Field</th>
                <th>Input</th>
            </tr>
            <tr>
                <td><label for="teamName">Team Name:</label></td>
                <td><input type="text" id="teamName" name="teamName" required></td>
            </tr>
            <tr>
                <td><label for="teamType">Team Type:</label></td>
                <td><input type="text" id="teamType" name="teamType" required></td>
            </tr>
            <tr>
                <td><label for="leaderSSN">Team Leader SSN:</label></td>
                <td><input type="text" id="leaderSSN" name="leaderSSN" required></td>
            </tr>
        </table>

        <p>
            <input type="submit" value="Add Team">
            <input type="button" value="Main Page" onclick="window.location.href='PAN_MainPage.jsp'">
        </p>

    </form>

    <script>
        function validateForm() {
            var teamName = document.getElementById("teamName").value;
            var teamType = document.getElementById("teamType").value;
            var leaderSSN = document.getElementById("leaderSSN").value;

            if (teamName === "" || teamType === "" || leaderSSN === "") {
                showPopup("All fields must be filled out before submitting.");
                return false;
            }
            return true;
        }
    </script>

    <%
        if (request.getMethod().equalsIgnoreCase("post")) {
            String teamName = request.getParameter("teamName");
            String teamType = request.getParameter("teamType");
            String leaderSSN = request.getParameter("leaderSSN");

            if (teamName != null && !teamName.isEmpty() && teamType != null && !teamType.isEmpty() && leaderSSN != null && !leaderSSN.isEmpty()) {
                DataHandler handler = null;

                try {
                    handler = new DataHandler();
                    handler.insertTeam(teamName, teamType, leaderSSN);
    %>
                    <script>
                        showPopup("Team added successfully to the database.");
                    </script>
                  
    <%
                } catch (SQLException e) {
    %>
                    <script>
                        showPopup("Error adding team: <%= e.getMessage() %>");
                    </script>
                    <p style="color: red;">Error adding team: <%= e.getMessage() %></p>
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
