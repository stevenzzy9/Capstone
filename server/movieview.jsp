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
if (key == null || key.length() == 0) { response.sendRedirect("movielist.jsp");}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}
String x_MovieName = "";
String x_MovieID = "";
String x_MovieType = "";
String x_MovieTime = "";
String x_HitTime = "";
String x_TheaterName = "";
String x_Location = "";

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")) {// Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `movie` WHERE `MovieName`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("movielist.jsp");
		}else{
			rs.first();
		}

		// Get field values
		// MovieName

		if (rs.getString("MovieName") != null){
			x_MovieName = rs.getString("MovieName");
		}else{
			x_MovieName = "";
		}

		// MovieID
		x_MovieID = String.valueOf(rs.getLong("MovieID"));

		// MovieType
		if (rs.getString("MovieType") != null){
			x_MovieType = rs.getString("MovieType");
		}else{
			x_MovieType = "";
		}

		// MovieTime
		if (rs.getString("MovieTime") != null){
			x_MovieTime = rs.getString("MovieTime");
		}else{
			x_MovieTime = "";
		}

		// HitTime
		x_HitTime = String.valueOf(rs.getLong("HitTime"));

		// TheaterName
		if (rs.getString("TheaterName") != null){
			x_TheaterName = rs.getString("TheaterName");
		}else{
			x_TheaterName = "";
		}

		// Location
		if (rs.getString("Location") != null){
			x_Location = rs.getString("Location");
		}else{
			x_Location = "";
		}
	}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">View TABLE: movie<br><br><a href="movielist.jsp">Back to List</a></span></p>
<p>
<form>
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Movie Name</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_MovieName); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Movie ID</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_MovieID); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Movie Type</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_MovieType); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Movie Time</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_MovieTime); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Hit Time</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_HitTime); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Theater Name</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_TheaterName); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Location</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_Location); %></span>&nbsp;</td>
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
