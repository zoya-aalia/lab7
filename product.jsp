<%@ page import="java.util.Base64" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

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
<title>A & Z's Grocery - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%
// ** modify listprod to go to product detail page when click on product name
// Get product name to search for
// TODO: Retrieve and display info for the product
// String productId = request.getParameter("id");
// String sql = "";
/* TODO: Retrieve and display info for the product */
// TODO: If there is a productImageURL, display using IMG tag
		
// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
    // Retrieve product ID from URL parameter 
    String productId = request.getParameter("id");
    // Construct SQL query to retieve product information
    String sql = "SELECT * FROM product WHERE productId = ?";
try {
    getConnection();
    try (PreparedStatement preparedStatement = con.prepareStatement(sql)){
        preparedStatement.setString(1, productId);
        ResultSet resultSet = preparedStatement.executeQuery();

    if (resultSet.next()){
        // Retrieve product information from resultSet
        int productIdValue = resultSet.getInt("productId");
        String productName = resultSet.getString("productName");
        String productDesc = resultSet.getString("productDesc");
        double productPrice = resultSet.getDouble("productPrice");
        String productImageURL = resultSet.getString("productImageURL");

        
        // Display product info
        out.println("<h1>" + productName + "</h1>");
        out.println("<p>" + productDesc + "</p>");
        out.println("<p>Price: " + NumberFormat.getCurrencyInstance().format(productPrice) + "</p>");
        /* TODO: If there is a productImageURL, display using IMG tag */
        if (productImageURL != null && !productImageURL.isEmpty()) {
            out.println("<img src='" + productImageURL + "' alt='Product Image'>");
        } else {
            /* TODO: Retrieve any image stored directly in the database. Note: Call displayImage.jsp with product id as a parameter. */
            String sqlImage = "SELECT productImage FROM Product WHERE productId = ?";
                try (PreparedStatement imageStatement = con.prepareStatement(sqlImage)) {
                    imageStatement.setInt(1, productIdValue);
                    ResultSet imageResultSet = imageStatement.executeQuery();

                    if (imageResultSet.next()) {
                        // Convert image to Base64
                        byte[] imageData = imageResultSet.getBytes("productImage");
                        String base64Image = Base64.getEncoder().encodeToString(imageData);
                        String dataURL = "data:image/png;base64," + base64Image;
                        out.println("<img src='" + dataURL + "' alt='Product Image'>");
                    } else {
                        out.println("<p>No image available, but we promise it's good!</p>");
                    }
                }
            }

        // TODO: Add links to Add to Cart and Continue Shopping
        out.println("<a href='addToCart.jsp?id=" + productIdValue + "'>Add to Cart;)</a>");
        out.println("<a href='shopping.jsp'>Continue Shopping!</a>");
    } else {
        out.println("<p>Product not found :( sorry!</p>");
    }
    }
} catch (SQLException e) {
    e.printStackTrace();
} finally {
    closeConnection();
}
		
// TODO: Add links to Add to Cart and Continue Shopping
%>

</body>
