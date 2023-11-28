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
<title>Administrator Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp"%>

<%

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
        //Write SQL query that prints out total order amount by day
        String sql = "SELECT orderDate AS orderDay, SUM(totalAmount) AS totalSales FROM ordersummary GROUP BY orderDate";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        ResultSet resultSet = preparedStatement.executeQuery();
        
        //Display the report header
        out.println("<h2>Total Sales Report</h2>");
        out.println("<table border=\"1\">");
        out.println("<tr><th>Order Day</th><th>Total Sales</th></tr>");
        
        //Display the results
        while (resultSet.next()) {
            String orderDay = resultSet.getString("orderDay");
            double totalSales = resultSet.getDouble("totalSales");

        
            out.println("<tr><td>" + orderDay + "</td>");
            out.println("<td>" + totalSales + "</td></tr>");
        }
        
        out.println("</table>");
        
    } 
    catch (SQLException e) {
        e.printStackTrace();
    } finally {
        closeConnection();
    }
        
} 
catch (Exception e) {
    e.printStackTrace();
}

%>

</body>
</html>
