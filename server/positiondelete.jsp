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
	response.sendRedirect("positionlist.jsp");
	response.flushBuffer();
	return;
}
String sqlKey = "`Positionid`=" + "" + key.replaceAll("'",escapeString) + "";

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
		String strsql = "SELECT * FROM `position` WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("positionlist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		String strsql = "DELETE FROM `position` WHERE " + sqlKey;
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("positionlist.jsp");
		response.flushBuffer();
		return;
	}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Delete from TABLE: position<br><br><a href="positionlist.jsp">Back to List</a></span></p>
<form action="positiondelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">Positionid</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">userid</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Position Type</span>&nbsp;</td>
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
	String x_Positionid = "";
	String x_PositionLat = "";
	String x_PositionLon = "";
	String x_userid = "";
	String x_PositionType = "";

	// Positionid
	x_Positionid = String.valueOf(rs.getLong("Positionid"));

	// PositionLat
	if (rs.getClob("PositionLat") != null) {
		long length = rs.getClob("PositionLat").length();
		x_PositionLat = rs.getClob("PositionLat").getSubString((long) 1, (int) length);
	}else{
		x_PositionLat = "";
	}

	// PositionLon
	if (rs.getClob("PositionLon") != null) {
		long length = rs.getClob("PositionLon").length();
		x_PositionLon = rs.getClob("PositionLon").getSubString((long) 1, (int) length);
	}else{
		x_PositionLon = "";
	}

	// userid
	x_userid = String.valueOf(rs.getLong("userid"));

	// PositionType
	if (rs.getString("PositionType") != null){
		x_PositionType = rs.getString("PositionType");
	}
	else{
		x_PositionType = "";
	}
%>
	<tr bgcolor="<%= bgcolor %>">
	<input type="hidden" name="key" value="<%= HTMLEncode(key) %>">
		<td class="jspmaker"><% out.print(x_Positionid); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_userid); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_PositionType); %>&nbsp;</td>
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
