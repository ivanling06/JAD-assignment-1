<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 

	String userId = (String) session.getAttribute("userId");
    // Invalidate the current session
    if(userId != null){
    	session.invalidate();
    	
    }else{
    	
    	response.sendRedirect("../logIn/login.jsp");
    }
    	
    response.sendRedirect("../home/home.jsp");
    
%>