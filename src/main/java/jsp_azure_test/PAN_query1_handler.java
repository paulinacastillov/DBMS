import java.io.IOException;
import javax.servlet.ServletException;
// import javax.servlet.annotation.WebServlet; (commented out, if not needed)
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import jsp_azure_test.DataHandler;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/PAN_query1_handler") 
public class PAN_query1_handler extends HttpServlet {
    // Register servlet manually through web.xml if the annotation isn't working properly {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String teamName = request.getParameter("teamName");
        String teamType = request.getParameter("teamType");
        String creationDate = request.getParameter("creationDate");

        DataHandler dataHandler;
        try {
            dataHandler = new DataHandler();
            Connection conn = dataHandler.getConnection();

            // Check if the team already exists
            String checkTeamSQL = "SELECT COUNT(*) AS count FROM Team WHERE team_name = ?";
            PreparedStatement checkStatement = conn.prepareStatement(checkTeamSQL);
            checkStatement.setString(1, teamName);
            ResultSet resultSet = checkStatement.executeQuery();

            if (resultSet.next() && resultSet.getInt("count") > 0) {
                response.getWriter().print("exists");
            } else {
                // Insert new team
                String insertTeamSQL = "INSERT INTO Team (team_name, team_type, creation_date) VALUES (?, ?, ?)";
                PreparedStatement insertStatement = conn.prepareStatement(insertTeamSQL);
                insertStatement.setString(1, teamName);
                insertStatement.setString(2, teamType);
                insertStatement.setString(3, creationDate);

                int rowsAffected = insertStatement.executeUpdate();
                if (rowsAffected > 0) {
                    response.getWriter().print("success");
                } else {
                    response.getWriter().print("failure");
                }
                insertStatement.close();
            }

            checkStatement.close();
            resultSet.close();
            conn.close();

        } catch (SQLException e) {
            response.getWriter().print("<p>Error: Unable to connect to database or execute SQL statement.</p>");
            e.printStackTrace();
        }
    }
}
