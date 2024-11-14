<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="jsp_azure_test.DataHandler, java.sql.SQLException, java.util.ArrayList, java.util.HashMap, java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <title>Enter Donor and Donations</title>
    <link href="assets/css/style.css" rel="stylesheet"/>
    <script>
        function showPopup(message) {
            alert(message);
        }

        function addDonationRow() {
            const table = document.getElementById("donationsTable");
            const row = table.insertRow();
            row.innerHTML = `
                <td><input type="date" name="donationDate" required></td>
                <td><input type="number" name="donationAmount" min="0" step="0.01" required></td>
                <td><input type="text" name="donationType" required></td>
                <td><input type="checkbox" name="isAnonymous"></td>
                <td><input type="text" name="fundraisingCampaign"></td>
                <td><input type="text" name="checkNumber"></td>
                <td><input type="text" name="cardNumber"></td>
                <td><input type="text" name="cardType"></td>
                <td><input type="date" name="expirationDate"></td>
            `;
        }
    </script>
</head>
<body>
    <h2>Enter New Donor and Donations</h2>

    <form action="" method="post">
        <h3>Donor Information</h3>
        <table border="1" cellpadding="8" cellspacing="0">
            <tr><th>Field</th><th>Input</th></tr>
            <tr><td>SSN:</td><td><input type="text" name="ssn" required></td></tr>
            <tr><td>Name:</td><td><input type="text" name="name" required></td></tr>
            <tr><td>Gender:</td><td><input type="text" name="gender" required></td></tr>
            <tr><td>Profession:</td><td><input type="text" name="profession" required></td></tr>
            <tr><td>Address:</td><td><input type="text" name="address" required></td></tr>
            <tr><td>Email:</td><td><input type="email" name="email" required></td></tr>
            <tr><td>Phone Number:</td><td><input type="text" name="phoneNumber" required></td></tr>
            <tr>
                <td>Mailing List:</td>
                <td>
                    <select name="mailingList" required>
                        <option value="true">Yes</option>
                        <option value="false">No</option>
                    </select>
                </td>
            </tr>
        </table>

        <h3>Donations</h3>
        <table id="donationsTable" border="1" cellpadding="8" cellspacing="0">
            <tr>
                <th>Date</th><th>Amount</th><th>Type</th><th>Anonymous</th><th>Campaign</th><th>Check #</th><th>Card #</th><th>Card Type</th><th>Expiration Date</th>
            </tr>
        </table>
        <button type="button" onclick="addDonationRow()">Add Donation</button>

        <p><input type="submit" value="Add Donor and Donations"> <input type="button" value="Main Page" onclick="window.location.href='PAN_MainPage.jsp'"></p>
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

            List<Map<String, Object>> donations = new ArrayList<>();
            String[] donationDates = request.getParameterValues("donationDate");
            String[] donationAmounts = request.getParameterValues("donationAmount");
            String[] donationTypes = request.getParameterValues("donationType");
            String[] isAnonymousArray = request.getParameterValues("isAnonymous");
            String[] fundraisingCampaigns = request.getParameterValues("fundraisingCampaign");
            String[] checkNumbers = request.getParameterValues("checkNumber");
            String[] cardNumbers = request.getParameterValues("cardNumber");
            String[] cardTypes = request.getParameterValues("cardType");
            String[] expirationDates = request.getParameterValues("expirationDate");

            // Check if donationDates is not null before proceeding
            if (donationDates != null) {
                for (int i = 0; i < donationDates.length; i++) {
                    Map<String, Object> donation = new HashMap<>();
                    donation.put("date", donationDates[i]);
                    donation.put("amount", (donationAmounts != null && donationAmounts.length > i && donationAmounts[i] != null) ? Double.parseDouble(donationAmounts[i]) : 0.0);
                    donation.put("type", (donationTypes != null && donationTypes.length > i) ? donationTypes[i] : "");
                    donation.put("isAnonymous", (isAnonymousArray != null && isAnonymousArray.length > i && "on".equals(isAnonymousArray[i])));
                    donation.put("fundraisingCampaign", (fundraisingCampaigns != null && fundraisingCampaigns.length > i) ? fundraisingCampaigns[i] : null);
                    donation.put("checkNumber", (checkNumbers != null && checkNumbers.length > i) ? checkNumbers[i] : null);
                    donation.put("cardNumber", (cardNumbers != null && cardNumbers.length > i) ? cardNumbers[i] : null);
                    donation.put("cardType", (cardTypes != null && cardTypes.length > i) ? cardTypes[i] : null);
                    donation.put("expirationDate", (expirationDates != null && expirationDates.length > i && expirationDates[i] != null && !expirationDates[i].isEmpty()) ? expirationDates[i] : null);
                    donations.add(donation);
                }
            }

            DataHandler handler = null;
            try {
                handler = new DataHandler();
                handler.insertDonor(ssn, name, gender, profession, address, email, phoneNumber, mailingList, donations);
                %>
                <script>
                    showPopup("Donor and donations added successfully.");
                </script>
                <%
            } catch (SQLException e) {
                %>
                <script>
                    showPopup("Error adding donor: <%= e.getMessage() %>");
                </script>
                <p style="color: red;">Error adding donor: <%= e.getMessage() %></p>
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
    %>
</body>
</html>
