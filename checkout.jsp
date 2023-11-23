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
<title>A & Z's Grocery CheckOut Line</title>
</head>
<body>

<h1>Please enter your customer id and password to complete the transaction:</h1>

<form method="get" action="order.jsp">
    <table>
        <tbody>
            <tr>
                <td>Customer ID: </td>
                <td><input type="text" name="customerId" size="50"></td>
            </tr>
            <tr>
                <td>Password: </td>
                <td><input type="text" name="password" size="50"></td>
            </tr>
        </tbody>
    </table>
    <input type="submit" value="Submit"><input type="reset" value="Reset">
</form>

</body>
</html>

