<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    // Get user_id from request parameter
    String userId = request.getParameter("user_id");

    String username = null;
    String first_name = null;
    String last_name = null;
    String address = null;
    String gender = null;
    int pincode = -1;
    long phone = -1;

    if (userId != null) {
        // Database connection
        String url = System.getenv("DB_URL");
        String dbUser = System.getenv("DB_USER");
        String dbPassword = System.getenv("DB_PASSWORD");
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, dbUser, dbPassword);

            // Fetch user details
            String query = "SELECT ua.user, ui.first_name, ui.last_name, ui.gender, ui.address, ui.pincode, ui.phone FROM user_auth_details ua " +
                           "JOIN user_info ui ON ua.user_id = ui.user_id " +
                           "WHERE ua.user_id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, Integer.parseInt(userId));
            rs = ps.executeQuery();

            if (rs.next()) {
                username = rs.getString("user");
                first_name = rs.getString("first_name");
                last_name = rs.getString("last_name");
                address = rs.getString("address");
                gender = rs.getString("gender");
                pincode = rs.getInt("pincode");
                phone = rs.getLong("phone");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .profile-header {
            text-align: center;
            margin-bottom: 20px;
        }
        .profile-header img {
            border-radius: 50%;
            width: 150px;
            height: 150px;
            margin-bottom: 10px;
        }
        .profile-header h2 {
            margin: 0;
            font-size: 24px;
            color: #333;
        }
        .profile-details {
            list-style: none;
            padding: 0;
        }
        .profile-details li {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .profile-details li span {
            font-weight: bold;
            color: #555;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="profile-header">
            <img src="https://www.svgrepo.com/show/496485/profile-circle.svg" alt="Profile Picture">
            <h2><%= first_name %> <%= last_name %></h2>
        </div>
        <ul class="profile-details">
            <li><span>Username:</span> <%= username %></li>
            <li><span>First Name:</span> <%= first_name %></li>
            <li><span>Last Name:</span> <%= last_name %></li>
            <li><span>Gender:</span> <%= gender %></li>
            <li><span>Address:</span> <%= address %></li>
            <li><span>Pincode:</span> <%= pincode %></li>
            <li><span>Phone:</span> <%= phone %></li>
        </ul>
    </div>
</body>
</html>
