<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="jsp_azure_test.DataHandler, java.io.IOException, java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <title>Import Teams from File</title>
    <link href="assets/css/style.css" rel="stylesheet"/>
</head>
<body>
    <h2>Import New Teams from File</h2>

    <form method="post">
        <label for="fileName">Enter the file name. Remember the format is txt:</label>
        <input type="text" id="fileName" name="fileName" required>
        <input type="submit" value="Import Teams" name="importButton">
    </form>

    <%
        // Check if the form has been submitted by the import button
        if (request.getParameter("importButton") != null) {
            String fileName = request.getParameter("fileName");
            DataHandler handler = null;
            int teamsAdded = 0;

            try {
                handler = new DataHandler();
                teamsAdded = handler.importTeamsFromFile(fileName);
                %>
                <p style="color: green;"><%= teamsAdded %> team(s) were successfully added.</p>
                <%
            } catch (IOException e) {
                %>
                <p style="color: red;">Error reading the file: <%= e.getMessage() %></p>
                <%
            } catch (SQLException e) {
                %>
                <p style="color: red;">Database error: <%= e.getMessage() %></p>
                <%
            } catch (Exception e) {
                %>
                <p style="color: red;">Unexpected error: <%= e.getMessage() %></p>
                <%
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
