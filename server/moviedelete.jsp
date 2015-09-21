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

// Single delete record
String key = request.getParameter("key");
if (key == null || key.length() == 0 ) {
	response.sendRedirect("movielist.jsp");
	response.flushBuffer();
	return;
}
String sqlKey = "`MovieName`=" + "'" + key.replaceAll("'",escapeString) + "'";

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Display
		String strsql = "SELECT * FROM `movie` WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("movielist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		String strsql = "DELETE FROM `movie` WHERE " + sqlKey;
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("movielist.jsp");
		response.flushBuffer();
		return;
	}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Delete from TABLE: movie<br><br><a href="movielist.jsp">Back to List</a></span></p>
<form action="moviedelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">Movie Name</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Movie ID</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Movie Type</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Movie Time</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Hit Time</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Theater Name</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Location</span>&nbsp;</td>
	</tr>
<%
int recCount = 0;
while (rs.next()){
	recCount ++;
	String bgcolor = "#FFFFFF"; // Set row color
%>
<%
	if (recCount%2 != 0 ) { // Display alternate color for rows
		bgcolor = "#F5F5F5";
	}
%>
<%
	String x_MovieName = "";
	String x_MovieID = "";
	String x_MovieType = "";
	String x_MovieTime = "";
	String x_HitTime = "";
	String x_TheaterName = "";
	String x_Location = "";

	// MovieName
	if (rs.getString("MovieName") != null){
		x_MovieName = rs.getString("MovieName");
	}
	else{
		x_MovieName = "";
	}

	// MovieID
	x_MovieID = String.valueOf(rs.getLong("MovieID"));

	// MovieType
	if (rs.getString("MovieType") != null){
		x_MovieType = rs.getString("MovieType");
	}
	else{
		x_MovieType = "";
	}

	// MovieTime
	if (rs.getString("MovieTime") != null){
		x_MovieTime = rs.getString("MovieTime");
	}
	else{
		x_MovieTime = "";
	}

	// HitTime
	x_HitTime = String.valueOf(rs.getLong("HitTime"));

	// TheaterName
	if (rs.getString("TheaterName") != null){
		x_TheaterName = rs.getString("TheaterName");
	}
	else{
		x_TheaterName = "";
	}

	// Location
	if (rs.getString("Location") != null){
		x_Location = rs.getString("Location");
	}
	else{
		x_Location = "";
	}
%>
	<tr bgcolor="<%= bgcolor %>">
	<input type="hidden" name="key" value="<%= HTMLEncode(key) %>">
		<td class="jspmaker"><% out.print(x_MovieName); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_MovieID); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_MovieType); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_MovieTime); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_HitTime); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_TheaterName); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_Location); %>&nbsp;</td>
  </tr>
<%
}
rs.close();
rs = null;
stmt.close();
stmt = null;
conn.close();
conn = null;
}catch (SQLException ex){
	out.println(ex.toString());
}
%>
</table>
<p>
<input type="submit" name="Action" value="CONFIRM DELETE">
</form>
<%@ include file="footer.jsp" %>
