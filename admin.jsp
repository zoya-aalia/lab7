<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>

<%
// TODO: Include files auth.jsp and jdbc.jsp
<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp" %>
%>

<%

// TODO: Write SQL query that prints out total order amount by day
String sql = "SELECT DATE(orderDate) AS orderDay, SUM(orderAmount) AS totalSales " +
             "FROM orders " +
             "GROUP BY DATE(orderDate)";

            try {
                getConnection();
        
                try (PreparedStatement preparedStatement = con.prepareStatement(sql)) {
                    ResultSet resultSet = preparedStatement.executeQuery();
        
                    // Display the report header
                    out.println("<h2>Total Sales Report</h2>");
                    out.println("<table border=\"1\">");
                    out.println("<th>Order Day</th>");
                    out.println("<th>Total Sales</th>");
        
                    // Display the results
                    while (resultSet.next()) {
                        String orderDay = resultSet.getString("orderDay");
                        double totalSales = resultSet.getDouble("totalSales");
        
                        out.println("<tr>");
                        out.println("<td>" + orderDay + "</td>");
                        out.println("<td>" + totalSales + "</td>");
                        out.println("</tr>");
                    }
        
                    out.println("</table>");
        
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    closeConnection();
                }
        
            } catch (Exception e) {
                e.printStackTrace();
            }

%>

</body>
</html>

/* +1 mark - for checking user is logged in before accessing page
+2 marks - for displaying a report that list the total sales for each day. Hint: May need to use date functions like year, month, day.
+1 mark - for displaying current user on main page (index.jsp/php)
+2 marks - for modifying validateLogin to check correct user id and password */