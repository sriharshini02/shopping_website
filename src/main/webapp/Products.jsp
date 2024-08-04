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
    <title>Product List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-image: url('https://wallpaperaccess.com/full/3259422.jpg');
            background-size: cover; /* Ensures the image covers the entire background */
            
            
            height: 100vh; /* Sets the height of the body to fill the viewport */
            
        }
        .container {
            max-width: 1200px;
            margin: auto;
            padding: 20px;
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
        .navbar {
            overflow: hidden;
            background-color: #333;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 10px;
        }
        .navbar a {
            display: block;
            color: #f2f2f2;
            text-align: center;
            padding: 14px 16px;
            text-decoration: none;
        }
        .navbar a:hover {
            background-color: #ddd;
            color: black;
        }
        .profile {
            float: right;
        }
        .cart {
            float: right;
            margin-right: 20px;
        }
        .search-bar {
            flex-grow: 1;
            text-align: center;
        }
        .search-bar input[type="text"] {
            width: 60%;
            padding: 6px;
            font-size: 16px;
        }
    </style>
     <script type="text/javascript">
        window.onload = function() {
            // Check if the "added" parameter is present in the URL
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.has('added') && urlParams.get('added') === 'true') {
                // Display an alert
                alert('Item added to cart successfully!');
            }
        }
    </script>
</head>
<body>
    <div class="navbar">
        <a href="#"><img src="https://th.bing.com/th/id/OIG3.Ikg0zaMFyRbgrwSCFqMq?w=173&h=173&c=6&r=0&o=5&dpr=1.3&pid=ImgGn" alt="logo" width="50" height="30"></a>
        <div class="search-bar">
    <form action="search.jsp" method="get">
        <input type="text" name="query" placeholder="Search...">
        <input type="hidden" name="username" value="<%= username %>">
        <input type="hidden" name="user_id" value="<%= userId %>">
        <button type="submit">Search</button>
    </form>
</div>

        <div class="profile">
            <% if (username != null) { %>
                <a href="profile.jsp?user_id=<%= userId %>">Profile: <%= username %></a>
            <% } else { %>
                <a href="profile.jsp">Profile</a>
            <% } %>
        </div>
        <div class="cart">
            <% if (username != null) { %>
                <a href="userCart.jsp?username=<%= username %>"><img src="https://tse4.mm.bing.net/th?id=OIP.wajWB9iV_Mq6UW45YcNjVAHaHB&pid=Api&P=0&h=180" alt="Cart" width="30" height="30"></a>
            <% } else { %>
                <a href="userCart.jsp"><img src="https://tse4.mm.bing.net/th?id=OIP.wajWB9iV_Mq6UW45YcNjVAHaHB&pid=Api&P=0&h=180" alt="Cart" width="30" height="30"></a>
            <% } %>
        </div>
    </div>
    <div class="container">
        <!-- Products listing -->
        <h1 style="color:#800080;"><b>Stationery</b></h1>
        <div class="product">
            <img src="http://c.shld.net/rpx/i/s/i/spin/10094916/prod_2011198012??hei=64&wid=64&qlt=50" alt="Setof10Pens">
            <div class="product-info">
                <h3>Set of 10 Pens</h3>
                <p>High-quality pens for your everyday writing needs.</p>
                <p class="cost">Cost: Rs.100</p>
            </div>
            <div class="add-to-cart">
                <form action="AddItemsToCart" method="post">
                    <input type="hidden" name="username" value="<%= username %>">
                    <input type="hidden" name="user_id" value="<%= userId %>">
                    <input type="hidden" name="item_id" value="a01">
                    <button type="submit">Add to Cart</button>
                </form>
            </div>
        </div>

        <div class="product">
            <img src="https://5.imimg.com/data5/SELLER/Default/2022/4/KC/QK/XD/53216334/classmate-pulse-notebooks1-1000x1000.jpg" alt="Classmate Notebook">
            <div class="product-info">
                <h3>Classmate Notebook</h3>
                <p>A premium quality notebook for your school or office needs.</p>
                <p class="cost">Cost: Rs.85</p>
            </div>
            <div class="add-to-cart">
                <form action="AddItemsToCart" method="post">
                    <input type="hidden" name="username" value="<%= username %>">
                    <input type="hidden" name="user_id" value="<%= userId %>">
                    <input type="hidden" name="item_id" value="a02">
                    <button type="submit">Add to Cart</button>
                </form>
            </div>
        </div>

        <div class="product">
            <img src="https://m.media-amazon.com/images/I/81PJjqme2-L.jpg" alt="Diary">
            <div class="product-info">
                <h3>Diary</h3>
                <p>Keep your thoughts and memories organized with this beautiful diary.</p>
                <p class="cost">Cost: Rs.120</p>
            </div>
            <div class="add-to-cart">
                <form action="AddItemsToCart" method="post">
                    <input type="hidden" name="username" value="<%= username %>">
                    <input type="hidden" name="user_id" value="<%= userId %>">
                    <input type="hidden" name="item_id" value="a03">
                    <button type="submit">Add to Cart</button>
                </form>
            </div>
        </div>

        <div class="product">
            <img src="https://www.razorstationery.com.au/wp-content/uploads/2019/09/Stapler-0251-Deli.jpg" alt="Stapler">
            <div class="product-info">
                <h3>Stapler</h3>
                <p>A handy tool for your office or home use.</p>
                <p class="cost">Cost: Rs.30.50</p>
            </div>
            <div class="add-to-cart">
                <form action="AddItemsToCart" method="post">
                    <input type="hidden" name="username" value="<%= username %>">
                    <input type="hidden" name="user_id" value="<%= userId %>">
                    <input type="hidden" name="item_id" value="a04">
                    <button type="submit">Add to Cart</button>
                </form>
            </div>
        </div>
        <h1 style="color:#800080;"><b>Fiction books</b></h1>
        <div class="product">
            <img src="https://m.media-amazon.com/images/I/71-eED8jSYL._SY342_.jpg" alt="book">
            <div class="product-info">
                <h3>As You Like It [Paperback] William Shakespeare</h3>
                <p>  1 May 2018</p>
                <p class="cost">Cost: Rs.120</p>
            </div>
            <div class="add-to-cart">
                <form action="AddItemsToCart" method="post">
                    <input type="hidden" name="username" value="<%= username %>">
                    <input type="hidden" name="user_id" value="<%= userId %>">
                    <input type="hidden" name="item_id" value="a05">
                    <button type="submit">Add to Cart</button>
                </form>
            </div>
        </div>
       <div class="product">
            <img src="https://m.media-amazon.com/images/I/81p8vyCsJvL._SY342_.jpg" alt="book">
            <div class="product-info">
                <h3>The Case-Book of Sherlock Holmes</h3>
                <p> [Paperback] Sir Arthur Conan Doyle: 1 August 2018</p>
                <p class="cost">Cost: Rs.150</p>
            </div>
            <div class="add-to-cart">
                <form action="AddItemsToCart" method="post">
                    <input type="hidden" name="username" value="<%= username %>">
                    <input type="hidden" name="user_id" value="<%= userId %>">
                    <input type="hidden" name="item_id" value="a06">
                    <button type="submit">Add to Cart</button>
                </form>
            </div>
        </div> 
        <div class="product">
            <img src="https://m.media-amazon.com/images/I/A1dtQ-soQEL._SY342_.jpg" alt="book">
            <div class="product-info">
                <h3>The Palace of Illusions</h3>
                <p>10th Anniversary Edition [Paperback] Banerjee Divakaruni, Chitra  </p>
                <p>24 May 2019</p>
                <p class="cost">Cost: Rs.315</p>
            </div>
            <div class="add-to-cart">
                <form action="AddItemsToCart" method="post">
                    <input type="hidden" name="username" value="<%= username %>">
                    <input type="hidden" name="user_id" value="<%= userId %>">
                    <input type="hidden" name="item_id" value="a07">
                    <button type="submit">Add to Cart</button>
                </form>
            </div>   
        </div> 
        <div class="product">
            <img src="https://m.media-amazon.com/images/I/41kRkqIt6aL._SY445_SX342_.jpg" alt="book">
            <div class="product-info">
                <h3>That Night: Four Friends, Twenty Years</h3>
                <p>Paperback : 1 January 2021 by Nidhi Upadhyay (Author)</p>
                <p class="cost">Cost: Rs.164</p>
            </div>
            <div class="add-to-cart">
                <form action="AddItemsToCart" method="post">
                    <input type="hidden" name="username" value="<%= username %>">
                    <input type="hidden" name="user_id" value="<%= userId %>">
                    <input type="hidden" name="item_id" value="a08">
                    <button type="submit">Add to Cart</button>
                </form>
            </div>   
        </div> 
        <h1  style="color:#800080;"><b>Home Appliances</b></h1>
        <div class="product">
            <img src="https://m.media-amazon.com/images/I/51nZYtFooaL._SX679_.jpg" alt="sandwich maker">
            <div class="product-info">
                <h3>Wipro Vesta BS101 Sandwich Maker</h3>
                <p>Standard Size | Auto Temp Control| Smart LED Indicator
                Non-stick-BPA& PFOA Free|White|1 year warranty
                | Regular Bread Size for 2 Slices|700 Watt</p>
                <p class="cost">Cost: Rs.1299</p>
            </div>
            <div class="add-to-cart">
                <form action="AddItemsToCart" method="post">
                    <input type="hidden" name="username" value="<%= username %>">
                    <input type="hidden" name="user_id" value="<%= userId %>">
                    <input type="hidden" name="item_id" value="a09">
                    <button type="submit">Add to Cart</button>
                </form>
            </div>   
        </div> 
        <div class="product">
            <img src="https://m.media-amazon.com/images/I/71cn-i+GCZL._SX679_.jpg" alt="air fryer">
            <div class="product-info">
                <h3>Instant Pot Air Fryer</h3>
                <p>Vortex 6 Litre,Touch Control Panel,360° Evencrisp Technology,Uses 95 % Less Oil |6-In-1 Appliance: Air Fry,Roast,Broil,Bake,Reheat,Dehydrate(Vortex 6 Litre)1500 Watts,Silver</p>
                <p class="cost">Cost: Rs.8998</p>
            </div>
            <div class="add-to-cart">
                <form action="AddItemsToCart" method="post">
                    <input type="hidden" name="username" value="<%= username %>">
                    <input type="hidden" name="user_id" value="<%= userId %>">
                    <input type="hidden" name="item_id" value="a10">
                    <button type="submit">Add to Cart</button>
                </form>
            </div>   
        </div> 
        <div class="product">
            <img src="https://m.media-amazon.com/images/I/61Vba+XFupL._SX679_.jpg" alt="sealer">
            <div class="product-info">
                <h3>VIVNITS Portable Mini Sealing Machine</h3>
                <p>2 in 1 USB Rechargeable Magnetic Bag Sealer Heat Seal with Cutter,</p>
                <p> Plastic Bags Packing Machine Home Appliances</p>
                <p class="cost">Cost: Rs.449</p>
            </div>
            <div class="add-to-cart">
                <form action="AddItemsToCart" method="post">
                    <input type="hidden" name="username" value="<%= username %>">
                    <input type="hidden" name="user_id" value="<%= userId %>">
                    <input type="hidden" name="item_id" value="a11">
                    <button type="submit">Add to Cart</button>
                </form>
            </div>   
        </div>
        <div class="product">
            <img src="https://m.media-amazon.com/images/I/51akzQvvIuL._SX679_.jpg" alt="vaccum cleaner">
            <div class="product-info">
                <h3>Eureka Forbes Robo Vac N Mop NUO Wet and Dry Robotic Vacuum Cleaner</h3>
                <p>Gyroscope Navigation|App Based Control| Multisurface Cleaning Vacuum Cleaner</p>
                
                <p class="cost">Cost: Rs.15999</p>
            </div>
            <div class="add-to-cart">
                <form action="AddItemsToCart" method="post">
                    <input type="hidden" name="username" value="<%= username %>">
                    <input type="hidden" name="user_id" value="<%= userId %>">
                    <input type="hidden" name="item_id" value="a12">
                    <button type="submit">Add to Cart</button>
                </form>
            </div>   
        </div>
        
    </div>
</body>
</html>
