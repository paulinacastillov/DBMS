<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="jsp_azure_test.DataHandler, java.sql.SQLException, java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <title>Retrieve People with Emergency Contacts</title>
    <link href="assets/css/style.css" rel="stylesheet"/>
</head>
<body>
    <h2>People Information with Emergency Contacts</h2>

    <%
        DataHandler handler = null;

        try {
            handler = new DataHandler();
            List<Map<String, String>> peopleInfo = handler.getAllPeopleWithEmergencyContacts();

            if (peopleInfo != null && !peopleInfo.isEmpty()) {
                %>
                <table border="1" cellpadding="8" cellspacing="0">
                    <tr>
                        <th>Name</th>
                        <th>SSN</th>
                        <th>Email</th>
                        <th>Phone Number</th>
                        <th>Emergency Contact Name</th>
                        <th>Emergency Contact Phone</th>
                        <th>Relationship</th>
                    </tr>
                    <%
                    for (Map<String, String> person : peopleInfo) {
                    %>
                    <tr>
                        <td><%= person.get("Name") %></td>
                        <td><%= person.get("SSN") %></td>
                        <td><%= person.get("Email") %></td>
                        <td><%= person.get("PhoneNumber") %></td>
                        <td><%= person.get("EmergencyContactName") != null ? person.get("EmergencyContactName") : "N/A" %></td>
                        <td><%= person.get("EmergencyContactPhone") != null ? person.get("EmergencyContactPhone") : "N/A" %></td>
                        <td><%= person.get("Relationship") != null ? person.get("Relationship") : "N/A" %></td>
                    </tr>
                    <%
                    }
                    %>
                </table>
                <%
            } else {
                %>
                <p style="color: red;">No records found.</p>
                <%
            }
        } catch (SQLException e) {
            %>
            <p style="color: red;">Error retrieving data: <%= e.getMessage() %></p>
            <%
            e.printStackTrace();
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
    %>

    <p>
        <input type="button" value="Main Page" onclick="window.location.href='PAN_MainPage.jsp'">
    </p>
</body>
</html>
