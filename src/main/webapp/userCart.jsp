<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%
    // Get username from request parameter
    String username = request.getParameter("username");

    // Database connection
    String url = System.getenv("DB_URL");
        String dbUser = System.getenv("DB_USER");
        String dbPassword = System.getenv("DB_PASSWORD");
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    Map<String, Integer> itemCountMap = new HashMap<>();
    double totalCost = 0.0;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection(url, dbUser, dbPassword);

        // Fetch user cart details
        String query = "SELECT items FROM user_cart WHERE user = ?";
        ps = con.prepareStatement(query);
        ps.setString(1, username);
        rs = ps.executeQuery();

        if (rs.next()) {
            String items = rs.getString("items");
            JSONArray itemsArray = new JSONArray(items);
            
            // Count the quantity of each item and calculate total cost
            for (int i = 0; i < itemsArray.length(); i++) {
                String itemId = itemsArray.getString(i);
                itemCountMap.put(itemId, itemCountMap.getOrDefault(itemId, 0) + 1);
            }

            for (Map.Entry<String, Integer> entry : itemCountMap.entrySet()) {
                String itemId = entry.getKey();
                int quantity = entry.getValue();

                PreparedStatement psItem = con.prepareStatement("SELECT cost FROM products WHERE item_id = ?");
                psItem.setString(1, itemId);
                ResultSet rsItem = psItem.executeQuery();
                if (rsItem.next()) {
                    totalCost += rsItem.getDouble("cost") * quantity;
                }
                rsItem.close();
                psItem.close();
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }

    // Store itemCountMap and total cost in request attributes
    request.setAttribute("itemCountMap", itemCountMap);
    request.setAttribute("totalCost", totalCost);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Cart</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 800px;
            margin: auto;
            padding: 20px;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        h2 {
            text-align: center;
            margin-top: 0;
        }
        .item {
            border-bottom: 1px solid #ddd;
            padding: 10px 0;
            display: flex;
            align-items: center;
        }
        .item:last-child {
            border-bottom: none;
        }
        .item img {
            width: 100px;
            height: 100px;
            margin-right: 20px;
        }
        .total-cost {
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Cart Items for <%= username %></h2>
        <%
            Map<String, Integer> itemCountMapAttr = (Map<String, Integer>) request.getAttribute("itemCountMap");
            double totalCostAttr = (double) request.getAttribute("totalCost");

            if (itemCountMapAttr != null && !itemCountMapAttr.isEmpty()) {
                for (Map.Entry<String, Integer> entry : itemCountMapAttr.entrySet()) {
                    String itemId = entry.getKey();
                    int quantity = entry.getValue();
                    String name = "";
                    double cost = 0.0;
                    String imageUrl = "";

                    // Re-establish connection to get product details
                    try {
                        con = DriverManager.getConnection(url, dbUser, dbPassword);
                        PreparedStatement psItem = con.prepareStatement("SELECT name, cost, image_url FROM products WHERE item_id = ?");
                        psItem.setString(1, itemId);
                        ResultSet rsItem = psItem.executeQuery();
                        if (rsItem.next()) {
                            name = rsItem.getString("name");
                            cost = rsItem.getDouble("cost");
                            imageUrl = rsItem.getString("image_url");
                        }
                        rsItem.close();
                        psItem.close();
                        con.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

        %>
                        <div class="item">
                            <img src="<%= imageUrl %>" alt="<%= name %>">
                            <div>
                                <p><strong>Name:</strong> <%= name %></p>
                                <p><strong>Cost:</strong> Rs.<%= cost %></p>
                                <p><strong>Quantity:</strong> <%= quantity %></p>
                            </div>
                        </div>
        <%
                }
        %>
                <div class="total-cost">
                    <p><strong>Total Cost:</strong> Rs.<%= totalCostAttr %></p>
                    <button>Checkout</button>
                </div>
        <%
            } else {
        %>
                <p>No items in cart.</p>
        <%
            }
        %>
    </div>
</body>
</html>
