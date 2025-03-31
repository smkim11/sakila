<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	if(staffId == null){
		response.sendRedirect("/sakila/d0328/loginForm.jsp");
		return;
	}
	Integer customerId = Integer.valueOf(request.getParameter("customerId"));
	Integer inventoryId = Integer.valueOf(request.getParameter("inventoryId"));
	String searchName = request.getParameter("searchName");
	Integer currentPage = Integer.valueOf(request.getParameter("currentPage"));
%>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/sakila", "root", "java1234");
	String sql = "update customer set active = 1 where customer_id =?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1,customerId);
	System.out.println(stmt);
	
	int row = stmt.executeUpdate();
	if(row==1){
		System.out.println("해지 성공");
	}
	else if(row==0){
		System.out.println("해지 실패");
	}
	
	
	response.sendRedirect("/sakila/d0331/searchCustomidList.jsp?currentPage="+currentPage+"&inventoryId="+inventoryId+"&searchName="+searchName);
%>