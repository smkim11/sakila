<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	if(staffId == null){
		response.sendRedirect("/sakila/d0328/loginForm.jsp");
		return;
	}
	/*
		rental_id 자동
		rental_date now()
		inventory_id  request o
		customer_id	직접입력
		return_date	null
		staff_id  session o
	*/
	Integer inventoryId = Integer.valueOf(request.getParameter("inventoryId"));
	Integer customerId = null;
	if(request.getParameter("customerId") != null){ // 이름 검색 후 페이지 다시 요청하면 customerId를 받아온다
		customerId = Integer.valueOf(request.getParameter("customerId"));
	}
	
%>
<%
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/sakila", "root", "java1234");
	String sql = "select i.inventory_id inventoryId, i.film_id filmId, i.store_id storeId, f.title "
				+"from inventory i inner join film f on i.film_id = f.film_id where inventory_id=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1,inventoryId);
	System.out.println(stmt);
	ResultSet rs = stmt.executeQuery();
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body style="text-align:center">
	<h1>InsertRental</h1>
	
		<%
			if(rs.next()){ 
		%>
			<form action="/sakila/d0331/searchCustomidList.jsp" method="post"> <!-- customerListByName.jsp -> insertRentalForm.jsp -->
				<input type="hidden" name ="inventoryId" value="<%=inventoryId %>">
				<input type="text" name="searchName">
				<button type="submit">이름으로 customerId 검색</button>
			</form>
			
			<form action="/sakila/d0331/insertRentalAction.jsp" method="post">
				<table border="1" style="margin:auto; width:auto">
					<tr>
						<th>customerId</th>
						<td><input type = "text" name ="customerId" value="<%=customerId %>" readonly></td>
					</tr>
					<tr>
						<th>inventoryId</th>
						<td><input type = "text" name ="inventoryId" value="<%=inventoryId %>" readonly></td>
					</tr>
					<tr>
						<th>filmId</th>
						<td><input type = "text" name ="filmId" value="<%=rs.getInt("filmId") %>" readonly></td>
					</tr>
					<tr>
						<th>title</th>
						<td><input type = "text" name ="title" value="<%=rs.getString("title") %>" readonly></td>
					</tr>
					<tr>
						<th>storeId</th>
						<td><input type = "text" name ="storeId" value="<%=rs.getInt("storeId") %>" readonly></td>
					</tr>
					<tr>
						<th>staffId</th>
						<td><input type = "text" name ="staffId" value="<%=staffId %>" readonly></td>
					</tr>
					
				</table>
					<button type="submit">대여</button>
				</form>
		<% 
			}
		%>
		
	
</body>
</html>