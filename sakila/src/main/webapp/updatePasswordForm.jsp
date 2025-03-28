<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	
	// 로그인 되었는지 안되었는지 확인
	if(staffId == null){ // 로그아웃 상태라면
		response.sendRedirect("/sakila/loginForm.jsp");
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
	<form action="/sakila/updatePasswordAction.jsp">
	<table border="1" style="margin:auto;width:auto">
		<tr>
			<th>Pre PW</th>
			<td><input type="password" name="prePw"></td>
		</tr>
		<tr>
			<th>New PW</th>
			<td><input type="password" name="newPw"></td>
		</tr>
	</table>
	<button type="submit">수정</button>
	</form>
</body>
</html>