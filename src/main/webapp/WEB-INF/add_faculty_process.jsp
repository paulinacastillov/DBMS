<!-- //
//
// This file is the add_faculty_process.jsp
//
//
 -->



<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="jsp_azure_test.DataHandler"%>
<%@ page import="java.sql.SQLException"%>
<!DOCTYPE html>
<html>
<head>
    <title>Faculty Addition Result</title>
</head>
<body>
    <h2>Faculty Addition Result</h2>
    <%
        int fid = Integer.parseInt(request.getParameter("fid"));
        String fname = request.getParameter("fname");
        int deptid = Integer.parseInt(request.getParameter("deptid"));
        int excludeDeptFlag = Integer.parseInt(request.getParameter("excludeDeptFlag"));
        
        // Optional parameter for excluded department ID
        Integer excludeDeptId = null;
        if (excludeDeptFlag == 1 && request.getParameter("excludeDeptId") != null && !request.getParameter("excludeDeptId").isEmpty()) {
            excludeDeptId = Integer.parseInt(request.getParameter("excludeDeptId"));
        }

        DataHandler handler = null;

        try {
            // Instantiate DataHandler and call the insertFaculty method
            handler = new DataHandler();
            handler.insertFaculty(fid, fname, deptid, excludeDeptFlag == 1, excludeDeptId);
            out.println("<p>Faculty member added successfully with computed salary based on specified logic.</p>");

            // Display the added faculty member's details in a table format
    %>
            <table border="1">
                <tr>
                    <th>Faculty ID</th>
                    <th>Name</th>
                    <th>Department ID</th>
                    <th>Excluded Department Flag</th>
                    <th>Excluded Department ID</th>
                </tr>
                <tr>
                    <td><%= fid %></td>
                    <td><%= fname %></td>
                    <td><%= deptid %></td>
                    <td><%= excludeDeptFlag %></td>
                    <td><%= excludeDeptId != null ? excludeDeptId : "N/A" %></td>
                </tr>
            </table>
    <%
        } catch (SQLException e) {
            out.println("<p>Error adding faculty: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } catch (NumberFormatException e) {
            out.println("<p>Error: Invalid input. Please ensure all fields are correctly filled.</p>");
            e.printStackTrace();
        } finally {
            if (handler != null) {
                handler.close();  // Close without try-catch as no exception is thrown
            }
        }
    %>

    <!-- Buttons for navigation -->
    <p>
        <button onclick="window.location.href='add_faculty.jsp'">Add Another Faculty Member</button>
        <button onclick="window.location.href='get_all_faculty.jsp'">View All Faculty Members</button>
        <button onclick="window.location.href='goodbye.jsp'">Exit</button>
    </p>
</body>
</html>
