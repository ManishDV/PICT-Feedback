<%@page import="java.sql.*"%>

<%@page import="java.sql.*"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.*"%>
<%@page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
  
<% 
String oname=request.getParameter("oname");

String name=request.getParameter("name");

try{
Connection conn = null;
Class.forName("com.mysql.jdbc.Driver").newInstance();
conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/feedback_main","Deva", "dev123456");
Statement st=null;
st=conn.createStatement();
st.executeUpdate("update domain set domain_name='"+name+"'where domain_name='"+oname+"';");
response.sendRedirect("/1st_increment_feedback/Main Scripts/add_domain.jsp");
}
catch(Exception e){
	response.sendRedirect("/1st_increment_feedback/Main Scripts/add_domain.jsp?error=1");
System.out.println(e);
}
      
%>
