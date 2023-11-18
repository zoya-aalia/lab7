<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Ange & Zoya's Grocery Order List</title>
</head>
<body>

<h1>Order List</h1>

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

    while (orderResultSet.next()) {
        // a. print out the order summary information
        int orderId = orderResultSet.getInt("orderId");
        Date orderDate = orderResultSet.getDate("orderDate");
        double totalAmount = orderResultSet.getDouble("totalAmount");
        String shiptoAddress = orderResultSet.getString("shiptoAddress");
        String shiptoCity = orderResultSet.getString("shiptoCity");
        String shiptoState = orderResultSet.getString("shiptoState");
        String shiptoPostalCode = orderResultSet.getString("shiptoPostalCode");
        String shiptoCountry = orderResultSet.getString("shiptoCountry");
        int customerId = orderResultSet.getInt("customerId");

        String customerNameQuery = "SELECT firstName, lastName FROM customer WHERE customerId = ?";
        PreparedStatement customerStatement = connection.prepareStatement(customerNameQuery);
        customerStatement.setInt(1, customerId);
        ResultSet customerResultSet = customerStatement.executeQuery();

        if (customerResultSet.next()) {
            String firstName = customerResultSet.getString("firstName");
            String lastName = customerResultSet.getString("lastName");

            out.println("<h2>Order ID: " + orderId + "</h2>");
            out.println("<p>Order Date: " + orderDate + "</p>");
            out.println("<p>Total Amount: " + NumberFormat.getCurrencyInstance().format(totalAmount) + "</p>");
            out.println("<p>Customer: " + firstName + " " + lastName + "</p>");
            out.println("<p>Ship to Address: " + shiptoAddress + ", " + shiptoCity + ", " + shiptoState + ", " + shiptoPostalCode + ", " + shiptoCountry + "</p>");

            // b. write a query to retrieve the products in the order use a PreparedStatement as will repeat this query many times
            String productQuery = "SELECT * FROM orderproduct WHERE orderId = ?";
            PreparedStatement productStatement = connection.prepareStatement(productQuery);
            productStatement.setInt(1, orderId);
            ResultSet productResultSet = productStatement.executeQuery();

            // c. for each product in the order write out product information
            while (productResultSet.next()) {
                // Write out product information
                int productId = productResultSet.getInt("productId");
                int quantity = productResultSet.getInt("quantity");
                double price = productResultSet.getDouble("price");

                out.println("<p>Product ID: " + productId + ", Quantity: " + quantity + ", Price: " + NumberFormat.getCurrencyInstance().format(price) + "</p>");
            }

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

</body>
</html>
