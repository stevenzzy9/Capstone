<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
response.setDateHeader("Expires", 0); // date in the past
response.addHeader("Cache-Control", "no-store, no-cache, must-revalidate"); // HTTP/1.1 
response.addHeader("Cache-Control", "post-check=0, pre-check=0"); 
response.addHeader("Pragma", "no-cache"); // HTTP/1.0 
%>
<% Locale locale = Locale.getDefault();
response.setLocale(locale);%>
<% session.setMaxInactiveInterval(30*60); %>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
String tmpfld = null;
String escapeString = "\\\\'";
String key = request.getParameter("key");
if (key == null || key.length() == 0) { response.sendRedirect("userlist.jsp");}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}
String x_userid = "";
String x_username = "";
String x_userpassword = "";

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")) {// Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `user` WHERE `userid`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("userlist.jsp");
		}else{
			rs.first();
		}

		// Get field values
		// userid

		x_userid = String.valueOf(rs.getLong("userid"));

		// username
		if (rs.getString("username") != null){
			x_username = rs.getString("username");
		}else{
			x_username = "";
		}

		// userpassword
		if (rs.getString("userpassword") != null){
			x_userpassword = rs.getString("userpassword");
		}else{
			x_userpassword = "";
		}
	}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">View TABLE: user<br><br><a href="userlist.jsp">Back to List</a></span></p>
<p>
<form>
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">userid</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_userid); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">username</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_username); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">userpassword</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_userpassword); %></span>&nbsp;</td>
	</tr>
</table>
</form>
<p>
<%
	rs.close();
	rs = null;
	stmt.close();
	stmt = null;
	conn.close();
	conn = null;
}catch(SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="footer.jsp" %>
