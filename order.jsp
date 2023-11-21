<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>A & Z's Grocery Order Processing</title>
    <style>
        h1 {color:#1baa82;}
        h2 {color:black;}
        a {color:antiquewhite}
    </style>
</head>
<body>

<nav style="padding:1px">
    <h1>A & Z's Grocery</h1>
</nav>
<div style="background-image: linear-gradient(to left, #769d6d, #242b99); padding:10px; ">
    <a href="shop.html" style="margin-left:20px">Home </a>
    <a href="listprod.jsp" style="margin-left:20px">Products</a>
    <a href="listorder.jsp" style="margin-left:20px">Orders</a>
    <a href="showcart.jsp" style="margin-left:20px">My Cart</a>
</div>

<% 
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Check if valid customer id was entered and if there are products in the shopping cart
if (custId != null && productList != null && !productList.isEmpty()) {
    
    // Initialize Variables
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    // Load driver class    
    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (java.lang.ClassNotFoundException e) {
        System.err.println("ClassNotFoundException: " + e);
        System.exit(1);
    }

    // Initialize orderId
    int orderId = 0;

    // 1. Connect to server
    try (Connection connection = DriverManager.getConnection(url, uid, pw); Statement stmt = connection.createStatement();) {

        // Begin transaction
        connection.setAutoCommit(false);

        try {
            String checkIdQuery = "SELECT firstName, lastName FROM customer WHERE customerId = ?";
            PreparedStatement checkIdStatement = connection.prepareStatement(checkIdQuery);
            checkIdStatement.setString(1, custId);
            ResultSet checkIdResultSet = checkIdStatement.executeQuery();

            String first = "";
            String last = "";

            while (checkIdResultSet.next()) {
                first = checkIdResultSet.getString("firstName");
                last = checkIdResultSet.getString("lastName");
            }

            if (!first.isEmpty() && !last.isEmpty()) {

                // 2. Save order information to the database
                String orderInsertQuery = "INSERT INTO orderSummary (customerId, orderDate, totalAmount) VALUES (?, GETDATE(), ?)";
                PreparedStatement orderStmt = connection.prepareStatement(orderInsertQuery, Statement.RETURN_GENERATED_KEYS);
                orderStmt.setInt(1, Integer.parseInt(custId));

                // Calculate total amount
                double totalAmount = 0;
                Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
                while (iterator.hasNext()) {
                    Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                    ArrayList<Object> product = entry.getValue();
                    String productId = (String) product.get(0);
				    String price = (String) product.get(2);
                    int quantity = (Integer) product.get(3);

                    // Calculate total amount for the order
                    totalAmount += quantity * Double.parseDouble(price);
                }

                // Set total amount in orderSummary
                orderStmt.setDouble(2, totalAmount);

                // Execute order statement
                orderStmt.executeUpdate();

                // 3. Retrieve auto-generated order id
                ResultSet generatedKeys = orderStmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    orderId = generatedKeys.getInt(1);

                    // Insert each item into OrderProduct table using OrderId from the previous INSERT
                    Iterator<Map.Entry<String, ArrayList<Object>>> productIterator = productList.entrySet().iterator();
                    while (productIterator.hasNext()) {
                        Map.Entry<String, ArrayList<Object>> entry = productIterator.next();
                        ArrayList<Object> product = entry.getValue();
                        String productId = (String) product.get(0);
                        String price = (String) product.get(2);
					    int quantity = (Integer) product.get(3);

                        // Insert product into OrderProduct table
                        String productInsertQuery = "INSERT INTO orderProduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
                        PreparedStatement productStmt = connection.prepareStatement(productInsertQuery);

                        // Set parameters for product statement
                        productStmt.setInt(1, orderId);
                        productStmt.setInt(2, Integer.parseInt(productId));
                        productStmt.setInt(3, quantity);
                        productStmt.setDouble(4, Double.parseDouble(price));

                        // Execute product statement
                        productStmt.executeUpdate();
                    }

                    // Commit the transaction
                    connection.commit();

                    // 4. Print out order summary
				    out.println("<h2>Your Order Summary</h2>");
                    out.println("<table><th>Product Id</th>");
				    out.println("<th>Product Name</th>");
				    out.println("<th>Quantity</th>");
				    out.println("<th>Price</th>");
				    out.println("<th>Subtotal</th>");

                    Iterator<Map.Entry<String, ArrayList<Object>>> productIterator2 = productList.entrySet().iterator();
                    while (productIterator2.hasNext()) {
                        Map.Entry<String, ArrayList<Object>> entry = productIterator2.next();
                        ArrayList<Object> product = entry.getValue();
					    String productId = (String) product.get(0);
                        String productName = (String) product.get(1);
					    String price = (String) product.get(2);
                        int quantity = (Integer) product.get(3);

                        out.println("<tr><td>" + productId + "</td><td>" + productName + "</td><td>" + quantity + "</td><td>" + NumberFormat.getCurrencyInstance().format(Double.parseDouble(price)) + "</td><td>" + NumberFormat.getCurrencyInstance().format(Double.valueOf(price) * quantity) + "</td></tr>");
                    }

				    out.println("</table>");
				    out.println("<p>Total Amount: " + NumberFormat.getCurrencyInstance().format(totalAmount) + "</p>");
				    out.println("<h2>Order completed. Will be shipped soon...</h2>");
				    out.println("<h2>Your order reference number is: " + orderId + "</h2>");
				    out.println("<h2>Shipping to Customer: " + custId + ", Name: " + first + " " + last + "</h2>");

                    // 5. Clear cart if the order is placed successfully
                    session.removeAttribute("productList");
                }
            }
            else {
                // Error message if customer id not in database
                out.println("<p>Error: Customer id does not exist</p>");
            } 
        } catch (SQLException e) {
            // Rollback the transaction in case of an error
            connection.rollback();
            throw e;
        } finally {
            // Reset auto-commit to true
            connection.setAutoCommit(true);
        }
    } catch (SQLException e) {
        // Handle exceptions
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } 
} else {
    // Error message if customer id or shopping cart is invalid
    out.println("<p>Error: Invalid customer id or no items in the shopping cart</p>");
}
%>
</BODY>
</HTML>
