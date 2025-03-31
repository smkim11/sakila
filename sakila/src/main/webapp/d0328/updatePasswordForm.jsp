<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));

	if(staffId == null){ // 로그아웃 상태라면
		response.sendRedirect("/sakila/index.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body style="text-align: center">
	<h1>Update Password</h1>
	<form action="/sakila/d0328/updatePasswordAction.jsp" method="post">
	<table border="1" style="margin:auto;width:auto">
		<tr>
			<th>Pre PW</th>
			<td><input type="password" name="prePw"></td>
		</tr>
		<tr>
			<th>New PW</th>
			<td><input type="password" name="newPw"></td>
		</tr>
		<tr>
			<th>New PW2</th>
			<td><input type="password" name="newPw2"></td>
		</tr>
	</table>
	<button type="submit">수정</button>
	</form>
</body>
</html>