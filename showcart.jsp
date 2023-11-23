<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
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
<title>A & Z's Shopping Cart</title>
</head>
<body>

<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null)
{	out.println("<h2>Your shopping cart is empty!</h2>");
	productList = new HashMap<String, ArrayList<Object>>();
}
else
{
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	out.println("<h2>Your Shopping Cart</h2>");
	out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
	out.println("<th>Price</th><th>Subtotal</th></tr>");

	double total =0;
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext()) 
	{	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		if (product.size() < 4)
		{
			out.println("Expected product with four entries. Got: "+product);
			continue;
		}
		
		out.print("<tr><td>"+product.get(0)+"</td>");
		out.print("<td>"+product.get(1)+"</td>");

		Object price = product.get(2);
		Object itemqty = product.get(3);
		double pr = 0;
		int qty = 0;
		
		try {
			pr = Double.parseDouble(price.toString());
		}
		catch (Exception e) {
			out.println("Invalid price for product: "+product.get(0)+" price: "+price);
		}
		try {
			qty = Integer.parseInt(itemqty.toString());
		}
		catch (Exception e) {
			out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
		}	

		out.print("<td><input type='text' name='newqty1' size='3' value='" + qty + "'></td>");
		out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
		out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td>");
		out.print("<td><a href='showcart.jsp?delete=" + product.get(0) + "' style='color:#769d6d'>Remove Item from Cart</a></td>");
		out.print("<td><input type='BUTTON' onclick='update(1, document.form1.newqty1.value)' value='Update Quantity'></td></tr>");
		total = total +pr*qty;
	}
	out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
			+"<td align=\"right\">"+currFormat.format(total)+"</td></tr>");
	out.println("</table>");

	out.println("<h2><a href='checkout.jsp' style='color:#769d6d'>Check Out</a></h2>");

	String deleteProductId = request.getParameter("delete");
   	if (deleteProductId != null) {
       	productList.remove(deleteProductId);
       	session.setAttribute("productList", productList);
       	response.sendRedirect("showcart.jsp");  // Redirect to refresh the page
   	}
}
%>
<h2><a href="listprod.jsp" style="color:#769d6d">Continue Shopping</a></h2>
</body>
</html> 