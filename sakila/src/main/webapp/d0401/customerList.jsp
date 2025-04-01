<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	if(staffId == null){
		response.sendRedirect("/sakila/d0328/loginForm.jsp");
		return;
	}
	
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.valueOf(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	int startIdx = (currentPage - 1)*rowPerPage;
%>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/sakila", "root", "java1234");
	String sql = "SELECT t.* FROM "
				+"(SELECT c.customer_id id, CONCAT(c.first_name,' ',c.last_name) name"
				+", a.address, a.postal_code zipCode, a.phone, ct.city, cn.country, "
				+"case when c.active = 1 then 'active' ELSE ' ' END notes, c.store_id sid "
				+"FROM customer c INNER JOIN address a ON c.address_id = a.address_id "
				+"INNER JOIN city ct ON ct.city_id = a.city_id "
				+"INNER JOIN country cn ON cn.country_id = ct.country_id) t ORDER BY t.ID limit ?,?";
	String sql2 = "select count(*) from "
				+"(SELECT c.customer_id id, CONCAT(c.first_name,' ',c.last_name) name"
				+", a.address, a.postal_code zipCode, a.phone, ct.city, cn.country, "
				+"case when c.active = 1 then 'active' ELSE ' ' END notes, c.store_id sid "
				+"FROM customer c INNER JOIN address a ON c.address_id = a.address_id "
				+"INNER JOIN city ct ON ct.city_id = a.city_id "
				+"INNER JOIN country cn ON cn.country_id = ct.country_id) t";
	PreparedStatement stmt = conn.prepareStatement(sql);
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt.setInt(1,startIdx);
	stmt.setInt(2,rowPerPage);
	
	ResultSet rs = stmt.executeQuery();
	ResultSet rs2 = stmt2.executeQuery();
	rs2.next();
	
	int totalIdx = rs2.getInt("count(*)");
	int lastPage = totalIdx / rowPerPage;
	if(totalIdx % rowPerPage != 0){
		lastPage++;
	}
	
	int startPage = ((currentPage -1)/10) * 10 + 1;
	int endPage = startPage + 9;
	if(endPage>lastPage){
		endPage=lastPage;
	}
	
	ArrayList<HashMap<String,Object>> list = new ArrayList<>();
	while(rs.next()){
		HashMap<String,Object> map = new HashMap<>();
		map.put("id",rs.getInt("id"));
		map.put("name",rs.getString("name"));
		map.put("address",rs.getString("address"));
		map.put("zipCode",rs.getInt("zipCode"));
		map.put("phone",rs.getString("phone"));
		map.put("city",rs.getString("city"));
		map.put("country",rs.getString("country"));
		map.put("notes",rs.getString("notes"));
		map.put("sid",rs.getInt("sid"));
		
		list.add(map);
	}
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
	width:80%
	}
</style>
<meta charset="UTF-8">
<title></title>
</head>
<body>
	<h1>Customer List</h1>
	<table border="1">
		<tr>
			<th>ID</th>
			<th>NAME</th>
			<th>ADDRESS</th>
			<th>ZIP CODE</th>
			<th>PHONE</th>
			<th>CITY</th>
			<th>COUNTRY</th>
			<th>NOTES</th>
			<th>SID</th>
		</tr>
		<%
			for(HashMap<String,Object> map : list){
		%>
				<tr>
					<td><%=map.get("id") %></td>
					<td><%=map.get("name") %></td>
					<td><%=map.get("address") %></td>
					<td><%=map.get("zipCode") %></td>
					<td><%=map.get("phone") %></td>
					<td><%=map.get("city") %></td>
					<td><%=map.get("country") %></td>
					<td><%=map.get("notes") %></td>
					<td><%=map.get("sid") %></td>
				</tr>
		<% 
			}
		%>
	</table>
	<%
		if(currentPage >1){
	%>
			<a href="/sakila/d0401/customerList.jsp?currentPage=1">[처음]</a>
	<% 
		}if(startPage>10){
	%>
			<a href="/sakila/d0401/customerList.jsp?currentPage=<%=startPage-10%>">[이전]</a>
	<% 
		}for(int i=startPage;i<=endPage;i++){
	%>
			<a href="/sakila/d0401/customerList.jsp?currentPage=<%=i%>"><%=i%></a>
	<% 
		}if(endPage<lastPage){
	%>
			<a href="/sakila/d0401/customerList.jsp?currentPage=<%=startPage+10%>">[다음]</a>
	<% 
		}if(currentPage<lastPage){
	%>
			<a href="/sakila/d0401/customerList.jsp?currentPage=<%=lastPage%>">[마지막]</a>
	<% 
		}
	%>
</body>
</html>