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
	
	String searchTitle = request.getParameter("searchTitle");
	if(request.getParameter("searchTitle")==null){
		searchTitle ="";
	}
	System.out.println("searchTitle: "+searchTitle);
	
	int currentPage=1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.valueOf(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	int startIdx = (currentPage-1)*rowPerPage;
	
%>
<%
	//mysql 로딩
	Class.forName("com.mysql.cj.jdbc.Driver");
	// 연결
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/sakila", "root", "java1234");
	PreparedStatement stmt = null;
	PreparedStatement stmt2 = null;
	String sql = "SELECT f.film_id filmId, f.title from film f INNER JOIN film_category fc ON f.film_id = fc.film_id "
				+"INNER JOIN category c ON fc.category_id = c.category_id ";
	String sql2 = "select count(*) from film f INNER JOIN film_category fc ON f.film_id = fc.film_id "
				 +"INNER JOIN category c ON fc.category_id = c.category_id";
	if(searchTitle.equals("")){ // 검색어 입력 안했을 때
		sql+="order by filmId asc limit ?,?";
		stmt=conn.prepareStatement(sql);
		stmt2=conn.prepareStatement(sql2);
		stmt.setInt(1,startIdx);
		stmt.setInt(2,rowPerPage);
	}
	else{ // 입력했을 때
		sql += "where title like ? order by filmId asc limit ?,?";
		sql2 += " where title like ?";
		stmt=conn.prepareStatement(sql);
		stmt2=conn.prepareStatement(sql2);
		stmt.setString(1,"%"+searchTitle+"%");
		stmt.setInt(2,startIdx);
		stmt.setInt(3,rowPerPage);
		stmt2.setString(1,"%"+searchTitle+"%");
	}
	
	ResultSet rs = stmt.executeQuery();
	ResultSet rs2 = stmt2.executeQuery();
	rs2.next();
	
	ArrayList<HashMap<String,Object>> list = new ArrayList<>();
	while(rs.next()){
		HashMap<String,Object> h = new HashMap<>();
		h.put("filmId", rs.getInt("filmId"));
		h.put("title", rs.getString("title"));
		
		list.add(h);
	}
	
	int totalIdx = rs2.getInt("count(*)");
	int lastPage = totalIdx / rowPerPage;
	if(totalIdx % rowPerPage != 0){
		lastPage++;
	}
	
	int pageGroup = (currentPage -1) /10;
	int startPage = pageGroup * 10 +1;
	int endPage = startPage +9;
	if(endPage > lastPage){
		endPage = lastPage;
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body style="text-align:center">
	<h1>Film List</h1>
	<table border="1" style="margin:auto ; width:70%">
		<tr>
			<th>filmId</th>
			<th>title</th>
		</tr>
		<%
			for(HashMap<String,Object> h : list){
		%>
				<tr>
					<td><%=h.get("filmId") %></td>
					<td><a href="/sakila/d0326/filmOne.jsp?filmId=<%=h.get("filmId")%>"><%=h.get("title") %></td>
				</tr>
		<% 
			}
		%>
	</table>
	<form action="/sakila/d0326/filmList.jsp">
		<input type="text" name="searchTitle">
		<button type="submit">검색</button>
	</form>
	<div><%=currentPage %>/<%=lastPage %></div>
	<%
		if(currentPage>1){
	%>
			<a href="/sakila/d0326/filmList.jsp?currentPage=1&searchTitle=<%=searchTitle%>">[처음]</a>
	<% 
		}
	%>
	<%
		if(startPage>10){
	%>
			<a href="/sakila/d0326/filmList.jsp?currentPage=<%=startPage-10 %>&searchTitle=<%=searchTitle%>">[이전]</a>
	<% 
		}
	%>
	<%
		for(int i=startPage; i<=endPage; i++){
	%>
			<a href="/sakila/d0326/filmList.jsp?currentPage=<%=i%>&searchTitle=<%=searchTitle%>">[<%=i%>]</a>
	<% 
		}
	%>
	<%
		if(endPage<lastPage){
	%>
			<a href="/sakila/d0326/filmList.jsp?currentPage=<%=startPage+10 %>&searchTitle=<%=searchTitle%>">[다음]</a>
	<% 
		}
	%>
	<%
		if(currentPage<lastPage){
	%>
			<a href="/sakila/d0326/filmList.jsp?currentPage=<%=lastPage %>&searchTitle=<%=searchTitle%>">[마지막]</a>
	<% 
		}
	%>
</body>
</html>