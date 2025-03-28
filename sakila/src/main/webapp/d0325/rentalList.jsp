<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%	
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	
	// 로그인 되었는지 안되었는지 확인
	if(staffId == null){ // 로그아웃 상태라면
		response.sendRedirect("/sakila/loginForm.jsp");
		return;
	}
	
	String storeId = request.getParameter("storeId");
	if(request.getParameter("storeId")==null){
		storeId = "0";
	}
	// System.out.println("Id: "+storeId);
	
	String searchWord = request.getParameter("searchWord");
	if(request.getParameter("searchWord")==null){
		searchWord = "";
	}
	// System.out.println("Word: "+searchWord);
	
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage=Integer.valueOf(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	int startIdx = (currentPage-1)*10;
	
	
%>
<%
	//mysql 로딩
	Class.forName("com.mysql.cj.jdbc.Driver");
	// 연결
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/sakila", "root", "java1234");
	PreparedStatement stmt = null;
	PreparedStatement stmt2 = null;
	String sql = "SELECT r.rental_id rentalId, s.store_id storeId,concat(c.first_name,' ',c.last_name) name"
				 +",c.customer_id customerId, CONCAT_WS('-',YEAR(r.rental_date), MONTH(r.rental_date), DAy(r.rental_date)) rentalDate, "
		 		 +"ifnull(CONCAT_WS('-',YEAR(r.return_date), MONTH(r.return_date), DAy(r.return_date)),'-') returnDate"
				 +", r.inventory_id inventoryId, f.title "+"FROM rental r "
				 +"INNER JOIN staff s ON r.staff_id = s.staff_id "+"INNER JOIN customer c ON c.customer_id = r.customer_id "
				 +"INNER JOIN inventory i ON r.inventory_id = i.inventory_id "+"INNER JOIN film f ON i.film_id = f.film_id "
				 +"order by rentalId "+"limit ?,?";
	String sql2 = "select count(*) from rental r "+"INNER JOIN staff s ON r.staff_id = s.staff_id "
				 +"INNER JOIN customer c ON c.customer_id = r.customer_id "+"INNER JOIN inventory i ON r.inventory_id = i.inventory_id "
				 +"INNER JOIN film f ON i.film_id = f.film_id ";
	
	if(storeId.equals("0")&& searchWord.equals("")){ // 아무것도 입력하지 않았을 때
		stmt = conn.prepareStatement(sql);
		stmt2 = conn.prepareStatement(sql2);
		stmt.setInt(1,startIdx);
		stmt.setInt(2,rowPerPage);
	}
	else if(searchWord.equals("")){ // 지점만 입력했을 때
		sql = "SELECT r.rental_id rentalId, s.store_id storeId,concat(c.first_name,' ',c.last_name) name"
			 +",c.customer_id customerId, CONCAT_WS('-',YEAR(r.rental_date), MONTH(r.rental_date), DAy(r.rental_date)) rentalDate, "
			 +"ifnull(CONCAT_WS('-',YEAR(r.return_date), MONTH(r.return_date), DAy(r.return_date)),'-') returnDate"
			 +", r.inventory_id inventoryId, f.title "+"FROM rental r "
			 +"INNER JOIN staff s ON r.staff_id = s.staff_id "+"INNER JOIN customer c ON c.customer_id = r.customer_id "
			 +"INNER JOIN inventory i ON r.inventory_id = i.inventory_id "+"INNER JOIN film f ON i.film_id = f.film_id "
			 +"where s.store_id=? "+"order by rentalId "+"limit ?,?";
		sql2 = "select count(*) from rental r "+"INNER JOIN staff s ON r.staff_id = s.staff_id "
			 +"INNER JOIN customer c ON c.customer_id = r.customer_id "+"INNER JOIN inventory i ON r.inventory_id = i.inventory_id "
			 +"INNER JOIN film f ON i.film_id = f.film_id "+"where s.store_id=?";
		stmt = conn.prepareStatement(sql);
		stmt2 = conn.prepareStatement(sql2);
		stmt.setInt(1,Integer.valueOf(storeId));
		stmt.setInt(2,startIdx);
		stmt.setInt(3,rowPerPage);
		stmt2.setInt(1,Integer.valueOf(storeId));
	}
	else if(storeId.equals("0")){ // 제목만 입력했을 때
		sql = "SELECT r.rental_id rentalId, s.store_id storeId,concat(c.first_name,' ',c.last_name) name"
			 +",c.customer_id customerId, CONCAT_WS('-',YEAR(r.rental_date), MONTH(r.rental_date), DAy(r.rental_date)) rentalDate, "
			 +"ifnull(CONCAT_WS('-',YEAR(r.return_date), MONTH(r.return_date), DAy(r.return_date)),'-') returnDate"
			 +", r.inventory_id inventoryId, f.title "+"FROM rental r "
			 +"INNER JOIN staff s ON r.staff_id = s.staff_id "+"INNER JOIN customer c ON c.customer_id = r.customer_id "
			 +"INNER JOIN inventory i ON r.inventory_id = i.inventory_id "+"INNER JOIN film f ON i.film_id = f.film_id "
			 +"where f.title like ? "+"order by rentalId "+"limit ?,?";
		sql2 = "select count(*) from rental r "+"INNER JOIN staff s ON r.staff_id = s.staff_id "
			 +"INNER JOIN customer c ON c.customer_id = r.customer_id "+"INNER JOIN inventory i ON r.inventory_id = i.inventory_id "
			 +"INNER JOIN film f ON i.film_id = f.film_id "+"where f.title like ?";
		stmt = conn.prepareStatement(sql);
		stmt2 = conn.prepareStatement(sql2);
		stmt.setString(1,"%"+searchWord+"%");
		stmt.setInt(2,startIdx);
		stmt.setInt(3,rowPerPage);
		stmt2.setString(1,"%"+searchWord+"%");
	}
	else{ // 둘 다 입력했을 때
		sql = "SELECT r.rental_id rentalId, s.store_id storeId,concat(c.first_name,' ',c.last_name) name"
			 +",c.customer_id customerId, CONCAT_WS('-',YEAR(r.rental_date), MONTH(r.rental_date), DAy(r.rental_date)) rentalDate, "
			 +"ifnull(CONCAT_WS('-',YEAR(r.return_date), MONTH(r.return_date), DAy(r.return_date)),'-') returnDate"
			 +", r.inventory_id inventoryId, f.title "+"FROM rental r "
			 +"INNER JOIN staff s ON r.staff_id = s.staff_id "+"INNER JOIN customer c ON c.customer_id = r.customer_id "
			 +"INNER JOIN inventory i ON r.inventory_id = i.inventory_id "+"INNER JOIN film f ON i.film_id = f.film_id "
			 +"where s.store_id=? and f.title like ? "+"order by rentalId "+"limit ?,?";
		sql2 = "select count(*) from rental r "+"INNER JOIN staff s ON r.staff_id = s.staff_id "
			 +"INNER JOIN customer c ON c.customer_id = r.customer_id "+"INNER JOIN inventory i ON r.inventory_id = i.inventory_id "
			 +"INNER JOIN film f ON i.film_id = f.film_id "+"where s.store_id=? and f.title like ?";
		stmt = conn.prepareStatement(sql);
		stmt2 = conn.prepareStatement(sql2);
		stmt.setInt(1,Integer.valueOf(storeId));
		stmt.setString(2,"%"+searchWord+"%");
		stmt.setInt(3,startIdx);
		stmt.setInt(4,rowPerPage);
		stmt2.setInt(1,Integer.valueOf(storeId));
		stmt2.setString(2,"%"+searchWord+"%");
	}
	
	ResultSet rs = stmt.executeQuery();
	ResultSet rs2 = stmt2.executeQuery();
	rs2.next();
	
	int totalIdx = rs2.getInt("count(*)");
	int lastPage = totalIdx / rowPerPage;
	if(totalIdx % rowPerPage != 0){
		lastPage++;
	}
	
	// 10단위로 페이징
	int pageGroup = (currentPage - 1) / 10; // currentPage가 1~10 이면 0 , 11~20이면 1...
    int startPage = pageGroup * 10 + 1; 	// currentPage가 1~10 이면 1 , 11~20이면 11...
    int endPage = startPage + 9;			// 10단위로 보여야하므로 startPage가 1이면 10, 11이면 20...
    if(endPage>lastPage){					// 마지막페이지보다 커지면 endPage = 마지막 페이지가 된다
    	endPage = lastPage;
    }
	
	ArrayList<HashMap<String,Object>> list = new ArrayList<>();
	while(rs.next()){
		HashMap<String,Object> map = new HashMap<>();
		map.put("rentalId",rs.getInt("rentalId"));
		map.put("storeId",rs.getInt("storeId"));
		map.put("name",rs.getString("name"));
		map.put("customerId",rs.getInt("customerId"));
		map.put("rentalDate",rs.getString("rentalDate"));
		map.put("returnDate",rs.getString("returnDate"));
		map.put("inventoryId",rs.getInt("inventoryId"));
		map.put("title",rs.getString("title"));
		
		list.add(map);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body style="text-align: center">
	<h1>Rental List</h1>
	<table border="1" style="margin:auto ; width:70%" >
		<tr>
			<th>rentalId</th>
			<th>title</th>
			<th>inventoryId</th>
			<th>name(customerId)</th><!-- name = first_name + last_name -->
			<th>rentalDate</th>
			<th>returnDate</th>
		</tr>
			<%
				for(HashMap<String,Object> map : list){
			%>
					<tr>
						<td><%=map.get("rentalId") %></td>
						<td><%=map.get("title") %></td>
						<td><%=map.get("inventoryId") %></td>
						<td><%=map.get("name") %>(<%=map.get("customerId") %>)</td>
						<td><%=map.get("rentalDate") %></td>
						<td><%=map.get("returnDate") %></td>
					</tr>
			<% 
				}
			%>
			
			
	</table>
	<form action = "/sakila/d0325/rentalList.jsp">
		지점 : 
		<select name ="storeId">
			<option value="0">전체</option>
			<option value="1">1지점</option>
			<option value="2">2지점</option>
		</select>
		영화제목 : 
		<input type="text" name="searchWord">
		<button type="submit">검색</button>
	</form>
	<div><%=currentPage %>/<%=lastPage %></div>
	<%
		if(currentPage>1){
	%>
			<a href="/sakila/d0325/rentalList.jsp?currentPage=1&storeId=<%=storeId%>&searchWord=<%=searchWord%>">[처음]</a>	
	<% 
		}
	%>
	<%
		if(startPage>10){
	%>
			<a href="/sakila/d0325/rentalList.jsp?currentPage=<%=startPage-10 %>&storeId=<%=storeId%>&searchWord=<%=searchWord%>">[이전]</a>
	<%
		}
	%>
	<%
		for(int i =startPage;i<=endPage;i++){
	%>
			<a href="/sakila/d0325/rentalList.jsp?currentPage=<%=i %>&storeId=<%=storeId%>&searchWord=<%=searchWord%>">[<%=i %>]</a>
	<% 
		}
	%>
	<%
		if(endPage<lastPage){
	%>
			<a href="/sakila/d0325/rentalList.jsp?currentPage=<%=startPage+10 %>&storeId=<%=storeId%>&searchWord=<%=searchWord%>">[다음]</a>
	<%
		}
	%>
	<%
		if(currentPage<lastPage){
	%>
			<a href="/sakila/d0325/rentalList.jsp?currentPage=<%=lastPage%>&storeId=<%=storeId%>&searchWord=<%=searchWord%>">[마지막]</a>
	<% 
		}
	%>
</body>
</html>