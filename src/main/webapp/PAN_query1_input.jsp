<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Team</title>
    <link href="assets/css/style.css" rel="stylesheet"/>
</head>
<body>
    <h2>Add New Team</h2>

    <form action="PAN_query1_process.jsp" method="post">
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

        <!-- Submit, Go Back, and Exit buttons -->
        <p>
            <input type="submit" value="Add Team">
        </p>
    </form>
</body>
</html>