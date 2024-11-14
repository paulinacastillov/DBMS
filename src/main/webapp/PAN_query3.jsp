<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="jsp_azure_test.DataHandler"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>


<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="jsp_azure_test.DataHandler, java.sql.SQLException, java.util.ArrayList, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Enter New Volunteer</title>
    <link href="assets/css/style.css" rel="stylesheet"/>
    <script>
        function showPopup(message) {
            alert(message);
        }

        function validateForm() {
            var requiredFields = ['ssn', 'name', 'gender', 'profession', 'address', 'email', 'phoneNumber', 'dateJoined'];
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
    <h2>Add New Volunteer</h2>

    <form action="" method="post">
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
                <td><label for="name">Name:</label></td>
                <td><input type="text" id="name" name="name" required></td>
            </tr>
            <tr>
                <td><label for="gender">Gender:</label></td>
                <td><input type="text" id="gender" name="gender" required></td>
            </tr>
            <tr>
                <td><label for="profession">Profession:</label></td>
                <td><input type="text" id="profession" name="profession" required></td>
            </tr>
            <tr>
                <td><label for="address">Address:</label></td>
                <td><input type="text" id="address" name="address" required></td>
            </tr>
            <tr>
                <td><label for="email">Email:</label></td>
                <td><input type="email" id="email" name="email" required></td>
            </tr>
            <tr>
                <td><label for="phoneNumber">Phone Number:</label></td>
                <td><input type="text" id="phoneNumber" name="phoneNumber" required></td>
            </tr>
            <tr>
                <td><label for="mailingList">Mailing List:</label></td>
                <td>
                    <select id="mailingList" name="mailingList" required>
                        <option value="true">Yes</option>
                        <option value="false">No</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td><label for="dateJoined">Date Joined:</label></td>
                <td><input type="date" id="dateJoined" name="dateJoined" required></td>
            </tr>
            <tr>
                <td><label for="mostRecentTrainingDate">Most Recent Training Date:</label></td>
                <td><input type="date" id="mostRecentTrainingDate" name="mostRecentTrainingDate"></td>
            </tr>
            <tr>
                <td><label for="mostRecentTrainingLocation">Most Recent Training Location:</label></td>
                <td><input type="text" id="mostRecentTrainingLocation" name="mostRecentTrainingLocation"></td>
            </tr>
            <tr>
                <td><label for="teamName">Team Name:</label></td>
                <td><input type="text" id="teamName" name="teamName" required></td>
            </tr>
            <tr>
                <td><label for="teamName2">Team Name 2:</label></td>
                <td><input type="text" id="teamName2" name="teamName2"></td>
            </tr>
            <tr>
                <td><label for="teamName3">Team Name 3:</label></td>
                <td><input type="text" id="teamName3" name="teamName3"></td>
            </tr>
        </table>

        <p>
            <input type="submit" value="Add Volunteer" onclick="return validateForm()">
            <input type="button" value="Main Page" onclick="window.location.href='PAN_MainPage.jsp'">
        </p>
    </form>

    <%
        if (request.getMethod().equalsIgnoreCase("post")) {
            String ssn = request.getParameter("ssn");
            String name = request.getParameter("name");
            String gender = request.getParameter("gender");
            String profession = request.getParameter("profession");
            String address = request.getParameter("address");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");
            boolean mailingList = Boolean.parseBoolean(request.getParameter("mailingList"));
            String dateJoined = request.getParameter("dateJoined");
            String mostRecentTrainingDate = request.getParameter("mostRecentTrainingDate");
            String mostRecentTrainingLocation = request.getParameter("mostRecentTrainingLocation");

            // Obtener los nombres de los equipos y almacenarlos en una lista
            List<String> volunteerTeams = new ArrayList<>();
            String teamName = request.getParameter("teamName");
            String teamName2 = request.getParameter("teamName2");
            String teamName3 = request.getParameter("teamName3");

            if (teamName != null && !teamName.isEmpty()) {
                volunteerTeams.add(teamName);
            }
            if (teamName2 != null && !teamName2.isEmpty()) {
                volunteerTeams.add(teamName2);
            }
            if (teamName3 != null && !teamName3.isEmpty()) {
                volunteerTeams.add(teamName3);
            }

            if (ssn != null && !ssn.isEmpty() &&
                name != null && !name.isEmpty() &&
                gender != null && !gender.isEmpty() &&
                profession != null && !profession.isEmpty() &&
                address != null && !address.isEmpty() &&
                email != null && !email.isEmpty() &&
                phoneNumber != null && !phoneNumber.isEmpty() &&
                dateJoined != null && !dateJoined.isEmpty()) {

                DataHandler handler = null;

                try {
                    handler = new DataHandler();
                    handler.insertVolunteer(ssn, name, gender, profession, address, email, phoneNumber, mailingList, dateJoined, mostRecentTrainingDate, mostRecentTrainingLocation, volunteerTeams);

                    %>
                    <script>
                        showPopup("Volunteer added successfully and associated with the selected teams.");
                    </script>
                    <%
                } catch (SQLException e) {
                    %>
                    <script>
                        showPopup("Error adding volunteer: <%= e.getMessage() %>");
                    </script>
                    <p style="color: red;">Error adding volunteer: <%= e.getMessage() %></p>
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
