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
Object x_MeetingID = null;
Object x_KeyWord = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `meetingkeyword` WHERE `MeetingID`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("meetingkeywordlist.jsp");
			response.flushBuffer();
			return;
		}
		rs.first();

			// Get the field contents
	x_MeetingID = String.valueOf(rs.getLong("MeetingID"));
	if (rs.getString("KeyWord") != null){
		x_KeyWord = rs.getString("KeyWord");
	}else{
		x_KeyWord = "";
	}
		rs.close();
		rs = null;
	}else if (a.equals("A")) { // Add

		// Get fields from form
		if (request.getParameter("x_MeetingID") != null){
			x_MeetingID = (String) request.getParameter("x_MeetingID");
		}else{
			x_MeetingID = "";
		}
		if (request.getParameter("x_KeyWord") != null){
			x_KeyWord = (String) request.getParameter("x_KeyWord");
		}else{
			x_KeyWord = "";
		}

		// Open record
		String strsql = "SELECT * FROM `meetingkeyword` WHERE 0 = 1";
		rs = stmt.executeQuery(strsql);
		rs.moveToInsertRow();

		// Field MeetingID
		tmpfld = ((String) x_MeetingID).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		String srchfld = tmpfld;
			srchfld = srchfld.replaceAll("'","\\\\'");
			strsql = "SELECT * FROM `meetingkeyword` WHERE `MeetingID` = " + srchfld;
			Statement stmtchk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rschk = stmtchk.executeQuery(strsql);
			if (rschk.next()) {
				out.print("Duplicate key for MeetingID, value = " + tmpfld + "<br>");
				out.print("Press [Previous Page] key to continue!");
				return;
			}
			rschk.close();
			rschk = null;
		if (tmpfld != null) {
			rs.updateLong("MeetingID", Long.parseLong(tmpfld));
		} else {
			rs.updateNull("MeetingID");
		}

		// Field KeyWord
		tmpfld = ((String) x_KeyWord);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("KeyWord");
		}else{
			rs.updateString("KeyWord", tmpfld);
		}
		rs.insertRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		out.clear();
		response.sendRedirect("meetingkeywordlist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Add to TABLE: meetingkeyword<br><br><a href="meetingkeywordlist.jsp">Back to List</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_MeetingID && !EW_hasValue(EW_this.x_MeetingID, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_MeetingID, "TEXT", "Incorrect integer - Meeting ID"))
                return false; 
        }
if (EW_this.x_MeetingID && !EW_checkinteger(EW_this.x_MeetingID.value)) {
        if (!EW_onError(EW_this, EW_this.x_MeetingID, "TEXT", "Incorrect integer - Meeting ID"))
            return false; 
        }
if (EW_this.x_KeyWord && !EW_hasValue(EW_this.x_KeyWord, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_KeyWord, "TEXT", "Invalid Field - Key Word"))
                return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="meetingkeywordadd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Meeting ID</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_MeetingID" size="30" value="<%= HTMLEncode((String)x_MeetingID) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Key Word</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_KeyWord" size="30" maxlength="50" value="<%= HTMLEncode((String)x_KeyWord) %>"></span>&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="ADD">
</form>
<%@ include file="footer.jsp" %>
