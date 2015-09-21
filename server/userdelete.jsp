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
	response.sendRedirect("userlist.jsp");
	response.flushBuffer();
	return;
}
String sqlKey = "`userid`=" + "" + key.replaceAll("'",escapeString) + "";

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
		String strsql = "SELECT * FROM `user` WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("userlist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		String strsql = "DELETE FROM `user` WHERE " + sqlKey;
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("userlist.jsp");
		response.flushBuffer();
		return;
	}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Delete from TABLE: user<br><br><a href="userlist.jsp">Back to List</a></span></p>
<form action="userdelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">userid</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">username</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">userpassword</span>&nbsp;</td>
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
	String x_userid = "";
	String x_username = "";
	String x_userpassword = "";

	// userid
	x_userid = String.valueOf(rs.getLong("userid"));

	// username
	if (rs.getString("username") != null){
		x_username = rs.getString("username");
	}
	else{
		x_username = "";
	}

	// userpassword
	if (rs.getString("userpassword") != null){
		x_userpassword = rs.getString("userpassword");
	}
	else{
		x_userpassword = "";
	}
%>
	<tr bgcolor="<%= bgcolor %>">
	<input type="hidden" name="key" value="<%= HTMLEncode(key) %>">
		<td class="jspmaker"><% out.print(x_userid); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_username); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_userpassword); %>&nbsp;</td>
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
