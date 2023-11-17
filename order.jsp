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
<title>YOUR NAME Grocery Order Processing</title>
</head>
<body>

<% 
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Determine if valid customer id was entered
// Determine if there are products in the shopping cart
// If either are not true, display an error message
if (custId != null && productList != null && !productList.isEmpty()) {
    Connection connection = null;
    PreparedStatement orderStmt = null;
    PreparedStatement productStmt = null;


try{
	// 1. Make connection
	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
	String uid = "testuser";
	String pw = "304testpw";
	connection = DriverManager.getConnection(url, uid, pw);

	// 2. Save order information to the database
	String orderInsertQuery = "INSERT INTO orderSummary (customerId, orderDate, totalAmount) VALUES (?, GETDATE(), ?)";
	orderStmt = connection.prepareStatement(orderInsertQuery, Statement.RETURN_GENERATED_KEYS);
	orderStmt.setInt(1, Integer.parseInt(custId));

	// Calculate total amount
	double totalAmount = calculateTotalAmount(productList);
	orderStmt.setDouble(2, totalAmount);

	int updatedRows = orderStmt.executeUpdate();

	if (updatedRows > 0) {
		// Order placed successfully, retrieve auto-generated order id
		ResultSet generatedKeys = orderStmt.getGeneratedKeys();
		if (generatedKeys.next()) {
			int orderId = generatedKeys.getInt(1);

			// 3. Insert each item into OrderProduct table using OrderId from the previous INSERT
			String productInsertQuery = "INSERT INTO orderProduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
			productStmt = connection.prepareStatement(productInsertQuery);

			// Iterate through products in the shopping cart
			Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
			while (iterator.hasNext()) {
				Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = entry.getValue();
				String productId = (String) product.get(0);
				int quantity = (Integer) product.get(2);
				String price = (String) product.get(3);

				// Insert product into OrderProduct table
				productStmt.setInt(1, orderId);
				productStmt.setInt(2, Integer.parseInt(productId));
				productStmt.setInt(3, quantity);
				productStmt.setDouble(4, Double.parseDouble(price));
				productStmt.executeUpdate();
			}

			// 4. Update total amount for the order record
			double totalAmountForOrder = calculateTotalAmount(productList);

			// Update the total amount in the orderSummary table
			String updateTotalAmountQuery = "UPDATE orderSummary SET totalAmount = ? WHERE orderId = ?";
			try (PreparedStatement updateTotalAmountStatement = connection.prepareStatement(updateTotalAmountQuery)) {
    			updateTotalAmountStatement.setDouble(1, totalAmountForOrder);
    			updateTotalAmountStatement.setInt(2, orderId); // Replace with your actual orderId
    			updateTotalAmountStatement.executeUpdate();
			}

			// 5. Print out order summary
			out.println("<h2>Order ID: " + orderId + "</h2>");
			out.println("<p>Total Amount: " + NumberFormat.getCurrencyInstance().format(totalAmount) + "</p>");
			out.println("<p>Products:</p>");

			iterator = productList.entrySet().iterator();
			while (iterator.hasNext()) {
				Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = entry.getValue();
				String productName = (String) product.get(1);
				int quantity = (Integer) product.get(2);
				String price = (String) product.get(3);

				out.println("<p>" + productName + " - Quantity: " + quantity + ", Price: " + NumberFormat.getCurrencyInstance().format(Double.parseDouble(price)) + "</p>");
			}

			// 6. Clear cart if the order is placed successfully
			session.removeAttribute("productList");
		}
	} else {
		// Handle where the order insertion failed
		out.println("<p>Error placing order</p>");
	}

} catch (ClassNotFoundException | SQLException e) {
	// Handle exceptions
	out.println("<p>Error: " + e.getMessage() + "</p>");
} finally {
	// close everything
	if (productStmt != null) {
		try {
			productStmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	if (orderStmt != null) {
		try {
			orderStmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	if (connection != null) {
		try {
			connection.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}

} else {
// error message if customer id or shopping cart is invalid
out.println("<p>Error: Invalid customer id or no items in the shopping cart</p>");
}
%>

</BODY>
</HTML>

