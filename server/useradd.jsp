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
request.setCharacterEncoding("UTF-8");

// Get action
String a = request.getParameter("a");
String key = "";
if (a == null || a.length() == 0) {
	key = request.getParameter("key");
	if (key != null && key.length() > 0) {
		a = "C"; // Copy record
	} else {
		a = "I"; // Display blank record
	}
}
Object x_userid = null;
Object x_username = null;
Object x_userpassword = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `user` WHERE `userid`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("userlist.jsp");
			response.flushBuffer();
			return;
		}
		rs.first();

			// Get the field contents
	if (rs.getString("username") != null){
		x_username = rs.getString("username");
	}else{
		x_username = "";
	}
	if (rs.getString("userpassword") != null){
		x_userpassword = rs.getString("userpassword");
	}else{
		x_userpassword = "";
	}
		rs.close();
		rs = null;
	}else if (a.equals("A")) { // Add

		// Get fields from form
		if (request.getParameter("x_username") != null){
			x_username = (String) request.getParameter("x_username");
		}else{
			x_username = "";
		}
		if (request.getParameter("x_userpassword") != null){
			x_userpassword = (String) request.getParameter("x_userpassword");
		}else{
			x_userpassword = "";
		}

		// Open record
		String strsql = "SELECT * FROM `user` WHERE 0 = 1";
		rs = stmt.executeQuery(strsql);
		rs.moveToInsertRow();

		// Field username
		tmpfld = ((String) x_username);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("username");
		}else{
			rs.updateString("username", tmpfld);
		}

		// Field userpassword
		tmpfld = ((String) x_userpassword);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("userpassword");
		}else{
			rs.updateString("userpassword", tmpfld);
		}
		rs.insertRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		out.clear();
		response.sendRedirect("userlist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Add to TABLE: user<br><br><a href="userlist.jsp">Back to List</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_username && !EW_hasValue(EW_this.x_username, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_username, "TEXT", "Invalid Field - username"))
                return false; 
        }
if (EW_this.x_userpassword && !EW_hasValue(EW_this.x_userpassword, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_userpassword, "TEXT", "Invalid Field - userpassword"))
                return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="useradd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">username</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_username" size="30" maxlength="50" value="<%= HTMLEncode((String)x_username) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">userpassword</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_userpassword" size="30" maxlength="50" value="<%= HTMLEncode((String)x_userpassword) %>"></span>&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="ADD">
</form>
<%@ include file="footer.jsp" %>
