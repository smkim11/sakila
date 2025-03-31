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
	
%>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/sakila", "root", "java1234");
	String sql = "insert into rental(rental_date, inventory_id, customer_id, staff_id) values(NOW(),?,?,?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1,inventoryId);
	stmt.setInt(2,customerId);
	stmt.setInt(3,staffId);
	System.out.println(stmt);
	
	int row = stmt.executeUpdate();

	if(row==1){
		System.out.println("대여 성공");
	}
	else if(row==0){
		System.out.println("대여 실패");
	}
	
	response.sendRedirect("/sakila/d0327/inventoryList.jsp");
%>
