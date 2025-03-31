<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	if(staffId == null){
		response.sendRedirect("/sakila/d0328/loginForm.jsp");
		return;
	}
	Integer inventoryId = Integer.valueOf(request.getParameter("inventoryId"));
	String searchName = request.getParameter("searchName");
	
	int currentPage=1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.valueOf(request.getParameter("currentPage"));
	}
	int rowPerPage = 5;
	int startIdx = (currentPage-1)*rowPerPage;
%>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/sakila", "root", "java1234");
	String sql = "select customer_id customerId,concat(first_name,' ',last_name)name, email, active "
				+"from customer where concat(first_name,last_name) like ? limit ?,?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1,"%"+searchName+"%");
	stmt.setInt(2,startIdx);
	stmt.setInt(3,rowPerPage);
	ResultSet rs = stmt.executeQuery();
	
	String sql2 = "select count(*) from customer where concat(first_name,last_name) like ?";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,"%"+searchName+"%");
	ResultSet rs2 = stmt2.executeQuery();
	rs2.next();
	
	int totalIdx = rs2.getInt("count(*)");
	int lastPage = totalIdx / rowPerPage;
	if(totalIdx % rowPerPage != 0){
		lastPage++;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body style="text-align:center">
	<h1>CustomerList</h1>
	<table border="1" style="margin:auto;width:auto">
		<tr>
			<td>customerId</td>
			<td>name</td>
			<td>email</td>
			<td>active</td>
			<td>선택</td>
		</tr>
		<%
			while(rs.next()){
		%>
				<tr>
					<td><%=rs.getInt("customerId") %></td>
					<td><%=rs.getString("name") %></td>
					<td><%=rs.getString("email") %></td>
					<td><%=rs.getInt("active") %></td>
					<td>
						<%
							if(rs.getInt("active")==0){
						%>
								<a href='/sakila/d0331/updateCustomerActive.jsp?customerId=<%=rs.getInt("customerId") %>&currentPage=<%=currentPage %>&inventoryId=<%=inventoryId%>&searchName=<%=searchName%>'>휴면해지</a> <!-- active를 0에서 1로 변경 -->
						<% 
							}else{
						%>
								<a href='/sakila/d0331/insertRentalForm.jsp?customerId=<%=rs.getInt("customerId") %>&inventoryId=<%=inventoryId%>'>선택하기</a>
						<%
							}
						%>
					</td>
				</tr>
		<% 
			}
		%>
	</table>
	<%
		if(currentPage > 1){
	%>
			<a href="/sakila/d0331/searchCustomidList.jsp?currentPage=1&inventoryId=<%=inventoryId%>&searchName=<%=searchName%>">[처음]</a>
			<a href="/sakila/d0331/searchCustomidList.jsp?currentPage=<%=currentPage-1%>&inventoryId=<%=inventoryId%>&searchName=<%=searchName%>">[이전]</a>
	<% 
		}
	%>
	<%=currentPage %>/<%=lastPage %>
	<%
		if(currentPage < lastPage){
	%>
			<a href="/sakila/d0331/searchCustomidList.jsp?currentPage=<%=currentPage+1%>&inventoryId=<%=inventoryId%>&searchName=<%=searchName%>">[다음]</a>
			<a href="/sakila/d0331/searchCustomidList.jsp?currentPage=<%=lastPage%>&inventoryId=<%=inventoryId%>&searchName=<%=searchName%>">[마지막]</a>
	<% 
		}
	%>
</body>
</html>