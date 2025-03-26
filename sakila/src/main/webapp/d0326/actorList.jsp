<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
	String searchName = request.getParameter("searchName");
	if(request.getParameter("searchName")==null){
		searchName="";
	}
	System.out.println("searchName: "+searchName);
	
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage=Integer.valueOf(request.getParameter("currentPage"));
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
	String sql = "SELECT actor_id actorId, CONCAT(first_name,' ',last_name)name "
				+"FROM actor";
	String sql2 = "select count(*) from actor";
	if(searchName.equals("")){ // 검색어 입력 안했을 때
		sql+=" limit ?,?";
		stmt=conn.prepareStatement(sql);
		stmt2=conn.prepareStatement(sql2);
		stmt.setInt(1,startIdx);
		stmt.setInt(2,rowPerPage);
	}
	else{ // 입력했을 때
		sql += "where CONCAT(first_name,' ',last_name) like ? limit ?,?";
		sql2 += " where CONCAT(first_name,' ',last_name) like ?";
		stmt=conn.prepareStatement(sql);
		stmt2=conn.prepareStatement(sql2);
		stmt.setString(1,"%"+searchName+"%");
		stmt.setInt(2,startIdx);
		stmt.setInt(3,rowPerPage);
		stmt2.setString(1,"%"+searchName+"%");
	}
	System.out.println(stmt);
	System.out.println(stmt2);
	
	ResultSet rs = stmt.executeQuery();
	ResultSet rs2 = stmt2.executeQuery();
	rs2.next();
	
	int totalIdx = rs2.getInt("count(*)");
	int lastPage = totalIdx / rowPerPage;
	if(totalIdx % rowPerPage != 0){
		lastPage++;
	}
	
	ArrayList<HashMap<String,Object>> list = new ArrayList<>();
	while(rs.next()){
		HashMap<String,Object> h = new HashMap<>();
		h.put("actorId",rs.getInt("actorId"));
		h.put("name",rs.getString("name"));
		
		list.add(h);
	}
	
	int pageGroup = (currentPage -1) /10;
	int startPage = pageGroup * 10 +1;
	int endPage = startPage + 9;
	if(endPage>lastPage){
		endPage=lastPage;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body style="text-align:center">
	<h1>Actor List</h1>
	<table border="1"style="margin:auto ; width:70%">
		<tr>
			<th>actorId</th>
			<th>name</th>
		</tr>
		<%
			for(HashMap<String,Object> h : list){
		%>
				<tr>
					<td><%=h.get("actorId") %></td>
					<td><a href="/sakila/d0326/actorOne.jsp?actorId=<%=h.get("actorId")%>"><%=h.get("name") %></td>
				</tr>
		<%
			}
		%>
	</table>
	<form action="/sakila/d0326/actorList.jsp">
		<input type="text" name="searchName">
		<button type="submit">검색</button>
	</form>
	<div><%=currentPage %>/<%=lastPage %></div>
	<%
		if(currentPage>1){
	%>
			<a href="/sakila/d0326/actorList.jsp?currentPage=1&searchName=<%=searchName%>">[처음]</a>
	<% 
		}
	%>
	<%
		if(startPage>10){
	%>
			<a href="/sakila/d0326/actorList.jsp?currentPage=<%=startPage-10 %>&searchName=<%=searchName%>">[이전]</a>
	<%
		}
	%>
	<%
		for(int i=startPage;i<=endPage;i++){
	%>
			<a href="/sakila/d0326/actorList.jsp?currentPage=<%=i %>&searchName=<%=searchName%>">[<%=i %>]</a>
	<% 
		}
	%>
	<%
		if(endPage<lastPage){
	%>
			<a href="/sakila/d0326/actorList.jsp?currentPage=<%=startPage+10 %>&searchName=<%=searchName%>">[다음]</a>
	<%
		}
	%>
	<%
		if(currentPage<lastPage){
	%>
			<a href="/sakila/d0326/actorList.jsp?currentPage=<%=lastPage %>&searchName=<%=searchName%>">[마지막]</a>
	<%
		}
	%>
</body>
</html>