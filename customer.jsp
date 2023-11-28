<!DOCTYPE html>
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
<title>Customer Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%
	// Check if valid user name in database
	if (orderName != null) {
		// Initialize Variables
    	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    	String uid = "sa";
    	String pw = "304#sa#pw";

    	// Load driver class    
    	try {
        	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    	} 
		catch (java.lang.ClassNotFoundException e) {
        	System.err.println("ClassNotFoundException: " + e);
        	System.exit(1);
    	}

		try (Connection connection = DriverManager.getConnection(url, uid, pw); Statement stmt = connection.createStatement();) {
			try {
				//Check that username is in the database
				String checkUserQuery = "SELECT userid FROM customer WHERE userid = ?";
				PreparedStatement checkUserStatement = connection.prepareStatement(checkUserQuery);
    			checkUserStatement.setString(1, userName);
    			ResultSet checkUserResultSet = checkUserStatement.executeQuery();

				String uid = "";

    			while (checkUserResultSet.next()) {
        			uid = checkUserResultSet.getString("userid");
    			}
				
				if (!uid.isEmpty()) {
					// Print Customer information
					String getUserQuery = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalcode, country FROM customer WHERE userId = ?";
					PreparedStatement getUserStatement = connection.prepareStatement(getUserQuery);
    				getUserStatement.setString(1, userName);
    				ResultSet getUserResultSet = getUserStatement.executeQuery();

					while (checkUserResultSet.next()) {
        				String cid = checkUserResultSet.getString("customerId");
						String first = checkUserResultSet.getString("firstName");
						String last = checkUserResultSet.getString("lastName");
						String email = checkUserResultSet.getString("email");
						String phone = checkUserResultSet.getString("phonenum");
						String addy = checkUserResultSet.getString("address");
						String city = checkUserResultSet.getString("city");
						String state = checkUserResultSet.getString("state");
						String postcode = checkUserResultSet.getString("postalcode");
						String country = checkUserResultSet.getString("country");

						out.print("<h2>Customer Profile</h2>");
						out.print("<table border='1'></table><tr><td><th>Id</th></td><td>" + cid + "</td></tr>");
						out.print("<tr><td><th>First Name</th></td><td>" + first + "</td></tr>");
						out.print("<tr><td><th>Last Name</th></td><td>" + last + "</td></tr>");
						out.print("<tr><td><th>Email</th></td><td>" + email + "</td></tr>");
						out.print("<tr><td><th>Phone</th></td><td>" + phone + "</td></tr>");
						out.print("<tr><td><th>Address</th></td><td>" + addy + "</td></tr>");
						out.print("<tr><td><th>City</th></td><td>" + city + "</td></tr>");
						out.print("<tr><td><th>State</th></td><td>" + state + "</td></tr>");
						out.print("<tr><td><th>Postal Code</th></td><td>" + postcode + "</td></tr>");
						out.print("<tr><td><th>Country</th></td><td>" + country + "</td></tr>");
						out.print("<tr><td><th>User id</th></td><td>" + userName + "</td></tr></table>");
    				}

				}

			}

	// Make sure to close connection
		}
	}
%>

</body>
</html>

