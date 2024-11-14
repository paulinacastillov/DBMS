<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="jsp_azure_test.DataHandler"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>


<!DOCTYPE html>
<html>
<head>
    <title>Client Management</title>
    <link href="assets/css/style.css" rel="stylesheet"/>
    <script>
        function showPopup(message) {
            alert(message);
        }

        function validateForm() {
            var ssn = document.getElementById("ssn").value;
            var name = document.getElementById("name").value;
            var gender = document.getElementById("gender").value;
            var profession = document.getElementById("profession").value;
            var address = document.getElementById("address").value;
            var email = document.getElementById("email").value;
            var phoneNumber = document.getElementById("phoneNumber").value;
            var doctorName = document.getElementById("doctorName").value;
            var doctorPhoneNumber = document.getElementById("doctorPhoneNumber").value;
            var enrolledDate = document.getElementById("enrolledDate").value;
            var teamName = document.getElementById("teamName").value;

            if (ssn === "" || name === "" || gender === "" || profession === "" || address === "" || email === "" || phoneNumber === "" || doctorName === "" || doctorPhoneNumber === "" || enrolledDate === "" || teamName === "") {
                showPopup("All fields must be filled out before submitting.");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <h2>Add New Client</h2>

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
                <td><label for="doctorName">Doctor Name:</label></td>
                <td><input type="text" id="doctorName" name="doctorName" required></td>
            </tr>
            <tr>
                <td><label for="doctorPhoneNumber">Doctor Phone Number:</label></td>
                <td><input type="text" id="doctorPhoneNumber" name="doctorPhoneNumber" required></td>
            </tr>
            <tr>
                <td><label for="enrolledDate">Enrolled Date:</label></td>
                <td><input type="date" id="enrolledDate" name="enrolledDate" required></td>
            </tr>
            <tr>
                <td><label for="teamName">Team Name:</label></td>
                <td><input type="text" id="teamName" name="teamName" required></td>
            </tr>
            <tr>
                <td><label for="teamName">Team Name 2:</label></td>
                <td><input type="text" id="teamName2" name="teamName2" ></td>
            </tr>
                        <tr>
                <td><label for="teamName">Team Name 3:</label></td>
                <td><input type="text" id="teamName2" name="teamName3" ></td>
            </tr>
        </table>

        <p>
            <input type="submit" value="Add Client" onclick="return validateForm()">
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
        String doctorName = request.getParameter("doctorName");
        String doctorPhoneNumber = request.getParameter("doctorPhoneNumber");
        String enrolledDate = request.getParameter("enrolledDate");

        // Crear la lista de equipos
        List<String> clientsTeams = new ArrayList<>();
        String teamName = request.getParameter("teamName");
        String teamName2 = request.getParameter("teamName2");
        String teamName3 = request.getParameter("teamName3");

        if (teamName != null && !teamName.isEmpty()) {
            clientsTeams.add(teamName);
        }
        if (teamName2 != null && !teamName2.isEmpty()) {
            clientsTeams.add(teamName2);
        }
        if (teamName3 != null && !teamName3.isEmpty()) {
            clientsTeams.add(teamName3);
        }

        if (ssn != null && !ssn.isEmpty() &&
            name != null && !name.isEmpty() &&
            gender != null && !gender.isEmpty() &&
            profession != null && !profession.isEmpty() &&
            address != null && !address.isEmpty() &&
            email != null && !email.isEmpty() &&
            phoneNumber != null && !phoneNumber.isEmpty() &&
            doctorName != null && !doctorName.isEmpty() &&
            doctorPhoneNumber != null && !doctorPhoneNumber.isEmpty() &&
            enrolledDate != null && !enrolledDate.isEmpty() &&
            !clientsTeams.isEmpty()) {

            DataHandler handler = null;

            try {
                handler = new DataHandler();
                handler.insertClient(ssn, name, gender, profession, address, email, phoneNumber, mailingList, doctorName, doctorPhoneNumber, enrolledDate, clientsTeams);

                %>
                <script>
                    showPopup("Client added successfully and associated with the selected teams.");
                </script>
                <%
            } catch (SQLException e) {
                %>
                <script>
                    showPopup("Error adding client: <%= e.getMessage() %>");
                </script>
                <p style="color: red;">Error adding client: <%= e.getMessage() %></p>
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