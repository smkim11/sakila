<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));

	if(staffId != null){ // 로그인 상태라면
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
<body style="text-align:center">
	<h1>Staff Login</h1>
	<form action="/sakila/d0328/loginAction.jsp" method="post">
	<table border="1" style="margin:auto; width:auto">
		<tr>
			<th>ID</th>
			<td><input type="number" name="staffId"></td>
		</tr>
		<tr>
			<th>PW</th>
			<td><input type="password" name="password"></td>
		</tr>
	</table>
	<button type="submit">로그인</button>
	</form>
</body>
</html>