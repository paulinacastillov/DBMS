//
//
//  This is the file DataHandler.java
//
//


package jsp_azure_test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.CallableStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.time.LocalDate;
import java.sql.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.io.IOException;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.FileWriter;
import java.io.PrintWriter;


public class DataHandler {

    private Connection conn;

    // Azure SQL connection credentials
    private String server = "cast0333-sql-server.database.windows.net";
    private String database = "cs-dsa-4513-sql-db";
    private String username = "cast0333";
    private String password = "Pao3032001*";
    private static final String BASE_DIRECTORY = "C:\\Users\\anapa\\Documents\\OU\\Clases\\Data Base Managment System\\Final project\\TeamFiles\\";
    private static final String EXPORT_DIRECTORY = "C:\\Users\\anapa\\Documents\\OU\\Clases\\Data Base Managment System\\Final project\\PeopleMailList\\";


    // Resulting connection string
    final private String url =
            String.format("jdbc:sqlserver://%s:1433;database=%s;user=%s;password=%s;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;",
                    server, database, username, password);

    // Initialize and save the database connection
    public DataHandler() throws SQLException {
        getDBConnection();
    }

    private void getDBConnection() throws SQLException {
        if (conn == null) {
            this.conn = DriverManager.getConnection(url);
        }
    }

    // Method to insert a faculty member with optional exclusion of department average
    public void insertFaculty(int fid, String fname, int deptid, boolean excludeDeptFlag, Integer excludeDeptId) throws SQLException {
        String sql = "{CALL InsertFaculty(?, ?, ?, ?, ?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, fid);
            stmt.setString(2, fname);
            stmt.setInt(3, deptid);
            stmt.setInt(4, excludeDeptFlag ? 1 : 0);  // Set 1 if excluding a department, 0 otherwise
            if (excludeDeptFlag && excludeDeptId != null) {
                stmt.setInt(5, excludeDeptId);
            } else {
                stmt.setNull(5, java.sql.Types.INTEGER);  // Null if not excluding
            }

            // Execute the stored procedure
            stmt.execute();
            System.out.println("Faculty member inserted with computed salary based on specified logic.");
        }
    }

 // Updated displayAllFaculty to return a ResultSet
    public ResultSet displayAllFaculty() throws SQLException {
        getDBConnection();
        String query = "SELECT fid, fname, deptid, salary FROM Faculty";
        Statement stmt = conn.createStatement();
        return stmt.executeQuery(query);  // Return ResultSet instead of void
    }

    // Close the connection when done
    public void close() {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException e) {
            System.err.println("SQL error during connection close: " + e.getMessage());
        }
    }
    
    
    //-----------------------------------------------------------------------------------------------------------
    
    
    // Query1 
 // Method to insert a new team into the Team table
    public void insertTeam(String teamName, String teamType, String leaderSSN) throws SQLException {
        // SQL insert statement with placeholders for team data
        String sql = "INSERT INTO Team (Name, Type, CreationDate, TeamLeaderSSN) VALUES (?, ?, ?, ?)";
        
        // Try-with-resources to auto-close the PreparedStatement
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // Set the team name parameter in the SQL statement
            stmt.setString(1, teamName);
            
            // Set the team type parameter in the SQL statement
            stmt.setString(2, teamType);
            
            // Get the current date and set it as the creation date for the team
            Date creationDate = Date.valueOf(LocalDate.now());
            stmt.setDate(3, creationDate); // Set the date as a DATE type
            
            // Set the SSN of the team leader
            stmt.setString(4, leaderSSN);

            // Execute the SQL update to insert the new team into the database
            stmt.executeUpdate();
            
            // Print a confirmation message if the team is successfully inserted
            System.out.println("Team successfully inserted into the database with creation date and leader SSN.");
        }
    }

    
    
    //-----------------------------------------------------------------------------------------------------------
    
    // Query 2 
    
 // Method to insert a new client into the Client and People tables and associate them with multiple teams
    public void insertClient(String ssn, String name, String gender, String profession, String address, String email, 
                             String phoneNumber, boolean mailingList, String doctorName, String doctorPhoneNumber, 
                             String enrolledDate, List<String> clientsTeams) throws SQLException {

        // SQL insert statement for Client and People tables
        String insertClientSql = "INSERT INTO Client (SSN, DoctorName, DoctorPhoneNumber, EnrolledDate) VALUES (?, ?, ?, ?)";
        String insertPersonSql = "INSERT INTO People (SSN, Name, Gender, Profession, Address, Email, PhoneNumber, MailingList) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        // Validate input fields to ensure all required information is provided
        if (ssn == null || ssn.isEmpty() || name == null || name.isEmpty() || gender == null || gender.isEmpty() ||
            profession == null || profession.isEmpty() || address == null || address.isEmpty() ||
            email == null || email.isEmpty() || phoneNumber == null || phoneNumber.isEmpty() ||
            doctorName == null || doctorName.isEmpty() || doctorPhoneNumber == null || doctorPhoneNumber.isEmpty() ||
            enrolledDate == null || enrolledDate.isEmpty() || clientsTeams == null || clientsTeams.isEmpty()) {
            throw new IllegalArgumentException("All fields must be filled before submitting.");
        }

        // Use try-with-resources to auto-close PreparedStatement objects
        try (PreparedStatement personStmt = conn.prepareStatement(insertPersonSql);
             PreparedStatement clientStmt = conn.prepareStatement(insertClientSql)) {
            
            // Insert data into the People table
            personStmt.setString(1, ssn);
            personStmt.setString(2, name);
            personStmt.setString(3, gender);
            personStmt.setString(4, profession);
            personStmt.setString(5, address);
            personStmt.setString(6, email);
            personStmt.setString(7, phoneNumber);
            personStmt.setBoolean(8, mailingList);
            personStmt.executeUpdate();

            // Insert data into the Client table
            clientStmt.setString(1, ssn);
            clientStmt.setString(2, doctorName);
            clientStmt.setString(3, doctorPhoneNumber);
            clientStmt.setDate(4, Date.valueOf(enrolledDate)); // Convert enrolled date to java.sql.Date
            clientStmt.executeUpdate();

            // Associate the client with each specified team
            for (String teamName : clientsTeams) {
                associateClientWithTeam(ssn, teamName);
            }

            System.out.println("Client successfully inserted and associated with teams.");
        }
    }

    // Helper method to associate a client with a specific team
    public void associateClientWithTeam(String clientSSN, String teamName) throws SQLException {
        String associateTeamSql = "INSERT INTO TakeCareOf (TeamName, ClientSSN) VALUES (?, ?)";

        // Use try-with-resources to auto-close PreparedStatement
        try (PreparedStatement teamStmt = conn.prepareStatement(associateTeamSql)) {
            teamStmt.setString(1, teamName);
            teamStmt.setString(2, clientSSN);
            teamStmt.executeUpdate();
            System.out.println("Client successfully associated with team: " + teamName);
        }
    }


    
  
 
 
//-----------------------------------------------------------------------------------------------------------

//Query 3

 // Method to insert a new volunteer into the Volunteer and People tables and associate them with multiple teams
    public void insertVolunteer(String ssn, String name, String gender, String profession, String address, String email, 
                                String phoneNumber, boolean mailingList, String dateJoined, String mostRecentTrainingDate, 
                                String mostRecentTrainingLocation, List<String> volunteerTeams) throws SQLException {
        // SQL insert statement for Volunteer and People tables
        String insertVolunteerSql = "INSERT INTO Volunteer (SSN, DateJoined, MostRecentTrainingDate, MostRecentTrainingLocation) VALUES (?, ?, ?, ?)";
        String insertPersonSql = "INSERT INTO People (SSN, Name, Gender, Profession, Address, Email, PhoneNumber, MailingList) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        // Validate input fields to ensure all required information is provided
        if (ssn == null || ssn.isEmpty() || name == null || name.isEmpty() || gender == null || gender.isEmpty() ||
            profession == null || profession.isEmpty() || address == null || address.isEmpty() ||
            email == null || email.isEmpty() || phoneNumber == null || phoneNumber.isEmpty() ||
            dateJoined == null || dateJoined.isEmpty() || volunteerTeams == null || volunteerTeams.isEmpty()) {
            throw new IllegalArgumentException("All fields must be filled before submitting.");
        }

        // Use try-with-resources to auto-close PreparedStatement objects
        try (PreparedStatement personStmt = conn.prepareStatement(insertPersonSql);
             PreparedStatement volunteerStmt = conn.prepareStatement(insertVolunteerSql)) {
            
            // Insert data into the People table
            personStmt.setString(1, ssn);
            personStmt.setString(2, name);
            personStmt.setString(3, gender);
            personStmt.setString(4, profession);
            personStmt.setString(5, address);
            personStmt.setString(6, email);
            personStmt.setString(7, phoneNumber);
            personStmt.setBoolean(8, mailingList);
            personStmt.executeUpdate();

            // Insert data into the Volunteer table
            volunteerStmt.setString(1, ssn);
            volunteerStmt.setDate(2, Date.valueOf(dateJoined));
            // Check if mostRecentTrainingDate is not null and non-empty before converting to Date
            volunteerStmt.setDate(3, mostRecentTrainingDate != null && !mostRecentTrainingDate.isEmpty() ? Date.valueOf(mostRecentTrainingDate) : null);
            volunteerStmt.setString(4, mostRecentTrainingLocation);
            volunteerStmt.executeUpdate();

            // Associate the volunteer with each specified team
            for (String teamName : volunteerTeams) {
                associateVolunteerWithTeam(ssn, teamName);
            }

            System.out.println("Volunteer successfully inserted and associated with teams.");
        }
    }

    // Helper method to associate a volunteer with a specific team
    public void associateVolunteerWithTeam(String volunteerSSN, String teamName) throws SQLException {
        String associateTeamSql = "INSERT INTO BelongsTo (VolunteerSSN, TeamName, HoursWorked) VALUES (?, ?, 0)";

        // Use try-with-resources to auto-close PreparedStatement
        try (PreparedStatement teamStmt = conn.prepareStatement(associateTeamSql)) {
            teamStmt.setString(1, volunteerSSN);
            teamStmt.setString(2, teamName);
            teamStmt.executeUpdate();
            System.out.println("Volunteer successfully associated with team: " + teamName);
        }
    }


//-----------------------------------------------------------------------------------------------------------

//Query 4

 // Method to enter hours worked by a volunteer for a specific team
    public void enterHoursWorked(String volunteerSSN, String teamName, int hoursWorked) throws SQLException {
        String updateHoursSql = "UPDATE BelongsTo SET HoursWorked = HoursWorked + ? WHERE VolunteerSSN = ? AND TeamName = ?";

        // Validate input fields to ensure all required information is provided and hours are positive
        if (volunteerSSN == null || volunteerSSN.isEmpty() || teamName == null || teamName.isEmpty() || hoursWorked < 0) {
            throw new IllegalArgumentException("All fields must be filled and hours must be a positive value.");
        }

        try (PreparedStatement updateHoursStmt = conn.prepareStatement(updateHoursSql)) {
            updateHoursStmt.setInt(1, hoursWorked);
            updateHoursStmt.setString(2, volunteerSSN);
            updateHoursStmt.setString(3, teamName);
            int rowsAffected = updateHoursStmt.executeUpdate();

            if (rowsAffected > 0) {
                System.out.println("Hours successfully entered for volunteer: " + volunteerSSN + " in team: " + teamName);
            } else {
                throw new SQLException("No record found to update hours for the given volunteer and team.");
            }
        }
    }


//-----------------------------------------------------------------------------------------------------------

//Query 5

 // Method to insert a new employee into the Employee and People tables and associate them with multiple teams
    public void insertEmployee(String ssn, String name, String gender, String profession, String address, String email, 
                               String phoneNumber, boolean mailingList, String hireDate, double salary, 
                               String maritalStatus, List<String> employeeTeams) throws SQLException {
        // SQL insert statement for Employee and People tables
        String insertEmployeeSql = "INSERT INTO Employee (SSN, Salary, MaritalStatus, HireDate) VALUES (?, ?, ?, ?)";
        String insertPersonSql = "INSERT INTO People (SSN, Name, Gender, Profession, Address, Email, PhoneNumber, MailingList) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        // Validate input fields to ensure all required information is provided
        if (ssn == null || ssn.isEmpty() || name == null || name.isEmpty() || gender == null || gender.isEmpty() ||
            profession == null || profession.isEmpty() || address == null || address.isEmpty() ||
            email == null || email.isEmpty() || phoneNumber == null || phoneNumber.isEmpty() ||
            hireDate == null || hireDate.isEmpty() || salary < 0 || employeeTeams == null || employeeTeams.isEmpty()) {
            throw new IllegalArgumentException("All fields must be filled before submitting.");
        }

        try (PreparedStatement personStmt = conn.prepareStatement(insertPersonSql);
             PreparedStatement employeeStmt = conn.prepareStatement(insertEmployeeSql)) {
            
            // Insert data into the People table
            personStmt.setString(1, ssn);
            personStmt.setString(2, name);
            personStmt.setString(3, gender);
            personStmt.setString(4, profession);
            personStmt.setString(5, address);
            personStmt.setString(6, email);
            personStmt.setString(7, phoneNumber);
            personStmt.setBoolean(8, mailingList);
            personStmt.executeUpdate();

            // Insert data into the Employee table
            employeeStmt.setString(1, ssn);
            employeeStmt.setDouble(2, salary);
            employeeStmt.setString(3, maritalStatus);
            employeeStmt.setDate(4, Date.valueOf(hireDate));
            employeeStmt.executeUpdate();

            // Associate the employee with each specified team
            for (String teamName : employeeTeams) {
                associateEmployeeWithTeam(ssn, teamName);
            }

            System.out.println("Employee successfully inserted and associated with teams.");
        }
    }

    // Helper method to associate an employee with a specific team
    public void associateEmployeeWithTeam(String employeeSSN, String teamName) throws SQLException {
        String associateTeamSql = "INSERT INTO TeamReportsToEmployee (TeamName, ReportDate, ReportDescription, EmployeeSSN) VALUES (?, CURRENT_DATE, 'Auto-generated report', ?)";

        try (PreparedStatement teamStmt = conn.prepareStatement(associateTeamSql)) {
            teamStmt.setString(1, teamName);
            teamStmt.setString(2, employeeSSN);
            teamStmt.executeUpdate();
            System.out.println("Employee successfully associated with team: " + teamName);
        }
    }
//-----------------------------------------------------------------------------------------------------------


//Query 6

 // Method to insert an expense record for an employee
    public void insertExpense(String ssn, String expenseDate, double amount, String description) throws SQLException {
        String insertExpenseSql = "INSERT INTO Expenses (SSN, ExpenseDate, Amount, Description) VALUES (?, ?, ?, ?)";

        // Validate input fields to ensure all required information is provided and amount is positive
        if (ssn == null || ssn.isEmpty() || expenseDate == null || expenseDate.isEmpty() || amount <= 0 || description == null || description.isEmpty()) {
            throw new IllegalArgumentException("All fields must be filled before submitting.");
        }

        try (PreparedStatement expenseStmt = conn.prepareStatement(insertExpenseSql)) {
            expenseStmt.setString(1, ssn);
            expenseStmt.setDate(2, Date.valueOf(expenseDate));
            expenseStmt.setDouble(3, amount);
            expenseStmt.setString(4, description);
            expenseStmt.executeUpdate();

            System.out.println("Expense successfully recorded for employee with SSN: " + ssn);
        }
    }
    
//-----------------------------------------------------------------------------------------------------------



//Query 7: Insert a new donor and associate them with multiple donations

public void insertDonor(String ssn, String name, String gender, String profession, String address, String email, String phoneNumber, boolean mailingList, List<Map<String, Object>> donations) throws SQLException {
    String insertPersonSql = "INSERT INTO People (SSN, Name, Gender, Profession, Address, Email, PhoneNumber, MailingList) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    String insertDonorSql = "INSERT INTO Donor (SSN) VALUES (?)";
    String insertDonationSql = "INSERT INTO Donation (SSN, Date, Amount, Type, IsAnonymous, FundraisingCampaign, CheckNumber, CardNumber, CardType, ExpirationDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    // Validate input fields
    if (ssn == null || ssn.isEmpty() || name == null || name.isEmpty() || gender == null || gender.isEmpty() ||
        profession == null || profession.isEmpty() || address == null || address.isEmpty() ||
        email == null || email.isEmpty() || phoneNumber == null || phoneNumber.isEmpty() ||
        donations == null || donations.isEmpty()) {
        throw new IllegalArgumentException("All fields must be filled before submitting.");
    }

    try (PreparedStatement personStmt = conn.prepareStatement(insertPersonSql);
         PreparedStatement donorStmt = conn.prepareStatement(insertDonorSql);
         PreparedStatement donationStmt = conn.prepareStatement(insertDonationSql)) {

        // Insert into People table
        personStmt.setString(1, ssn);
        personStmt.setString(2, name);
        personStmt.setString(3, gender);
        personStmt.setString(4, profession);
        personStmt.setString(5, address);
        personStmt.setString(6, email);
        personStmt.setString(7, phoneNumber);
        personStmt.setBoolean(8, mailingList);
        personStmt.executeUpdate();

        // Insert into Donor table
        donorStmt.setString(1, ssn);
        donorStmt.executeUpdate();

        // Insert each donation
        for (Map<String, Object> donation : donations) {
            donationStmt.setString(1, ssn);
            donationStmt.setDate(2, Date.valueOf((String) donation.get("date")));
            donationStmt.setDouble(3, (Double) donation.get("amount"));
            donationStmt.setString(4, (String) donation.get("type"));
            donationStmt.setBoolean(5, (Boolean) donation.get("isAnonymous"));
            donationStmt.setString(6, (String) donation.get("fundraisingCampaign"));
            donationStmt.setString(7, (String) donation.get("checkNumber"));
            donationStmt.setString(8, (String) donation.get("cardNumber"));
            donationStmt.setString(9, (String) donation.get("cardType"));
            donationStmt.setDate(10, donation.get("expirationDate") != null ? Date.valueOf((String) donation.get("expirationDate")) : null);
            donationStmt.executeUpdate();
        }

        System.out.println("Donor and associated donations successfully inserted.");
    }
}

//----------------------------------------------------------------------------------------

//Query 8: Method to retrieve the doctor's name and phone number for a specific client
public Map<String, String> getDoctorInfo(String clientSSN) throws SQLException {
 // SQL query to select the doctor's name and phone number based on the client's SSN
 String query = "SELECT DoctorName, DoctorPhoneNumber FROM Client WHERE SSN = ?";
 Map<String, String> doctorInfo = new HashMap<>();

 // Use try-with-resources to auto-close PreparedStatement
 try (PreparedStatement stmt = conn.prepareStatement(query)) {
     // Set the client's SSN as a parameter for the query
     stmt.setString(1, clientSSN);
     
     // Execute the query and process the result
     try (ResultSet rs = stmt.executeQuery()) {
         // If a result is found, retrieve the doctor's information
         if (rs.next()) {
             doctorInfo.put("DoctorName", rs.getString("DoctorName"));
             doctorInfo.put("DoctorPhoneNumber", rs.getString("DoctorPhoneNumber"));
         } else {
             // If no record is found, throw an exception with a message
             throw new SQLException("No doctor information found for the specified client SSN.");
         }
     }
 }
 // Return the map containing the doctor's name and phone number
 return doctorInfo;
}


//------------------------------------------------------------------------

/// Query 9: Retrieve the total amount of expenses charged by each employee within a specified period
public Map<String, Double> getTotalExpensesByEmployee(String startDate, String endDate) throws SQLException {
  // SQL query to calculate the total expense amount for each employee within the specified date range
  String query = "SELECT SSN, SUM(Amount) AS TotalExpense " +
                 "FROM Expenses " +
                 "WHERE ExpenseDate BETWEEN ? AND ? " +
                 "GROUP BY SSN";
  Map<String, Double> employeeExpenses = new HashMap<>();

  // Use try-with-resources to automatically close the PreparedStatement
  try (PreparedStatement stmt = conn.prepareStatement(query)) {
      // Set the date parameters for the query
      stmt.setString(1, startDate);
      stmt.setString(2, endDate);
      
      // Execute the query and process the results
      try (ResultSet rs = stmt.executeQuery()) {
          // Loop through each result row
          while (rs.next()) {
              String ssn = rs.getString("SSN");           // Retrieve the employee's SSN
              double totalExpense = rs.getDouble("TotalExpense"); // Retrieve the calculated total expense
              employeeExpenses.put(ssn, totalExpense);    // Store the result in the map
          }
      }
  }
  // Return the map containing each employee's SSN and their corresponding total expense
  return employeeExpenses;
}


//----------------------------------------------------------------------------------

//Query 10: Retrieve the list of volunteers that are members of teams supporting a specific client
public List<String> getVolunteersSupportingClient(String clientSSN) throws SQLException {
 // SQL query to find volunteer names in teams that support a specific client, identified by their SSN
 String query = "SELECT p.Name " +
                "FROM Volunteer v " +
                "JOIN BelongsTo b ON v.SSN = b.VolunteerSSN " +         // Join Volunteer and BelongsTo tables
                "JOIN TakeCareOf t ON b.TeamName = t.TeamName " +       // Join BelongsTo and TakeCareOf tables
                "JOIN People p ON v.SSN = p.SSN " +                    // Join Volunteer and People tables to get the name
                "WHERE t.ClientSSN = ?";                               // Filter by specific client SSN
 
 List<String> volunteerNames = new ArrayList<>();

 // Use try-with-resources to automatically close the PreparedStatement
 try (PreparedStatement stmt = conn.prepareStatement(query)) {
     stmt.setString(1, clientSSN);  // Set the client SSN parameter in the query
     try (ResultSet rs = stmt.executeQuery()) {
         // Loop through each result row
         while (rs.next()) {
             volunteerNames.add(rs.getString("Name"));  // Add each volunteer's name to the list
         }
     }
 }
 // Return the list of volunteer names
 return volunteerNames;
}


//--------------------------------------------------------------------------------------------
//Query 11: Retrieve the names of all teams founded after a specific date
public List<String> getTeamsFoundedAfterDate(String foundationDate) throws SQLException {
 // SQL query to select the names of teams founded after a given date
 String query = "SELECT Name FROM Team WHERE CreationDate > ?";
 List<String> teamNames = new ArrayList<>();

 // Use try-with-resources to ensure the PreparedStatement and ResultSet are closed
 try (PreparedStatement stmt = conn.prepareStatement(query)) {
     stmt.setString(1, foundationDate);  // Set the foundation date parameter for the query
     
     try (ResultSet rs = stmt.executeQuery()) {
         // Loop through each result and add the team names to the list
         while (rs.next()) {
             teamNames.add(rs.getString("Name"));
         }
     }
 }
 // Return the list of team names founded after the specified date
 return teamNames;
}


//-------------------------------------------------------------------------------------------------
//Query 12: Retrieve names, SSNs, contact information, and emergency contact information of all people
public List<Map<String, String>> getAllPeopleWithEmergencyContacts() throws SQLException {
 // SQL query to fetch names, SSNs, email, phone numbers, and emergency contact details of all people
 String query = "SELECT p.Name, p.SSN, p.Email, p.PhoneNumber, " +
                "e.Name AS EmergencyContactName, e.PhoneNumber AS EmergencyContactPhone, e.Relationship " +
                "FROM People p " +
                "LEFT JOIN EmergencyContacts e ON p.SSN = e.SSN";
 
 List<Map<String, String>> peopleInfo = new ArrayList<>();

 // Execute the query and process the results
 try (PreparedStatement stmt = conn.prepareStatement(query);
      ResultSet rs = stmt.executeQuery()) {
     // For each result, create a map of person and emergency contact information
     while (rs.next()) {
         Map<String, String> person = new HashMap<>();
         person.put("Name", rs.getString("Name"));
         person.put("SSN", rs.getString("SSN"));
         person.put("Email", rs.getString("Email"));
         person.put("PhoneNumber", rs.getString("PhoneNumber"));
         person.put("EmergencyContactName", rs.getString("EmergencyContactName"));
         person.put("EmergencyContactPhone", rs.getString("EmergencyContactPhone"));
         person.put("Relationship", rs.getString("Relationship"));
         peopleInfo.add(person); // Add each person's info to the list
     }
 }
 // Return the list of people with their contact and emergency contact information
 return peopleInfo;
}

//----------------------------------------------------------------------------------------------
//Query 13: Retrieve the name and total amount donated by donors who are also employees
public List<Map<String, Object>> getEmployeeDonorTotals() throws SQLException {
 // SQL query to retrieve the names and total donations for people who are both employees and donors
 String query = "SELECT p.Name, SUM(d.Amount) AS TotalDonated " +
                "FROM People p " +
                "JOIN Donor don ON p.SSN = don.SSN " + // Ensure they are donors
                "JOIN Employee emp ON p.SSN = emp.SSN " + // Ensure they are employees
                "JOIN Donation d ON don.SSN = d.SSN " + // Retrieve donations
                "GROUP BY p.Name";
 
 List<Map<String, Object>> donorTotals = new ArrayList<>();

 // Execute the query and process the results
 try (PreparedStatement stmt = conn.prepareStatement(query);
      ResultSet rs = stmt.executeQuery()) {
     // For each result, create a map to store the name and total donated amount
     while (rs.next()) {
         Map<String, Object> donor = new HashMap<>();
         donor.put("Name", rs.getString("Name"));
         donor.put("TotalDonated", rs.getDouble("TotalDonated"));
         donorTotals.add(donor); // Add each donor's details to the list
     }
 }
 // Return the list of employee-donors and their total donations
 return donorTotals;
}


//-----------------------------------------------------------------------------------------------
//Query 14: Increase the salary by 10% for employees to whom more than one team must report
public int increaseSalaryForMultipleTeams() throws SQLException {
 // SQL statement to increase the salary of employees who manage more than one team
 String updateSalarySql = "UPDATE Employee SET Salary = Salary * 1.10 " +
                          "WHERE SSN IN (SELECT EmployeeSSN FROM TeamReportsToEmployee " +
                          "GROUP BY EmployeeSSN HAVING COUNT(DISTINCT TeamName) > 1)";

 // Execute the update statement and return the number of affected rows
 try (PreparedStatement stmt = conn.prepareStatement(updateSalarySql)) {
     int rowsAffected = stmt.executeUpdate();
     return rowsAffected; // Return count of rows where salary was increased
 }
}


//---------------------------------------------------------------------------------
//Query 15: Delete clients without insurance and with low necessity for transportation
public int deleteClientsWithoutInsuranceAndLowTransportNecessity() throws SQLException {
    int rowsAffected = 0;

    // Step 1: Delete from Needs table where clients match the criteria
    String deleteNeedsQuery = "DELETE FROM Needs " +
                              "WHERE ClientSSN IN (SELECT SSN FROM Client " +
                              "WHERE SSN NOT IN (SELECT ClientSSN FROM InsurancePolicy) " +
                              "OR SSN IN (SELECT ClientSSN FROM Needs WHERE NeedName = 'Transportation' AND NecessityNumber < 5))";

    try (PreparedStatement stmtNeeds = conn.prepareStatement(deleteNeedsQuery)) {
        stmtNeeds.executeUpdate(); // Delete from Needs table
    }

    // Step 2: Delete from TakeCareOf table for clients without insurance or with low transportation necessity
    String deleteTakeCareOfQuery = "DELETE FROM TakeCareOf " +
                                   "WHERE ClientSSN IN (SELECT SSN FROM Client " +
                                   "WHERE SSN NOT IN (SELECT ClientSSN FROM InsurancePolicy) " +
                                   "OR SSN IN (SELECT ClientSSN FROM Needs WHERE NeedName = 'Transportation' AND NecessityNumber < 5))";

    try (PreparedStatement stmtTakeCareOf = conn.prepareStatement(deleteTakeCareOfQuery)) {
        stmtTakeCareOf.executeUpdate(); // Delete from TakeCareOf table
    }

    // Step 3: Delete from Client table where clients match the criteria
    String deleteClientQuery = "DELETE FROM Client " +
                               "WHERE SSN NOT IN (SELECT ClientSSN FROM InsurancePolicy) " +
                               "OR SSN IN (SELECT ClientSSN FROM Needs WHERE NeedName = 'Transportation' AND NecessityNumber < 5)";

    try (PreparedStatement stmtClient = conn.prepareStatement(deleteClientQuery)) {
        rowsAffected = stmtClient.executeUpdate(); // Delete from Client table
    }

    return rowsAffected; // Return the number of deleted client rows
}



//--------------------------------------------------------------------------
//Method to import teams from a file
public int importTeamsFromFile(String fileName) throws IOException, SQLException {
 int teamsAdded = 0; // Counter for teams successfully added

 // Construct the full file path by appending .txt to the specified filename and using the base directory
 String filePath = BASE_DIRECTORY + fileName + ".txt";

 try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
     // Read the number of teams from the first line of the file
     int numberOfTeams = Integer.parseInt(reader.readLine().trim());

     // SQL statement template for inserting team data
     String insertTeamSql = "INSERT INTO Team (Name, Type, CreationDate, TeamLeaderSSN) VALUES (?, ?, ?, ?)";
     try (PreparedStatement stmt = conn.prepareStatement(insertTeamSql)) {
         // Loop through each team entry in the file
         for (int i = 0; i < numberOfTeams; i++) {
             // Read team details from subsequent lines
             String name = reader.readLine().trim();
             String type = reader.readLine().trim();
             Date creationDate = Date.valueOf(reader.readLine().trim()); // Convert date from string format
             String teamLeaderSSN = reader.readLine().trim();

             // Set values in the prepared statement
             stmt.setString(1, name);
             stmt.setString(2, type);
             stmt.setDate(3, creationDate);
             stmt.setString(4, teamLeaderSSN);

             // Execute the insertion
             stmt.executeUpdate();
             teamsAdded++; // Increment the counter for each successful insertion
         }
     }
 }

 return teamsAdded; // Returns the total count of teams successfully added
}



//-----------------------------------------

//Method to export names and addresses of people on the mailing list to a CSV file
public String exportMailingListToCSV(String fileName) throws SQLException, IOException {
 // Define the file path for the CSV file based on the provided file name
 String filePath = EXPORT_DIRECTORY + fileName + ".csv";

 // SQL query to retrieve the names and addresses of people who are on the mailing list
 String query = "SELECT Name, Address FROM People WHERE MailingList = 1";

 try (PreparedStatement stmt = conn.prepareStatement(query);
      ResultSet rs = stmt.executeQuery();
      PrintWriter writer = new PrintWriter(new FileWriter(filePath))) {
     
     // Write CSV header row
     writer.println("Name,Address");

     // Process each record and write to the CSV file
     while (rs.next()) {
         String name = rs.getString("Name");
         String address = rs.getString("Address");

         // Write each record in CSV format, with fields enclosed in quotes
         writer.println("\"" + name + "\",\"" + address + "\"");
     }
 }

 // Return the file path for download or further processing
 return filePath;
}








}
 

    





