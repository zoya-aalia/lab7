<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery</title>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

<% // Get product name to search for
String name = request.getParameter("productName");
		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

	// 1. make connection 
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "testuser";
    String pw = "304testpw";
    Connection connection = DriverManager.getConnection(url, uid, pw);

	// a. query to retrieve all products
	String productQuery = "SELECT * FROM products WHERE productName LIKE ?";
	PreparedStatement productStatement = connection.prepareStatement(productQuery);
	productStatement.setString(1, "%" + name + "%");

	// b. for each order in ResultSet
	ResultSet productResultSet = productStatement.executeQuery();

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
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00
%>

</body>
</html>
