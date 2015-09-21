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
request.setCharacterEncoding("UTF-8");
String key = request.getParameter("key");
if (key == null || key.length() == 0 ) {
	response.sendRedirect("locationlist.jsp");
	response.flushBuffer();
	return;
}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Get fields from form
Object x_userid = null;
Object x_location = null;
Object x_locationtype = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `location` WHERE `userid`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("locationlist.jsp");
			response.flushBuffer();
			return;
		}else{
			rs.first();

			// Get the field contents
	x_userid = String.valueOf(rs.getLong("userid"));
			if (rs.getClob("location") != null) {
				long length = rs.getClob("location").length();
				x_location = rs.getClob("location").getSubString((long) 1, (int) length);
			}else{
				x_location = "";
			}
	x_locationtype = String.valueOf(rs.getLong("locationtype"));
		}
		rs.close();
	}else if (a.equals("U")) {// Update

		// Get fields from form
		if (request.getParameter("x_userid") != null){
			x_userid = (String) request.getParameter("x_userid");
		}else{
			x_userid = "";
		}
		if (request.getParameter("x_location") != null){
			x_location = (String) request.getParameter("x_location");
		}else{
			x_location = "";
		}
		if (request.getParameter("x_locationtype") != null){
			x_locationtype = (String) request.getParameter("x_locationtype");
		}else{
			x_locationtype = "";
		}

		// Open record
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `location` WHERE `userid`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("locationlist.jsp");
			response.flushBuffer();
			return;
		}

		// Field userid
		tmpfld = ((String) x_userid).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld != null) {
			rs.updateLong("userid", Long.parseLong(tmpfld));
		} else {
			rs.updateNull("userid");
		}

		// Field location
		tmpfld = ((String) x_location);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("location");
		}else{
			rs.updateString("location", tmpfld);
		}

		// Field locationtype
		tmpfld = ((String) x_locationtype).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("locationtype");
		} else {
			rs.updateInt("locationtype",Integer.parseInt(tmpfld));
		}
		rs.updateRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("locationlist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
		out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Edit TABLE: location<br><br><a href="locationlist.jsp">Back to List</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_userid && !EW_hasValue(EW_this.x_userid, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_userid, "TEXT", "Incorrect integer - userid"))
                return false; 
        }
if (EW_this.x_userid && !EW_checkinteger(EW_this.x_userid.value)) {
        if (!EW_onError(EW_this, EW_this.x_userid, "TEXT", "Incorrect integer - userid"))
            return false; 
        }
if (EW_this.x_location && !EW_hasValue(EW_this.x_location, "TEXTAREA" )) {
            if (!EW_onError(EW_this, EW_this.x_location, "TEXTAREA", "Invalid Field - location"))
                return false; 
        }
if (EW_this.x_locationtype && !EW_hasValue(EW_this.x_locationtype, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_locationtype, "TEXT", "Incorrect integer - locationtype"))
                return false; 
        }
if (EW_this.x_locationtype && !EW_checkinteger(EW_this.x_locationtype.value)) {
        if (!EW_onError(EW_this, EW_this.x_locationtype, "TEXT", "Incorrect integer - locationtype"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="locationedit" action="locationedit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">userid</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_userid" size="30" value="<%= HTMLEncode((String)x_userid) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">location</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_location" cols="35" rows="4"><% if (x_location!=null) out.print(x_location); %></textarea></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">locationtype</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_locationtype" size="30" value="<%= HTMLEncode((String)x_locationtype) %>"></span>&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="EDIT">
</form>
<%@ include file="footer.jsp" %>
