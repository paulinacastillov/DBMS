import java.sql.*;
import java.util.Scanner;

public class Group_10_Problem2_HW3 {

    // Database credentials
    private static final String HOSTNAME = "varg0066-sql-server.database.windows.net";
    private static final String DBNAME = "cs-dsa-4513-sql-db";
    private static final String USERNAME = "login";
    private static final String PASSWORD = "password";

    // Database connection string
    private static final String URL = String.format(
            "jdbc:sqlserver://%s:1433;database=%s;user=%s;password=%s;encrypt=true;" +
            "trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;",
            HOSTNAME, DBNAME, USERNAME, PASSWORD);

    public static void main(String[] args) {
        try (Connection connection = DriverManager.getConnection(URL)) {
            Scanner scanner = new Scanner(System.in);
            boolean running = true;

            while (running) {
                System.out.println("\n--- Faculty Management ---");
                System.out.println("1. Insert New Faculty Member");
                System.out.println("2. Display All Faculty Members");
                System.out.println("3. Exit");
                System.out.print("Choose an option: ");
                int choice = scanner.nextInt();

                switch (choice) {
                    case 1:
                        insertFacultyMember(connection, scanner);
                        break;
                    case 2:
                        displayAllFaculty(connection);
                        break;
                    case 3:
                        System.out.println("Exiting...");
                        running = false;
                        break;
                    default:
                        System.out.println("Invalid option. Please try again.");
                }
            }
            scanner.close();
        } catch (SQLException e) {
            System.err.println("Database connection error: " + e.getMessage());
        }
    }

    // Method to insert a new faculty member using the InsertFaculty stored procedure
    private static void insertFacultyMember(Connection connection, Scanner scanner) {
        try {
            System.out.print("Enter Faculty ID: ");
            int fid = scanner.nextInt();
            scanner.nextLine(); // Consume newline

            System.out.print("Enter Faculty Name: ");
            String fname = scanner.nextLine();

            System.out.print("Enter Department ID: ");
            int deptid = scanner.nextInt();

            System.out.print("Exclude specific department (1 for Yes, 0 for No): ");
            int excludeDeptFlag = scanner.nextInt();

            Integer excludeDeptId = null;
            if (excludeDeptFlag == 1) {
                System.out.print("Enter Department ID to exclude: ");
                excludeDeptId = scanner.nextInt();
            }

            String sql = "{CALL InsertFaculty(?, ?, ?, ?, ?)}";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setInt(1, fid);
                statement.setString(2, fname);
                statement.setInt(3, deptid);
                statement.setInt(4, excludeDeptFlag);
                if (excludeDeptId != null) {
                    statement.setInt(5, excludeDeptId);
                } else {
                    statement.setNull(5, Types.INTEGER);
                }

                statement.executeUpdate();
                System.out.println("Faculty member added successfully.");
            }
        } catch (SQLException e) {
            System.err.println("SQL error during faculty insertion: " + e.getMessage());
        }
    }

    // Method to display all faculty information
    private static void displayAllFaculty(Connection connection) {
        String query = "SELECT fid, fname, deptid, salary FROM Faculty";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            System.out.println("\nFaculty Information:");
            System.out.println("FID | Name | DeptID | Salary");

            while (rs.next()) {
                System.out.printf("%d | %s | %d | %.2f%n",
                        rs.getInt("fid"),
                        rs.getString("fname"),
                        rs.getInt("deptid"),
                        rs.getFloat("salary"));
            }
        } catch (SQLException e) {
            System.err.println("SQL error during faculty display: " + e.getMessage());
        }
    }
}