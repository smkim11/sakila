<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	String newPw = request.getParameter("newPw");
	String prePw = request.getParameter("prePw");
%>
<%
	//mysql 로딩
	Class.forName("com.mysql.cj.jdbc.Driver");
	// 연결
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/sakila", "root", "java1234");
	String sql = "UPDATE staff SET PASSWORD = ? where staff_id =? and PASSWORD = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1,newPw);
	stmt.setInt(2,staffId);
	stmt.setString(3,prePw);
	
	int row = stmt.executeUpdate();
	if(row==0){
		System.out.println("변경 실패");
		response.sendRedirect("/sakila/updatePasswordForm.jsp");
		return;
	}
	System.out.println("변경 성공");
	response.sendRedirect("/sakila/logout.jsp");
%>