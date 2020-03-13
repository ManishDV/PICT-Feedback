<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%
	// database to be created/dropped
	String year =(String) request.getParameter("select_year");

	System.out.println("year is "+year);
	
	String database = null;
	String username = "Deva";
	String password = "dev123456";

	String url = "jdbc:mysql://localhost:3306/";
	Connection connection = null;
	Statement statement = null, statement2 = null, statement3 = null;
	ResultSet rset, rnew, curdb = null;
	boolean databaseListChanged = false;
	boolean usedbflag = false;
	int result = -1, result2 = -1, result3 = -1;
	//String schema_path = "/home/aniket/Documents/PICT-Feedback-System/NewUpdatedJan24.sql";
	
	//session.setAttribute("select_db_year",year);

	try {
		Class.forName("com.mysql.jdbc.Driver").newInstance();
	} catch (ClassNotFoundException e) {
		out.println("Class not found: " + e.getMessage());
		return;
	}

	try {

		connection = DriverManager.getConnection(url, username, password);
		statement = connection.createStatement();
		statement2 = connection.createStatement();

		out.println("<b>List of databases accessible by user " + username + ":</b><br/>");
		rset = statement.executeQuery("SHOW DATABASES");
		while (rset.next()) {
			out.println(rset.getString(1) + "<br/>");
		}
		rset.close();
		out.println("<hr>");
		
%>

<form action="createNewDB.jsp" method="post" name="myDBForm">
		<label>Select Year</label> 
		<select name="select_year" id="select_year" onchange = "document.forms['myDBForm'].submit();">
		</select> 
		<script>
			(function() {
			    var elm = document.getElementById('select_year'),
			        df = document.createDocumentFragment();
			    for (var i = (new Date().getFullYear())-10; i <= (new Date().getFullYear())+10; i++) {
			        var option = document.createElement('option');
			        option.value = i + "_" + (i+1);
			        option.appendChild(document.createTextNode(i+" _ "+(i+1)));
			        df.appendChild(option);
			    }
			    elm.appendChild(df);
			}());
		</script>
		
		<input type="submit" name="Create" value="Create"> 
		<input type="submit" name="Drop" value="Drop"> 
		<input type="submit" name="Use" value="Use">
		<input type="reset" name="Reset" value="Reset">
</form>

<%
if (request.getParameter("select_year") != null) {
	database = (String) "feedback_main_" + request.getParameter("select_year");
	if (request.getParameter("Create") != null && request.getParameter("Create").equals("Create")) {
		rnew = statement.executeQuery("SHOW DATABASES LIKE '"+database+"'");		
		if (rnew.next() ) {
			out.println("Database already exists!!!!!");
		}
		else{
			result = statement.executeUpdate("CREATE DATABASE " + database);
			result2 = statement2.executeUpdate("USE " + database);
			//result3 = statement3.executeUpdate("SOURCE "+schema_path);
			out.println("result of 'CREATE DATABASE '" + database + " is " + result);
			databaseListChanged = true;
			rnew.close();
		}
	} else if (request.getParameter("Drop") != null && request.getParameter("Drop").equals("Drop")) {
		result = statement.executeUpdate("DROP DATABASE " + database);
		out.println("result of 'DROP DATABASE '" + database + " is " + result);
		databaseListChanged = true;
	} else if (request.getParameter("Use") != null && request.getParameter("Use").equals("Use")) {
		result = statement.executeUpdate("USE " + database);

		out.println("<b>result of USE " + database + " is " + result + "<b><br />");
		curdb = statement2.executeQuery("Select database()");
		while (curdb.next()) {
			out.println("<b>Current db in use is " + curdb.getString(1) + "</b><br/>");
		}
		curdb.close();
		out.println("<hr>");

		usedbflag = true;
		databaseListChanged = true;
	}

	session.setAttribute("database", database);
}

statement.close();
statement2.close();
connection.close();
if (databaseListChanged) {
	//response.sendRedirect(request.getRequestURL().toString() + "?result=" + result);
	response.sendRedirect("Login.html");
}
if (usedbflag) {
	System.out.println(database + " is in use !!!");
	out.println("Current database in use is " + request.getParameter("database") + "<br/>");
}
/* if (request.getParameter("result") != null) {
	out.println("result of last CREATE or DROP or Use database is " + request.getParameter("result")
			+ "<br/>");
} */
%>

<%
	} catch (SQLException e) {
		out.println(e.getMessage());
	} finally {
		try {
			if (connection != null)
				connection.close();
		} catch (SQLException e) {
		}
	}
%>

<script src="/1st_increment_feedback/js/jquery.js"></script>
<script>
$(document).ready(function(){
$("#select_year").val("<%=year%>")
});
</script>