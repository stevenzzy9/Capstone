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
<% 
String login = (String) session.getAttribute("project3_status");
if (login == null || !login.equals("login")) {
response.sendRedirect("login.jsp");
response.flushBuffer(); 
return; 
}%>
<%int ewAllowAdmin = 16; 
int ewCurSec = 31;%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
String tmpfld = null;
String escapeString = "\\\\'";
String key = request.getParameter("key");
if (key == null || key.length() == 0) { response.sendRedirect("locationlist.jsp");}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}
String x_userid = "";
String x_location = "";
String x_locationtype = "";

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")) {// Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `location` WHERE `userid`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("locationlist.jsp");
		}else{
			rs.first();
		}

		// Get field values
		// userid

		x_userid = String.valueOf(rs.getLong("userid"));

		// location
		if (rs.getClob("location") != null) {
			long length = rs.getClob("location").length();
			x_location = rs.getClob("location").getSubString((long) 1, (int) length);
		}else{
			x_location = "";
		}

		// locationtype
		x_locationtype = String.valueOf(rs.getLong("locationtype"));
	}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">View TABLE: location<br><br><a href="locationlist.jsp">Back to List</a></span></p>
<p>
<form>
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">userid</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_userid); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">location</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (x_location != null) { out.print(((String)x_location).replaceAll("\r\n", "<br>"));} %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">locationtype</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_locationtype); %></span>&nbsp;</td>
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
