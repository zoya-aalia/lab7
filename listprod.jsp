<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
	<nav style="padding:1px">
		<h1>A & Z's Grocery</h1>
	</nav>
	<div style="background-image: linear-gradient(to left, #769d6d, #242b99); padding:10px; ">
			<a href="shop.html" style="margin-left:20px; color:antiquewhite">Home </a>
			<a href="listprod.jsp" style="margin-left:20px; color:antiquewhite">Products</a>
			<a href="listorder.jsp" style="margin-left:20px; color:antiquewhite">Orders</a>
			<a href="showcart.jsp" style="margin-left:20px; color:antiquewhite">My Cart</a>
	</div>
	<style>
			h1 {color:#1baa82;}
			h2 {color:black;}
			a {color:#769d6d}
	</style>
<head>
<title>A & Z's Grocery Product Search</title>
</head>
<body>

<h2>Search for the products you want to buy:</h2>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% 
// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!
// Get product name to search for
String name = String.valueOf(request.getParameter("productName"));
		
//Note: Forces loading of SQL Server driver

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

	if (name != "null") {
		String productQuery = "SELECT * FROM product WHERE productName LIKE ?";
		PreparedStatement productStatement = connection.prepareStatement(productQuery);
		productStatement.setString(1, "%" + name + "%");
		ResultSet productResultSet = productStatement.executeQuery();

		out.println("<h2>Product's Containing '" + name + "'</h2>");
		out.println("<table border=\"1\"><th> </th>");
		out.println("<th>Product Name</th>");
		out.println("<th>Price</th>");

		// 2. Print out the ResultSet
		while (productResultSet.next()) {
			int productId = productResultSet.getInt("productId");
			String productName = productResultSet.getString("productName");
			double productPrice = productResultSet.getDouble("productPrice");

			// 3. For each product create a link of the form
			// addcart.jsp?id=productId&name=productName&price=productPrice
			out.println("<p><a href='addcart.jsp?id=" + productId +
				"&name=" + URLEncoder.encode(productName, "UTF-8") +
				"&price=" + productPrice + "'>" + productName + "</a></p>");
		}

		// 4. Close connection
		productResultSet.close();
		productStatement.close();
		connection.close();
	}

	else {
		String productQuery = "SELECT * FROM product";
		PreparedStatement productStatement = connection.prepareStatement(productQuery);
		ResultSet productResultSet = productStatement.executeQuery();

		out.println("<h2>All Products</h2>");
		out.println("<table border=\"1\"><th> </th>");
		out.println("<th>Product Name</th>");
		out.println("<th>Price</th>");

		// 2. Print out the ResultSet
		while (productResultSet.next()) {
			int productId = productResultSet.getInt("productId");
			String productName = productResultSet.getString("productName");
			double productPrice = productResultSet.getDouble("productPrice");

			// 3. For each product create a link of the form
			// addcart.jsp?id=productId&name=productName&price=productPrice
			out.println("<tr><td><a href='addcart.jsp?id=" + productId +
				"&name=" + URLEncoder.encode(productName, "UTF-8") +
				"&price=" + productPrice + "'>Add to Cart</a></td><td>" +productName+ "</td><td>" + NumberFormat.getCurrencyInstance().format(productPrice) + "</td></tr>");
		}

		out.println("</table>");

		// 4. Close connection
		productResultSet.close();
		productStatement.close();
		connection.close();
	}
}

catch (SQLException ex) {
	System.err.println("SQLException: " + ex);
}

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0));	// Prints $5.00
%>

</body>
</html>
