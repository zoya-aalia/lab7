<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<%
if (session.getAttribute("authenticatedUser") != null) {
    %>
    <%@ include file="headerAcc.jsp"%>
    <%
}
else {
    %>
    <%@ include file="header.jsp"%>
    <%
}
%>
<style>
        h1 {color:#1baa82;}
        h2 {color:black;}
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

//Initialize Variables
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

//Load driver class
        
try {	
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}

catch (java.lang.ClassNotFoundException e) {
	System.err.println("ClassNotFoundException: " +e);
	System.exit(1);
}

//Connect to server

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

		//Print ResultSet
		while (productResultSet.next()) {
			int productId = productResultSet.getInt("productId");
			String productName = productResultSet.getString("productName");
			double productPrice = productResultSet.getDouble("productPrice");

			if (session.getAttribute("authenticatedUser") != null) {
				//Create links for each product
				out.println("<tr><td><a href='addcart.jsp?logged=True&id=" + productId +
					"&name=" + URLEncoder.encode(productName, "UTF-8") +
					"&price=" + productPrice + "' style='color:#769d6d'>Add to Cart</a></td><td><a href='product.jsp?logged=True&id=" + productId + "' style='color:#769d6d'>" + productName + "</a></td><td>" + NumberFormat.getCurrencyInstance().format(productPrice) + "</td></tr>");
			}
			else {
				//Create links for each product
				out.println("<tr><td><a href='addcart.jsp?id=" + productId +
					"&name=" + URLEncoder.encode(productName, "UTF-8") +
					"&price=" + productPrice + "' style='color:#769d6d'>Add to Cart</a></td><td><a href='product.jsp?id=" + productId + "' style='color:#769d6d'>" + productName + "</a></td><td>" + NumberFormat.getCurrencyInstance().format(productPrice) + "</td></tr>");
			}
		}

		//Close connection
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

		//Print out the ResultSet
		while (productResultSet.next()) {
			int productId = productResultSet.getInt("productId");
			String productName = productResultSet.getString("productName");
			double productPrice = productResultSet.getDouble("productPrice");

			if (session.getAttribute("authenticatedUser") != null) {
				//Create links for each product
				out.println("<tr><td><a href='addcart.jsp?logged=True&id=" + productId +
					"&name=" + URLEncoder.encode(productName, "UTF-8") +
					"&price=" + productPrice + "' style='color:#769d6d'>Add to Cart</a></td><td><a href='product.jsp?logged=True&id=" + productId + "' style='color:#769d6d'>" + productName + "</a></td><td>" + NumberFormat.getCurrencyInstance().format(productPrice) + "</td></tr>");
			}
			else {
				//Create links for each product
				out.println("<tr><td><a href='addcart.jsp?id=" + productId +
					"&name=" + URLEncoder.encode(productName, "UTF-8") +
					"&price=" + productPrice + "' style='color:#769d6d'>Add to Cart</a></td><td><a href='product.jsp?id=" + productId + "' style='color:#769d6d'>" + productName + "</a></td><td>" + NumberFormat.getCurrencyInstance().format(productPrice) + "</td></tr>");
			}
		}

		out.println("</table>");

		//Close connection
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
