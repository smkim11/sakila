<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	if(staffId == null){
		response.sendRedirect("/sakila/d0328/loginForm.jsp");
		return;
	}
%>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/sakila", "root", "java1234");
	// 영화 카테고리별 매출 쿼리
	String sql ="SELECT c.name category, SUM(p.amount) totalSales "
				+"FROM payment p INNER JOIN rental r ON p.rental_id = r.rental_id "
				+"INNER JOIN inventory i ON i.inventory_id = r.inventory_id "
				+"INNER JOIN film_category fc ON i.film_id = fc.film_id "
				+"INNER JOIN category c ON c.category_id = fc.category_id "
				+"GROUP BY category "
				+"ORDER BY totalSales DESC";
	// 가게별 매출 쿼리
	String sql2 = "SELECT CONCAT(c.city,',',cn.country) store, CONCAT(s.first_name,' ',s.last_name) manager, "
				+"SUM(p.amount) totalSales "
				+"FROM payment p "
				+"INNER JOIN rental r ON r.rental_id = p.rental_id "
				+"inner join staff s ON s.staff_id = p.staff_id "
				+"INNER JOIN store st ON s.store_id = st.store_id "
				+"INNER JOIN address a ON s.address_id = a.address_id "
				+"INNER JOIN city c ON c.city_id = a.city_id "
				+"INNER JOIN country cn ON c.country_id = cn.country_id "
				+"GROUP BY store,manager "
				+"ORDER BY totalSales DESC";
	
	PreparedStatement stmt = conn.prepareStatement(sql);
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	
	ResultSet rs = stmt.executeQuery();
	ResultSet rs2 = stmt2.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
<style>
	body{
	text-align:center
	}
	table{
	margin:auto;
	width:auto
	}
</style>
<meta charset="UTF-8">
<title></title>
</head>
<body>
	<h1>SalesList</h1>
	<a href="/sakila/index.jsp">[시작페이지로]</a>
		<h3>Sales By Film Category</h3>
			<table border="1">
				<tr>
					<th>category</th>
					<th>totalSales</th>
				</tr>
				<%
					while(rs.next()){
				%>
						<tr>
							<td><%=rs.getString("category") %></td>
							<td><%=rs.getDouble("totalSales") %></td>
						</tr>
				<% 
					}
				%>
			</table>
	
	
		<h3>Sales By Store</h3>
			<table border="1">
				<tr>
					<th>store</th>
					<th>manager</th>
					<th>totalSales</th>
				</tr>
					<%
						while(rs2.next()){
					%>
							<tr>
								<td><%=rs2.getString("store") %></td>
								<td><%=rs2.getString("manager") %></td>
								<td><%=rs2.getDouble("totalSales") %></td>
							</tr>
					<% 
						}
					%>
			</table>
	
</body>
</html>