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
	response.sendRedirect("restrantlist.jsp");
	response.flushBuffer();
	return;
}
String sqlKey = "`RestrantName`=" + "'" + key.replaceAll("'",escapeString) + "'";

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
		String strsql = "SELECT * FROM `restrant` WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("restrantlist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		String strsql = "DELETE FROM `restrant` WHERE " + sqlKey;
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("restrantlist.jsp");
		response.flushBuffer();
		return;
	}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Delete from TABLE: restrant<br><br><a href="restrantlist.jsp">Back to List</a></span></p>
<form action="restrantdelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">Restrant Name</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Restrant ID</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Restrant Type</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Hit Time</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Location</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Location Description</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Restrant Image</span>&nbsp;</td>
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
	String x_RestrantName = "";
	String x_RestrantID = "";
	String x_RestrantType = "";
	String x_HitTime = "";
	String x_Location = "";
	String x_LocationDescription = "";
	String x_RestrantImage = "";

	// RestrantName
	if (rs.getString("RestrantName") != null){
		x_RestrantName = rs.getString("RestrantName");
	}
	else{
		x_RestrantName = "";
	}

	// RestrantID
	x_RestrantID = String.valueOf(rs.getLong("RestrantID"));

	// RestrantType
	if (rs.getString("RestrantType") != null){
		x_RestrantType = rs.getString("RestrantType");
	}
	else{
		x_RestrantType = "";
	}

	// HitTime
	x_HitTime = String.valueOf(rs.getLong("HitTime"));

	// Location
	if (rs.getString("Location") != null){
		x_Location = rs.getString("Location");
	}
	else{
		x_Location = "";
	}

	// LocationDescription
	if (rs.getString("LocationDescription") != null){
		x_LocationDescription = rs.getString("LocationDescription");
	}
	else{
		x_LocationDescription = "";
	}

	// RestrantImage
	if (rs.getString("RestrantImage") != null){
		x_RestrantImage = rs.getString("RestrantImage");
	}
	else{
		x_RestrantImage = "";
	}
%>
	<tr bgcolor="<%= bgcolor %>">
	<input type="hidden" name="key" value="<%= HTMLEncode(key) %>">
		<td class="jspmaker"><% out.print(x_RestrantName); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_RestrantID); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_RestrantType); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_HitTime); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_Location); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_LocationDescription); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_RestrantImage); %>&nbsp;</td>
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
