package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UserInfoServlet")
public class Insert_user extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        String pincode = request.getParameter("pincode");
        String phone = request.getParameter("phone");
        System.out.print(firstName+" **************"+lastName);
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        try {
        	   final String jdbc_url = System.getenv("DB_JDBC_URL");
			   final String username = System.getenv("DB_USER");
			   final String password = System.getenv("DB_PASSWORD");
			   Class.forName("com.mysql.cj.jdbc.Driver");
		      Connection con = DriverManager.getConnection(jdbc_url, username, password);
            // Insert data into user_info table
		      System.out.print(firstName+" ////////////// "+lastName);
            String sql = "INSERT INTO user_info (first_name, last_name, gender, address, pincode, phone) VALUES (?, ?, ?, ?, ?, ?)";
            preparedStatement = con.prepareStatement(sql);
            preparedStatement.setString(1, firstName);
            preparedStatement.setString(2, lastName);
            preparedStatement.setString(3, gender);
            preparedStatement.setString(4, address);
            preparedStatement.setString(5, pincode);
            preparedStatement.setString(6, phone);
            preparedStatement.executeUpdate();
            System.out.print(firstName+" **************"+lastName);
            // Redirect to register.jsp
            response.sendRedirect("register.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while processing your request.");
        } finally {
            try {
                if (preparedStatement != null) preparedStatement.close();
                if (connection != null) connection.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}

