<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="jsp_azure_test.DataHandler, java.sql.SQLException, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <title>Retrieve Doctor Information</title>
    <link href="assets/css/style.css" rel="stylesheet"/>
</head>
<body>
    <h2>Retrieve Doctor Information for a Client</h2>
    
    <form action="" method="post">
        <label for="clientSSN">Client SSN:</label>
        <input type="text" id="clientSSN" name="clientSSN" required>
        <input type="submit" value="Get Doctor Info">
    </form>

    <%
        if (request.getMethod().equalsIgnoreCase("post")) {
            String clientSSN = request.getParameter("clientSSN");
            DataHandler handler = null;

            try {
                handler = new DataHandler();
                Map<String, String> doctorInfo = handler.getDoctorInfo(clientSSN);

                if (doctorInfo != null && !doctorInfo.isEmpty()) {
                    String doctorName = doctorInfo.get("DoctorName");
                    String doctorPhoneNumber = doctorInfo.get("DoctorPhoneNumber");
                    %>
                    <h3>Doctor Information</h3>
                    <table border="1" cellpadding="8" cellspacing="0">
                        <tr><th>Doctor Name</th><td><%= doctorName %></td></tr>
                        <tr><th>Doctor Phone Number</th><td><%= doctorPhoneNumber %></td></tr>
                    </table>
                    <%
                } else {
                    %>
                    <p style="color: red;">No doctor information found for the specified client SSN.</p>
                    <%
                }
            } catch (SQLException e) {
               
            } catch (Exception e) {
                %>
                <p style="color: red;">Unexpected error occurred.</p>
                <%
                e.printStackTrace();
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
