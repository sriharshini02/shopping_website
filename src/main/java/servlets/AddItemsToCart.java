package servlets;
import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AddItemsToCart extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve username and item_id from the request
        String username = request.getParameter("username");
        String itemId = request.getParameter("item_id");
        String userId = request.getParameter("user_id");

        // Database connection parameters
        String url = System.getenv("DB_URL");
        String dbUser = System.getenv("DB_USER");
        String dbPassword = System.getenv("DB_PASSWORD");


        Connection conn = null;
        PreparedStatement ps = null;

        try {
            // Establish the database connection
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, dbUser, dbPassword);

            // Check if the user already has a cart entry
            String checkQuery = "SELECT * FROM user_cart WHERE user = ?";
            ps = conn.prepareStatement(checkQuery);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // If the user already has a cart entry, update the items JSON array
                String items = rs.getString("items");
                items = items.substring(0, items.length() - 1) + ",\"" + itemId + "\"]";

                // Update the items in the user's cart
                String updateQuery = "UPDATE user_cart SET items = ? WHERE user = ?";
                ps = conn.prepareStatement(updateQuery);
                ps.setString(1, items);
                ps.setString(2, username);
                ps.executeUpdate();
            } else {
                // If the user does not have a cart entry, create a new entry
                String insertQuery = "INSERT INTO user_cart (user, items) VALUES (?, ?)";
                ps = conn.prepareStatement(insertQuery);
                ps.setString(1, username);
                ps.setString(2, "[\"" + itemId + "\"]");
                ps.executeUpdate();
            }

            // Redirect back to the products page with a success parameter and the user_id
            response.sendRedirect("Products.jsp?user_id=" + userId + "&added=true");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            // Close the database connection and prepared statement
            try {
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
