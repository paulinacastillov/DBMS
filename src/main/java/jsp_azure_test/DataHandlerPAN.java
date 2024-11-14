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

public class DataHandler {

    private Connection conn;

    // Azure SQL connection credentials
    private String server = "cast0333-sql-server.database.windows.net";
    private String database = "cs-dsa-4513-sql-db";
    private String username = "cast0333";
    private String password = "Pao3032001*";

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
}
