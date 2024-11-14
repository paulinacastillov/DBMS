<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="jsp_azure_test.DataHandler, java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <title>Enter Volunteer Hours</title>
    <link href="assets/css/style.css" rel="stylesheet"/>
    <script>
        function showPopup(message) {
            alert(message);
        }

        function validateForm() {
            var requiredFields = ['volunteerSSN', 'teamName', 'hoursWorked'];
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
    <h2>Enter the Number of Hours a Volunteer Worked</h2>

    <form action="" method="post">
        <table border="1" cellpadding="8" cellspacing="0">
            <tr>
                <th>Field</th>
                <th>Input</th>
            </tr>
            <tr>
                <td><label for="volunteerSSN">Volunteer SSN:</label></td>
                <td><input type="text" id="volunteerSSN" name="volunteerSSN" required></td>
            </tr>
            <tr>
                <td><label for="teamName">Team Name:</label></td>
                <td><input type="text" id="teamName" name="teamName" required></td>
            </tr>
            <tr>
                <td><label for="hoursWorked">Hours Worked:</label></td>
                <td><input type="number" id="hoursWorked" name="hoursWorked" min="0" required></td>
            </tr>
        </table>

        <p>
            <input type="submit" value="Submit Hours" onclick="return validateForm()">
            <input type="button" value="Main Page" onclick="window.location.href='PAN_MainPage.jsp'">
        </p>
    </form>

    <%
        if (request.getMethod().equalsIgnoreCase("post")) {
            String volunteerSSN = request.getParameter("volunteerSSN");
            String teamName = request.getParameter("teamName");
            String hoursWorkedParam = request.getParameter("hoursWorked");
            int hoursWorked = (hoursWorkedParam != null && !hoursWorkedParam.isEmpty()) ? Integer.parseInt(hoursWorkedParam) : 0;

            if (volunteerSSN != null && !volunteerSSN.isEmpty() &&
                teamName != null && !teamName.isEmpty() &&
                hoursWorked >= 0) {

                DataHandler handler = null;

                try {
                    handler = new DataHandler();
                    handler.enterHoursWorked(volunteerSSN, teamName, hoursWorked);
                    %>
                    <script>
                        showPopup("Hours successfully entered for volunteer.");
                    </script>
                    <%
                } catch (SQLException e) {
                    %>
                    <script>
                        showPopup("Error entering hours: <%= e.getMessage() %>");
                    </script>
                    <p style="color: red;">Error entering hours: <%= e.getMessage() %></p>
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
