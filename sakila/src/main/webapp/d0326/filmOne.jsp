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
	
	int filmId = Integer.valueOf(request.getParameter("filmId"));

%>
<%
	//mysql 로딩
	Class.forName("com.mysql.cj.jdbc.Driver");
	// 연결
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/sakila", "root", "java1234");
	// 영화 상세정보
	String sql = "SELECT f.film_id filmId, f.title, f.description, "
			+"concat(round(f.length/60,1),'시간') length, f.release_year releaseYear, c.name category from film f "
			+"INNER JOIN film_category fc ON f.film_id = fc.film_id "
			+"INNER JOIN category c ON fc.category_id = c.category_id "
			+"where f.film_id = ?";
	PreparedStatement stmt=conn.prepareStatement(sql);
	stmt.setInt(1,filmId);
	ResultSet rs = stmt.executeQuery();
	// 출연 배우
	String sql2 = "SELECT f.film_id filmId, a.actor_id actorId, CONCAT(a.first_name,' ',a.last_name)NAME "
				+"FROM actor a INNER JOIN film_actor fa ON a.actor_id = fa.actor_id "
				+"INNER JOIN film f ON f.film_id = fa.film_id where f.film_id = ?";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1,filmId);
	ResultSet rs2 = stmt2.executeQuery();
	
	// 영화 상세정보
	ArrayList<HashMap<String,Object>> list = new ArrayList<>();
	while(rs.next()){
		HashMap<String,Object> h = new HashMap<>();
		h.put("filmId", rs.getInt("filmId"));
		h.put("title", rs.getString("title"));
		h.put("description", rs.getString("description"));
		h.put("category", rs.getString("category"));
		h.put("releaseYear", rs.getInt("releaseYear"));
		h.put("length", rs.getString("length"));
		
		list.add(h);
	}
	// 출연 배우
	ArrayList<HashMap<String,Object>> list2 = new ArrayList<>();
	while(rs2.next()){
		HashMap<String,Object> h2 = new HashMap<>();
		h2.put("actorId", rs2.getInt("actorId"));
		h2.put("name", rs2.getString("name"));
		
		list2.add(h2);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body style="text-align:center">
<h1>Film One</h1>
	<a href="/sakila/d0326/filmList.jsp">영화목록으로</a>
	<table border="1" style="margin:auto ; width:50%">
		
		<%
			for(HashMap<String,Object> h : list){
		%>
			<tr>
				<th>filmId</th>
				<td><%=h.get("filmId") %></td>
			</tr><tr>
				<th>title</th>
				<td><%=h.get("title") %></td>
			</tr><tr>	
				<th>description</th>
				<td><%=h.get("description") %></td>
			</tr><tr>	
				<th>category</th>
				<td><%=h.get("category") %></td>
			</tr><tr>	
				<th>releaseYear</th>
				<td><%=h.get("releaseYear") %></td>
			</tr><tr>	
				<th>length</th>
				<td><%=h.get("length") %></td>
			</tr>
		
		<% 
			}
		%>
	</table>
		<h2>Actor</h2>
			<table border="1" style="margin:auto ; width:50%">
				<tr>
					<th>actorId</th>
					<th>name</th>
				</tr>
				<%
					for(HashMap<String,Object> h2 : list2){
				%>
						<tr>
							<td><%=h2.get("actorId") %></td>
							<td><a href="/sakila/d0326/actorOne.jsp?actorId=<%=h2.get("actorId")%>"><%=h2.get("name") %></td>
						</tr>
				<% 
					}
				%>
			</table>
</body>
</html>