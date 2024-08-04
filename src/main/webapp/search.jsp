<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.*" %>
<%
    // Get the search query from the request
    String query = request.getParameter("query");
    String username = request.getParameter("username");
    String userId = request.getParameter("user_id");

    // Create a list to hold search results
    ArrayList<String[]> searchResults = new ArrayList<>();

    if (query != null && !query.trim().isEmpty()) {
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

            // Search query to fetch products matching the search term
            String searchQuery = "SELECT item_id, name, category, cost, image_url FROM products WHERE name LIKE ? OR category LIKE ?";
            ps = con.prepareStatement(searchQuery);
            ps.setString(1, "%" + query + "%");
            ps.setString(2, "%" + query + "%");
            rs = ps.executeQuery();

            while (rs.next()) {
                String[] product = new String[5];
                product[0] = rs.getString("item_id");
                product[1] = rs.getString("name");
                product[2] = rs.getString("category");
                product[3] = rs.getString("cost");
                product[4] = rs.getString("image_url");
                searchResults.add(product);
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
    <title>Search Results</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-image: url('https://wallpaperaccess.com/full/3259422.jpg');
            background-size: cover;
            height: 100vh;
        }
        .container {
            max-width: 1200px;
            margin: auto;
            padding: 20px;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 10px;
        }
        .product {
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-bottom: 20px;
            overflow: hidden;
            padding: 10px;
        }
        .product img {
            float: left;
            margin-right: 20px;
            max-width: 150px;
            max-height: 150px;
        }
        .product-info {
            overflow: hidden;
        }
        .product-info h3 {
            margin-top: 0;
            margin-bottom: 10px;
        }
        .product-info p {
            margin-top: 0;
        }
        .cost {
            font-weight: bold;
            color: #c45500;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Search Results for "<%= query %>"</h1>
        <%
            if (searchResults.isEmpty()) {
        %>
            <p>No results found.</p>
        <%
            } else {
                for (String[] product : searchResults) {
        %>
            <div class="product">
                <img src="<%= product[4] %>" alt="<%= product[1] %>">
                <div class="product-info">
                    <h3><%= product[1] %></h3>
                    <p><%= product[2] %></p>
                    <p class="cost">Cost: Rs.<%= product[3] %></p>
                </div>
                <div class="add-to-cart">
                    <form action="AddItemsToCart" method="post">
                        <input type="hidden" name="username" value="<%= username %>">
                        <input type="hidden" name="user_id" value="<%= userId %>">
                        <input type="hidden" name="item_id" value="<%= product[0] %>">
                        <button type="submit">Add to Cart</button>
                    </form>
                </div>
            </div>
        <%
                }
            }
        %>
    </div>
</body>
</html>
