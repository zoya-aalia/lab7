<!DOCTYPE html>
<html>
<%@ include file="header.jsp"%>
<style>
        h1 {color:#1baa82;}
        h2 {color:black;}
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

