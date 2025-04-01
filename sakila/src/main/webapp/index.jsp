<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	String username = (String)(session.getAttribute("username"));
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body style="text-align:center">
	<div>
		<%
			if(staffId == null){
		%>
				<a href="/sakila/d0328/loginForm.jsp">[로그인]</a>
		<% 
			}else{		
		%>
				<%=username %>님 반갑습니다
				<a href="/sakila/d0328/logout.jsp">[로그아웃]</a>
				<a href="/sakila/d0328/updatePasswordForm.jsp">[비밀번호수정]</a>
		<% 
			}
		%>
		
		
	</div>
	<hr>
	<h1>Index</h1>
	<ol style="display: table;margin: auto">
		<li><a href="/sakila/d0325/rentalList.jsp">대여목록</a></li>
		<li><a href="/sakila/d0326/filmList.jsp">영화목록</a></li>
		<li><a href="/sakila/d0326/actorList.jsp">배우목록</a></li>
		<li><a href="/sakila/d0327/inventoryList.jsp">인벤토리목록</a></li>
		<li><a href="/sakila/d0401/customerList.jsp">고객목록</a></li>
		<li><a href="/sakila/d0401/filmInfo.jsp">영화목록2</a></li>
		<li><a href="/sakila/d0401/actorInfo.jsp">배우목록2</a></li>
		<li><a href="/sakila/d0401/salesList.jsp">매출목록</a></li>
	</ol>
</body>
</html>