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
	String searchTitle = request.getParameter("searchTitle");
	Integer currentPage = Integer.valueOf(request.getParameter("currentPage"));
%>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/sakila", "root", "java1234");
	String sql = "UPDATE rental SET return_date = NOW() WHERE inventory_id=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1,inventoryId);
	System.out.println(stmt);
	
	int row = stmt.executeUpdate();
	if(row==1){
		System.out.println("반납성공");
		response.sendRedirect("/sakila/d0327/inventoryList.jsp?currenPage="+currentPage+"&searchTitle="+searchTitle);
	}
	else{
		System.out.println("반납실패");
		response.sendRedirect("/sakila/d0327/inventoryList.jsp?currenPage="+currentPage+"&searchTitle="+searchTitle);
	}
%>