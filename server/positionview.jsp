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
if (key == null || key.length() == 0) { response.sendRedirect("positionlist.jsp");}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}
String x_Positionid = "";
String x_PositionLat = "";
String x_PositionLon = "";
String x_userid = "";
String x_PositionType = "";

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")) {// Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `position` WHERE `Positionid`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("positionlist.jsp");
		}else{
			rs.first();
		}

		// Get field values
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
		}else{
			x_PositionType = "";
		}
	}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">View TABLE: position<br><br><a href="positionlist.jsp">Back to List</a></span></p>
<p>
<form>
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Positionid</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_Positionid); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Position Lat</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (x_PositionLat != null) { out.print(((String)x_PositionLat).replaceAll("\r\n", "<br>"));} %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Position Lon</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (x_PositionLon != null) { out.print(((String)x_PositionLon).replaceAll("\r\n", "<br>"));} %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">userid</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_userid); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Position Type</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_PositionType); %></span>&nbsp;</td>
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
