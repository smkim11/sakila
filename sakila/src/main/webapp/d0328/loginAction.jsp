<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	int staffId = Integer.valueOf(request.getParameter("staffId"));
	String password = request.getParameter("password");
	
	//mysql 로딩
	Class.forName("com.mysql.cj.jdbc.Driver");
	// 연결
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/sakila", "root", "java1234");
	String sql = "select staff_id staffId, username from staff where staff_id = ? and password = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1,staffId);
	stmt.setString(2,password);
	
	ResultSet rs = stmt.executeQuery();
	
	if(rs.next()){ // 로그인 성공
		System.out.println("로그인 성공");
		// 현재 세션 영역에 loginStaff 변수를 생성(이 변수가 접속자의 세션에 있다면 로그인 상태 없다면 로그아웃 상태)
		session.setAttribute("loginStaff", rs.getInt("staffId"));
		session.setAttribute("username", rs.getString("username"));
		response.sendRedirect("/sakila/index.jsp");
	}
	else{// 로그인 실패
		System.out.println("로그인 실패");
		response.sendRedirect("/sakila/d0328/loginForm.jsp");
	}
%>
