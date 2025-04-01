<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	
	// 로그인 되었는지 안되었는지 확인
	if(staffId == null){ // 로그아웃 상태라면
		response.sendRedirect("/sakila/d0328/loginForm.jsp");
		return;
	}

	String searchTitle = request.getParameter("searchTitle");
	if(request.getParameter("searchTitle") == null){
		searchTitle = "";
	}
	System.out.println("title: "+searchTitle);
	
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.valueOf(request.getParameter("currentPage"));
	}
	int rowPerPage = 15;
	int startIdx = (currentPage -1) * rowPerPage;
%>
<%
	//mysql 로딩
	Class.forName("com.mysql.cj.jdbc.Driver");
	// 연결
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/sakila", "root", "java1234");
	PreparedStatement stmt = null;
	PreparedStatement stmt2 = null; 
	
	String sql ="SELECT i.inventory_id inventoryId, f.title, ifnull(t.return_date, '대여하기') returnDate,i.store_id storeId, a.address "
				+"from inventory i INNER JOIN film f ON f.film_id = i.film_id "   
				+"left JOIN (SELECT inventory_id, customer_id, CASE WHEN return_date IS NULL THEN '반납하기' "
				+"ELSE '대여하기' END return_date FROM rental WHERE (inventory_id, rental_date) "
				+"IN (SELECT inventory_id,MAX(rental_date) rental_date FROM rental "
				+"GROUP BY inventory_id)) t ON i.inventory_id = t.inventory_id "
				+"INNER JOIN store st ON i.store_id = st.store_id "
				+"INNER JOIN address a ON a.address_id = st.address_id ";
	
	String sql2 = "select count(*) from inventory i INNER JOIN film f ON f.film_id = i.film_id "
				+"left JOIN (SELECT inventory_id, customer_id, CASE WHEN return_date IS NULL THEN '대여불가' "
				+"ELSE '대여가능' END return_date FROM rental WHERE (inventory_id, rental_date) "
				+"IN (SELECT inventory_id,MAX(rental_date) rental_date FROM rental "
				+"GROUP BY inventory_id)) t ON i.inventory_id = t.inventory_id "
				+"INNER JOIN store st ON i.store_id = st.store_id "
				+"INNER JOIN address a ON a.address_id = st.address_id";
	if(searchTitle.equals("")){ // 검색어 입력하지 않았을 때
		sql += "ORDER BY inventoryId asc limit ?,?";
		stmt = conn.prepareStatement(sql);
		stmt2 = conn.prepareStatement(sql2);
		stmt.setInt(1,startIdx);
		stmt.setInt(2,rowPerPage);
	}
	else{ // 검색어 입력했을 때
		sql += " where title like ? ORDER BY inventoryId asc limit ?,?";
		sql2 += " where title like ?";
		stmt = conn.prepareStatement(sql);
		stmt2 = conn.prepareStatement(sql2);
		stmt.setString(1,"%"+searchTitle+"%");
		stmt.setInt(2,startIdx);
		stmt.setInt(3,rowPerPage);
		stmt2.setString(1,"%"+searchTitle+"%");
	}
	
	ResultSet rs = stmt.executeQuery();
	ResultSet rs2 = stmt2.executeQuery();
	rs2.next();
	
	int totalIdx = rs2.getInt("count(*)");
	int lastPage = totalIdx / rowPerPage;
	if(totalIdx % rowPerPage != 0){
		lastPage++;
	}
	
	int pageGroup = (currentPage-1) / 10;
	int startPage = pageGroup * 10 + 1;
	int endPage = startPage + 9;
	if(endPage>lastPage){
		endPage=lastPage;
	}
	
	ArrayList<HashMap<String,Object>> list = new ArrayList<>();
	while(rs.next()){
		HashMap<String,Object> map = new HashMap<>();
	 	map.put("inventoryId",rs.getInt("inventoryId"));
	 	map.put("title",rs.getString("title"));
	 	map.put("returnDate",rs.getString("returnDate"));
	 	map.put("storeId",rs.getInt("storeId"));
		map.put("address",rs.getString("address"));
	 	list.add(map);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body style="text-align:center">
	<h1>Inventory List</h1>
	<a href="/sakila/index.jsp">[시작페이지로]</a>
	<table border="1" style="margin:auto; width:70%">
		<tr>
			<th>ID</th>
			<th>TITLE</th>
			<th>STOREID</th>
			<th>ADDRESS</th>
			<th>RETURN DATE</th>
		</tr>
		<% 
			for(HashMap<String,Object> map : list){
		%>
				<tr>
					<td><%=map.get("inventoryId") %></td>
					<td><%=map.get("title") %></td>
					<td><%=map.get("storeId") %>지점</td>
					<td><%=map.get("address") %></td>
					<td>
					<%
							if(!map.get("returnDate").equals("반납하기")){ // 대여가능하면 표시
					%>
								<a href="/sakila/d0331/insertRentalForm.jsp?inventoryId=<%=map.get("inventoryId") %>"><%=map.get("returnDate") %></a>
					<%
							}else{
					%>
								<a href="/sakila/d0401/returnRentalAction.jsp?inventoryId=<%=map.get("inventoryId") %>&searchTitle=<%=searchTitle %>&currentPage=<%=currentPage %>"><%=map.get("returnDate") %>
					<%
							}
					%>
					</td>
				</tr>
		<% 
			}
		%>
		
		
	</table>
	<form action="/sakila/d0327/inventoryList.jsp" method="post">
		<input type="text" name="searchTitle">
		<button type="submit">검색</button>
	</form>
	<%
		if(currentPage>1){
	%>
			<a href="/sakila/d0327/inventoryList.jsp?searchTitle=<%=searchTitle %>&currentPage=1">[처음]</a>
	<% 
		}
	%>
	<%
		if(startPage>10){
	%>
			<a href="/sakila/d0327/inventoryList.jsp?searchTitle=<%=searchTitle %>&currentPage=<%=startPage-10 %>">[이전]</a>
	<% 
		}
	%>
	<%
		for(int i=startPage;i<=endPage;i++){
	%>
			<a href="/sakila/d0327/inventoryList.jsp?searchTitle=<%=searchTitle %>&currentPage=<%=i%>">[<%=i%>]</a>
	<% 
		}
	%>
	<%
		if(endPage<lastPage){
	%>
			<a href="/sakila/d0327/inventoryList.jsp?searchTitle=<%=searchTitle %>&currentPage=<%=startPage+10 %>">[다음]</a>
	<% 
		}
	%>
	<%
		if(currentPage<lastPage){
	%>
			<a href="/sakila/d0327/inventoryList.jsp?searchTitle=<%=searchTitle %>&currentPage=<%=lastPage %>">[마지막]</a>
	<% 
		}
	%>
</body>
</html>