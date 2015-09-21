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
String key = request.getParameter("key");
if (key == null || key.length() == 0 ) {
	response.sendRedirect("positionlist.jsp");
	response.flushBuffer();
	return;
}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Get fields from form
Object x_Positionid = null;
Object x_PositionLat = null;
Object x_PositionLon = null;
Object x_userid = null;
Object x_PositionType = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `position` WHERE `Positionid`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("positionlist.jsp");
			response.flushBuffer();
			return;
		}else{
			rs.first();

			// Get the field contents
	x_Positionid = String.valueOf(rs.getLong("Positionid"));
			if (rs.getClob("PositionLat") != null) {
				long length = rs.getClob("PositionLat").length();
				x_PositionLat = rs.getClob("PositionLat").getSubString((long) 1, (int) length);
			}else{
				x_PositionLat = "";
			}
			if (rs.getClob("PositionLon") != null) {
				long length = rs.getClob("PositionLon").length();
				x_PositionLon = rs.getClob("PositionLon").getSubString((long) 1, (int) length);
			}else{
				x_PositionLon = "";
			}
	x_userid = String.valueOf(rs.getLong("userid"));
			if (rs.getString("PositionType") != null){
				x_PositionType = rs.getString("PositionType");
			}else{
				x_PositionType = "";
			}
		}
		rs.close();
	}else if (a.equals("U")) {// Update

		// Get fields from form
		if (request.getParameter("x_PositionLat") != null){
			x_PositionLat = (String) request.getParameter("x_PositionLat");
		}else{
			x_PositionLat = "";
		}
		if (request.getParameter("x_PositionLon") != null){
			x_PositionLon = (String) request.getParameter("x_PositionLon");
		}else{
			x_PositionLon = "";
		}
		if (request.getParameter("x_userid") != null){
			x_userid = (String) request.getParameter("x_userid");
		}else{
			x_userid = "";
		}
		if (request.getParameter("x_PositionType") != null){
			x_PositionType = (String) request.getParameter("x_PositionType");
		}else{
			x_PositionType = "";
		}

		// Open record
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `position` WHERE `Positionid`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("positionlist.jsp");
			response.flushBuffer();
			return;
		}

		// Field PositionLat
		tmpfld = ((String) x_PositionLat);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("PositionLat");
		}else{
			rs.updateString("PositionLat", tmpfld);
		}

		// Field PositionLon
		tmpfld = ((String) x_PositionLon);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("PositionLon");
		}else{
			rs.updateString("PositionLon", tmpfld);
		}

		// Field userid
		tmpfld = ((String) x_userid).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld != null) {
			rs.updateLong("userid", Long.parseLong(tmpfld));
		} else {
			rs.updateNull("userid");
		}

		// Field PositionType
		tmpfld = ((String) x_PositionType);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("PositionType");
		}else{
			rs.updateString("PositionType", tmpfld);
		}
		rs.updateRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("positionlist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
		out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Edit TABLE: position<br><br><a href="positionlist.jsp">Back to List</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_PositionLat && !EW_hasValue(EW_this.x_PositionLat, "TEXTAREA" )) {
            if (!EW_onError(EW_this, EW_this.x_PositionLat, "TEXTAREA", "Invalid Field - Position Lat"))
                return false; 
        }
if (EW_this.x_PositionLon && !EW_hasValue(EW_this.x_PositionLon, "TEXTAREA" )) {
            if (!EW_onError(EW_this, EW_this.x_PositionLon, "TEXTAREA", "Invalid Field - Position Lon"))
                return false; 
        }
if (EW_this.x_userid && !EW_checkinteger(EW_this.x_userid.value)) {
        if (!EW_onError(EW_this, EW_this.x_userid, "TEXT", "Incorrect integer - userid"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="positionedit" action="positionedit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Positionid</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_Positionid); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Position Lat</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_PositionLat" cols="35" rows="4"><% if (x_PositionLat!=null) out.print(x_PositionLat); %></textarea></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Position Lon</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_PositionLon" cols="35" rows="4"><% if (x_PositionLon!=null) out.print(x_PositionLon); %></textarea></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">userid</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_userid" size="30" value="<%= HTMLEncode((String)x_userid) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Position Type</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_PositionType" size="30" maxlength="2" value="<%= HTMLEncode((String)x_PositionType) %>"></span>&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="EDIT">
</form>
<%@ include file="footer.jsp" %>
