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
	int rowPerPage = 8;
	int startIdx = (currentPage -1)*rowPerPage;
%>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/sakila", "root", "java1234");
	// 영화 정보와 출연한 배우들을 보여주는 쿼리
	String sql = "SELECT fa.film_id fid, f.title,f.description,c.name category,f.rental_rate price,f.length"
				+",f.rating,group_concat(CONCAT(first_name,' ',last_name) separator ', ') actor "
				+"FROM actor a "
				+"INNER JOIN film_actor fa ON fa.actor_id = a.actor_id "
				+"INNER JOIN film f ON f.film_id = fa.film_id "	
				+"INNER JOIN film_category fc ON fc.film_id =f.film_id "
				+"INNER JOIN category c ON fc.category_id = c.category_id "
				+"GROUP BY fid, category limit ?,?";
	// 쿼리 전체행의 개수
	String sql2 = "select count(*) from "
				+"(SELECT fa.film_id fid, f.title,f.description,c.name category,f.rental_rate price,f.length"
				+",f.rating,group_concat(CONCAT(first_name,' ',last_name) separator ', ') actor "
				+"FROM actor a "
				+"INNER JOIN film_actor fa ON fa.actor_id = a.actor_id "
				+"INNER JOIN film f ON f.film_id = fa.film_id "	
				+"INNER JOIN film_category fc ON fc.film_id =f.film_id "
				+"INNER JOIN category c ON fc.category_id = c.category_id "
				+"GROUP BY fid, category) t";
	PreparedStatement stmt = conn.prepareStatement(sql);
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt.setInt(1,startIdx);
	stmt.setInt(2,rowPerPage);
	
	ResultSet rs = stmt.executeQuery();
	ResultSet rs2 = stmt2.executeQuery();
	rs2.next();
	
	int lastPage = rs2.getInt("count(*)") / rowPerPage;
	if(rs2.getInt("count(*)") % rowPerPage != 0){
		lastPage++;
	}
	
	// 페이징 네비게이션 
	int startNav = ((currentPage-1)/10)*10+1;
	int endNav = startNav + 9;
	if(endNav>lastPage){
		endNav=lastPage;
	}
	
	ArrayList<HashMap<String,Object>> list = new ArrayList<>();
	while(rs.next()){
		HashMap<String,Object> map = new HashMap<>();
		map.put("fid",rs.getInt("fid"));
		map.put("title",rs.getString("title"));
		map.put("description",rs.getString("description"));
		map.put("category",rs.getString("category"));
		map.put("price", rs.getDouble("price"));
		map.put("length",rs.getInt("length"));
		map.put("rating",rs.getString("rating"));
		map.put("actor",rs.getString("actor"));
		
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
	width: 80%
	}
</style>
<meta charset="UTF-8">
<title></title>
</head>
<body>
	<h1>FilmInfo</h1>
	<a href="/sakila/index.jsp">[시작페이지로]</a>
	<table border="1">
		<tr>
			<th>FID</th>
			<th>TITLE</th>
			<th>DESCRIPTION</th>
			<th>CATEGORY</th>
			<th>PRICE</th>
			<th>LENGTH</th>
			<th>RATING</th>
			<th>ACTOR</th>
		</tr>
			<%
				for(HashMap<String,Object> map : list){
			%>
					<tr>
						<td><%=map.get("fid") %></td>
						<td><%=map.get("title") %></td>
						<td><%=map.get("description") %></td>
						<td><%=map.get("category") %></td>
						<td><%=map.get("price") %></td>
						<td><%=map.get("length") %></td>
						<td><%=map.get("rating") %></td>
						<td style="font-size:12px"><%=map.get("actor") %></td>
					</tr>
			<% 
				}
			%>
	</table>
	
	<%
		if(currentPage>1){
	%>
			<a href="/sakila/d0401/filmInfo.jsp?currentPage=1">[처음]</a>
	<%
		}if(startNav>10){
	%>
			<a href="/sakila/d0401/filmInfo.jsp?currentPage=<%=startNav-10%>">[이전]</a>
	<% 
		}for(int i=startNav;i<=endNav;i++){
	%>
			<a href="/sakila/d0401/filmInfo.jsp?currentPage=<%=i%>"><%=i%></a>
	<% 
		}if(endNav<lastPage){
	%>
			<a href="/sakila/d0401/filmInfo.jsp?currentPage=<%=startNav+10%>">[다음]</a>
	<% 
		}if(currentPage<lastPage){
	%>
			<a href="/sakila/d0401/filmInfo.jsp?currentPage=<%=lastPage%>">[마지막]</a>
	<%
		}
	%>
</body>
</html>