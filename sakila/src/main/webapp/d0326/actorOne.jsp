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
	
	int actorId = Integer.valueOf(request.getParameter("actorId"));

	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage=Integer.valueOf(request.getParameter("currentPage"));
	}
	int rowPerPage = 4;
	int startIdx = (currentPage-1)*rowPerPage;
%>
<%
	//mysql 로딩
	Class.forName("com.mysql.cj.jdbc.Driver");
	// 연결
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/sakila", "root", "java1234");
	// 배우 정보
	String sql = "SELECT actor_id actorId, CONCAT(first_name,' ',last_name) name "
				+"FROM actor where actor_id = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1,actorId);
	ResultSet rs = stmt.executeQuery();
	
	// 출연 영화
	String sql2 = "SELECT f.film_id filmId, a.actor_id actorId, f.title "
				+"FROM actor a INNER JOIN film_actor fa ON a.actor_id = fa.actor_id "
				+"INNER JOIN film f ON f.film_id = fa.film_id where a.actor_id=? limit ?, ?";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1,actorId);
	stmt2.setInt(2,startIdx);
	stmt2.setInt(3,rowPerPage);
	ResultSet rs2 = stmt2.executeQuery();
	
	// 출연 영화 개수(페이징)
	String sql3 = "SELECT count(*) "
			+"FROM actor a INNER JOIN film_actor fa ON a.actor_id = fa.actor_id "
			+"INNER JOIN film f ON f.film_id = fa.film_id where a.actor_id=?";
	PreparedStatement stmt3 = conn.prepareStatement(sql3);
	stmt3.setInt(1,actorId);
	ResultSet rs3 = stmt3.executeQuery();
	rs3.next();
	
	int totalIdx = rs3.getInt("count(*)");
	int lastPage = totalIdx / rowPerPage;
	if(totalIdx % rowPerPage != 0){
		lastPage++;
	}
	// 배우 정보
	ArrayList<HashMap<String,Object>> list = new ArrayList<>();
	while(rs.next()){
		HashMap<String,Object> h = new HashMap<>();
		h.put("actorId",rs.getInt("actorId"));
		h.put("name", rs.getString("name"));
		
		list.add(h);
	}
	// 출연 영화
	ArrayList<HashMap<String,Object>> list2 = new ArrayList<>();
	while(rs2.next()){
		HashMap<String,Object> h = new HashMap<>();
		h.put("filmId",rs2.getInt("filmId"));
		h.put("actorId",rs2.getInt("actorId"));
		h.put("title", rs2.getString("title"));
		
		list2.add(h);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body style="text-align:center">
<h1>Actor One</h1>
	<a href="/sakila/d0326/actorList.jsp">배우목록으로</a>
	<table border="1" style="margin:auto ; width:50%">
		<%
			for(HashMap<String,Object> h : list){
		%>
			<tr>
				<th>actorId</th>
				<td><%=h.get("actorId") %></td>
			</tr>
			<tr>
				<th>name</th>
				<td><%=h.get("name") %></td>
			</tr>
		<%
			}
		%>
	</table>
	<h2>Film</h2>
	<table border="1" style="margin:auto ; width:50%">
		<tr>
			<th>filmId</th>
			<th>title</th>
		</tr>
			<%
				for(HashMap<String,Object> h : list2){
			%>
					<tr>
						<td><%=h.get("filmId") %></td>
						<td><a href="/sakila/d0326/filmOne.jsp?filmId=<%=h.get("filmId")%>"><%=h.get("title") %></td>
					</tr>
			<%
				}
			%>
	</table>

	<%
		if(currentPage>1){
	%>
			<a href="/sakila/d0326/actorOne.jsp?currentPage=1&actorId=<%=actorId%>">[처음]</a>
			<a href="/sakila/d0326/actorOne.jsp?currentPage=<%=currentPage-1 %>&actorId=<%=actorId%>">[이전]</a>
	<% 
		}
	%>
	<%=currentPage %>/<%=lastPage %>
	<%
		if(currentPage<lastPage){
	%>
			<a href="/sakila/d0326/actorOne.jsp?currentPage=<%=currentPage+1 %>&actorId=<%=actorId%>">[다음]</a>
			<a href="/sakila/d0326/actorOne.jsp?currentPage=<%=lastPage%>&actorId=<%=actorId%>">[마지막]</a>
	<% 
		}
	%>
</body>
</html>