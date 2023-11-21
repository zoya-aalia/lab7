<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<nav style="padding:1px">
    <h1>A & Z's Grocery</h1>
</nav>
<div style="background-image: linear-gradient(to left, #769d6d, #242b99); padding:10px; ">
        <a href="shop.html" style="margin-left:20px">Home </a>
        <a href="listprod.jsp" style="margin-left:20px">Products</a>
        <a href="listorder.jsp" style="margin-left:20px">Orders</a>
        <a href="showcart.jsp" style="margin-left:20px">My Cart</a>
</div>
<style>
        h1 {color:#1baa82;}
        h2 {color:black;}
        a {color:antiquewhite}
</style>
<head>
<title>A & Z's Grocery Order List</title>
</head>
<body>
<h2>Order List</h2>
<table border="1">
    <%
    // Note: Forces loading of SQL Server driver 

    // Initialize Variables
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    // Load driver class
        
    try {	
	    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    }

    catch (java.lang.ClassNotFoundException e) {
	    System.err.println("ClassNotFoundException: " +e);
	    System.exit(1);
    }

    // 1. Connect to server

    try (Connection connection = DriverManager.getConnection(url, uid, pw); Statement stmt = connection.createStatement();) {

        // 2. query to retrieve all summary records
        String orderQuery = "SELECT * FROM ordersummary";
        PreparedStatement orderStatement = connection.prepareStatement(orderQuery);
        ResultSet orderResultSet = orderStatement.executeQuery();

        // 3. for each order in ResultSet

        // Useful code for formatting currency values:
        // NumberFormat currFormat = NumberFormat.getCurrencyInstance();
        // out.println(currFormat.format(5.0));  // Prints $5.00

        out.println("<th>Order ID</th>");
        out.println("<th>Order Date</th>");
        out.println("<th>Total Amount</th>");
        out.println("<th>Customer</th>");

        while (orderResultSet.next()) {
            // a. print out the order summary information
            int orderId = orderResultSet.getInt("orderId");
            Date orderDate = orderResultSet.getDate("orderDate");
            double totalAmount = orderResultSet.getDouble("totalAmount");
            int customerId = orderResultSet.getInt("customerId");

            String customerNameQuery = "SELECT firstName, lastName FROM customer WHERE customerId = ?";
            PreparedStatement customerStatement = connection.prepareStatement(customerNameQuery);
            customerStatement.setInt(1, customerId);
            ResultSet customerResultSet = customerStatement.executeQuery();

            if (customerResultSet.next()) {
                String firstName = customerResultSet.getString("firstName");
                String lastName = customerResultSet.getString("lastName");

                out.println("<tr><td>" + orderId + "</td>");
                out.println("<td>" + orderDate + "</td>");
                out.println("<td>" + NumberFormat.getCurrencyInstance().format(totalAmount) + "</td>");
                out.println("<td>" + firstName + " " + lastName + "</td></tr>");

                // b. write a query to retrieve the products in the order use a PreparedStatement as will repeat this query many times
                String productQuery = "SELECT * FROM orderproduct WHERE orderId = ?";
                PreparedStatement productStatement = connection.prepareStatement(productQuery);
                productStatement.setInt(1, orderId);
                ResultSet productResultSet = productStatement.executeQuery();

                // c. for each product in the order write out product information
                out.println("<tr><td><table border=\"1\"><th>Product ID:</th>");
                out.println("<th>Quantity</th>");
                out.println("<th>Price</th>");

                while (productResultSet.next()) {
                    // Write out product information
                    int productId = productResultSet.getInt("productId");
                    int quantity = productResultSet.getInt("quantity");
                    double price = productResultSet.getDouble("price");

                    out.println("<tr><td>" + productId + "</td><td>" + quantity + "</td><td>" + NumberFormat.getCurrencyInstance().format(price) + "</td></tr>");
                }

                out.println("</table></td></tr>");

                // close product ResultSet and Statement
                productResultSet.close();
                productStatement.close();
            }

            // close customer ResultSet and Statement
            customerResultSet.close();
            customerStatement.close();
        }
    } 
    catch (SQLException e) {
        // Handle SQLException if necessary
        out.println("SQLException: " + e);
    } 

    // Useful code for formatting currency values:
    // NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    // out.println(currFormat.format(5.0));  // Prints $5.00

    %>
</table>
</body>
</html>
