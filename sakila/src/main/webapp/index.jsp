<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
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
				<a href="/sakila/loginForm.jsp">[로그인]</a>
		<% 
			}else{		
		%>
				<%=staffId %>님 반갑습니다
				<a href="/sakila/logout.jsp">[로그아웃]</a>
				<a href="/sakila/updatePasswordForm.jsp">[비밀번호수정]</a>
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
	</ol>
</body>
</html>