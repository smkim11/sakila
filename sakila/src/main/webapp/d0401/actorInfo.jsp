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
	int rowPerPage = 5;
	int startIdx = (currentPage - 1) * rowPerPage;
%>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/sakila", "root", "java1234");
	// 배우마다 참여한 작품을 카테고리별로 분류하여 보여주는 쿼리
	String sql = "SELECT a.actor_id actorId, CONCAT(a.first_name,' ',a.last_name) name,"
				+"GROUP_CONCAT(distinct concat(c.name,':',(select GROUP_CONCAT(title order BY title ASC separator ', ') "
				+"FROM film f INNER JOIN film_category fc ON f.film_id = fc.film_id "
				+"INNER JOIN film_actor fa ON fc.film_id = fa.film_id "
				+"WHERE fc.category_id = c.category_id AND fa.actor_id = a.actor_id)) "
				+"ORDER BY c.name SEPARATOR '---') info "
				+"FROM actor a "
				+"inner join film_actor fa ON a.actor_id = fa.actor_id "
				+"INNER JOIN film_category fc ON fa.film_id = fc.film_id "
				+"INNER JOIN category c ON c.category_id = fc.category_id "
				+"GROUP BY actorId limit ?,?";
	// 전체행의 개수
	String sql2 = "select count(*) from	"
				+"(SELECT a.actor_id actorId, CONCAT(a.first_name,' ',a.last_name) name,"
				+"GROUP_CONCAT(distinct concat(c.name,':',(select GROUP_CONCAT(title order BY title ASC separator ', ') "
				+"FROM film f INNER JOIN film_category fc ON f.film_id = fc.film_id "
				+"INNER JOIN film_actor fa ON fc.film_id = fa.film_id "
				+"WHERE fc.category_id = c.category_id AND fa.actor_id = a.actor_id)) "
				+"ORDER BY c.name SEPARATOR '---') info "
				+"FROM actor a "
				+"inner join film_actor fa ON a.actor_id = fa.actor_id "
				+"INNER JOIN film_category fc ON fa.film_id = fc.film_id "
				+"INNER JOIN category c ON c.category_id = fc.category_id "
				+"GROUP BY actorId) t";
	PreparedStatement stmt = conn.prepareStatement(sql);
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt.setInt(1,startIdx);
	stmt.setInt(2,rowPerPage);
	
	ResultSet rs = stmt.executeQuery();
	ResultSet rs2 = stmt2.executeQuery();
	rs2.next();
	
	int totalIdx = rs2.getInt("count(*)");
	int lastPage = totalIdx/rowPerPage;
	if(totalIdx % rowPerPage != 0){
		lastPage++;
	}
	
	int startPage = ((currentPage -1)/10)*10+1;
	int endPage = startPage+9;
	if(endPage>lastPage){
		endPage = lastPage;
	}
	
	ArrayList<HashMap<String,Object>> list = new ArrayList<>();
	while(rs.next()){
		HashMap<String,Object> map = new HashMap<>();
		map.put("actorId", rs.getInt("actorId"));
		map.put("name", rs.getString("name"));
		map.put("info", rs.getString("info"));
		
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
	<h1>ActorInfo</h1>
	<a href="/sakila/index.jsp">[시작페이지로]</a>
	<table border="1">
		<tr>
			<th>ACTORID</th>
			<th>NAME</th>
			<th>INFO</th>
		</tr>
			<%
				for(HashMap<String,Object> map : list){
			%>
					<tr>
						<td><%=map.get("actorId") %></td>
						<td><%=map.get("name") %></td>
						<td style="font-size:15px"><%=map.get("info") %></td>
					</tr>
			<% 
				}
			%>
	</table>
	<%
		if(currentPage>1){
	%>
			<a href="/sakila/d0401/actorInfo.jsp?currentPage=1">[처음]</a>
	<%
		}if(startPage>10){
	%>
			<a href="/sakila/d0401/actorInfo.jsp?currentPage=<%=startPage-10 %>">[이전]</a>
	<% 
		}for(int i=startPage; i<=endPage; i++){
	%>
			<a href="/sakila/d0401/actorInfo.jsp?currentPage=<%=i%>"><%=i%></a>
	<% 	
		}if(endPage<lastPage){
	%>
			<a href="/sakila/d0401/actorInfo.jsp?currentPage=<%=startPage+10 %>">[다음]</a>
	<% 
		}if(currentPage<lastPage){
	%>
			<a href="/sakila/d0401/actorInfo.jsp?currentPage=<%=lastPage%>">[마지막]</a>
	<% 
		}
	%>
</body>
</html>