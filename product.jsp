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
String sql = "";
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
        Product product = new Product();
        product.setProductId(resultSet.getInt("productId"));
        product.setProductName(resultSet.getString("productName"));
        product.setProductDesc(resultSet.getString("productDesc"));
        product.setProductPrice(resultSet.getDouble("productPrice"));
        product.setProductImageURL(resultSet.getString("productImageURL"));
        // Display product info
        out.println("<h1>" + product.getProductName() + "</h1>");
        out.println("<p>" + product.getProductDesc() + "</p>");
        out.println("<p>Price: " + NumberFormat.getCurrencyInstance().format(product.getProductPrice()) + "</p>");
        /* TODO: If there is a productImageURL, display using IMG tag */
        if (product.getProductImageURL() != null && !product.getProductImageURL().isEmpty()) {
            out.println("<img src='" + product.getProductImageURL() + "' alt='Product Image'>");
        } else {
            
            /* TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter. */
            byte[] image = DisplayImageDAO.getImageDataById(productId);
            if (image != null && image.length > 0){
                String base64Image = Base64.getEncoder().encodeToString(image); // making image in base64 to be embedded in html as data 
                out.println("<img src='data:image/png;base64, " + base64Image + "' alt='Product Image'>");  
            } else {
                out.println("<p>No image available, but we promise it's good!</p>");
            }
        }
        // TODO: Add links to Add to Cart and Continue Shopping
        out.println("<a href='addToCart.jsp?id=" + productId + "'>Add to Cart;)</a>");
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

