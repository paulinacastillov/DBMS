<!-- //
//
// This file is the get_all_faculty.jsp
//
//
 -->

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="jsp_azure_test.DataHandler" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Faculty Information</title>
</head>
<body>
    <h2>Faculty Information</h2>
    <table border="1">
        <tr>
            <th>Faculty ID</th>
            <th>Name</th>
            <th>Department ID</th>
            <th>Salary</th>
        </tr>
        <%
            DataHandler handler = null;
            ResultSet faculty = null;

            try {
                handler = new DataHandler();
                faculty = handler.displayAllFaculty();  // Get ResultSet from displayAllFaculty()

                // Loop through the ResultSet and display each faculty member in a table row
                while (faculty.next()) {
        %>
        <tr>
            <td><%= faculty.getInt("fid") %></td>
            <td><%= faculty.getString("fname") %></td>
            <td><%= faculty.getInt("deptid") %></td>
            <td><%= faculty.getFloat("salary") %></td>
        </tr>
        <% 
                }
            } catch (SQLException e) {
                out.println("<p>Error retrieving faculty information: " + e.getMessage() + "</p>");
                e.printStackTrace();
            } finally {
                if (faculty != null) {
                    try { faculty.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
                if (handler != null) {
                    handler.close();
                }
            }
        %>
    </table>

    <!-- Link to add a new faculty member or exit the application -->
    <p>
        <input type="button" value="Add Another Faculty Member" onclick="window.location.href='add_faculty.jsp'">
        <input type="button" value="Exit" onclick="window.location.href='goodbye.jsp'">
        
    </p></body>
</html>
