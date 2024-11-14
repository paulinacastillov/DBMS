<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="jsp_azure_test.DataHandler, java.io.IOException, java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <title>Export Mailing List to CSV</title>
    <link href="assets/css/style.css" rel="stylesheet"/>
</head>
<body>
    <h2>Export Mailing List to CSV</h2>

    <form method="post">
        <label for="fileName">Enter the output file name (without .csv):</label>
        <input type="text" id="fileName" name="fileName" required>
        <input type="submit" value="Export Mailing List" name="exportButton">
    </form>

    <%
        if (request.getParameter("exportButton") != null) {
            String fileName = request.getParameter("fileName");
            DataHandler handler = null;
            String filePath = null;

            try {
                handler = new DataHandler();
                filePath = handler.exportMailingListToCSV(fileName);
                %>
                <p style="color: green;">Mailing list exported successfully.</p>s
                <%
            } catch (IOException e) {
                %>
                <p style="color: red;">Error writing to the file: <%= e.getMessage() %></p>
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
