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
	response.sendRedirect("movielist.jsp");
	response.flushBuffer();
	return;
}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Get fields from form
Object x_MovieName = null;
Object x_MovieID = null;
Object x_MovieType = null;
Object x_MovieTime = null;
Object x_HitTime = null;
Object x_TheaterName = null;
Object x_Location = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `movie` WHERE `MovieName`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("movielist.jsp");
			response.flushBuffer();
			return;
		}else{
			rs.first();

			// Get the field contents
			if (rs.getString("MovieName") != null){
				x_MovieName = rs.getString("MovieName");
			}else{
				x_MovieName = "";
			}
	x_MovieID = String.valueOf(rs.getLong("MovieID"));
			if (rs.getString("MovieType") != null){
				x_MovieType = rs.getString("MovieType");
			}else{
				x_MovieType = "";
			}
			if (rs.getString("MovieTime") != null){
				x_MovieTime = rs.getString("MovieTime");
			}else{
				x_MovieTime = "";
			}
	x_HitTime = String.valueOf(rs.getLong("HitTime"));
			if (rs.getString("TheaterName") != null){
				x_TheaterName = rs.getString("TheaterName");
			}else{
				x_TheaterName = "";
			}
			if (rs.getString("Location") != null){
				x_Location = rs.getString("Location");
			}else{
				x_Location = "";
			}
		}
		rs.close();
	}else if (a.equals("U")) {// Update

		// Get fields from form
		if (request.getParameter("x_MovieName") != null){
			x_MovieName = (String) request.getParameter("x_MovieName");
		}else{
			x_MovieName = "";
		}
		if (request.getParameter("x_MovieID") != null){
			x_MovieID = (String) request.getParameter("x_MovieID");
		}else{
			x_MovieID = "";
		}
		if (request.getParameter("x_MovieType") != null){
			x_MovieType = (String) request.getParameter("x_MovieType");
		}else{
			x_MovieType = "";
		}
		if (request.getParameter("x_MovieTime") != null){
			x_MovieTime = (String) request.getParameter("x_MovieTime");
		}else{
			x_MovieTime = "";
		}
		if (request.getParameter("x_HitTime") != null){
			x_HitTime = (String) request.getParameter("x_HitTime");
		}else{
			x_HitTime = "";
		}
		if (request.getParameter("x_TheaterName") != null){
			x_TheaterName = (String) request.getParameter("x_TheaterName");
		}else{
			x_TheaterName = "";
		}
		if (request.getParameter("x_Location") != null){
			x_Location = (String) request.getParameter("x_Location");
		}else{
			x_Location = "";
		}

		// Open record
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `movie` WHERE `MovieName`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("movielist.jsp");
			response.flushBuffer();
			return;
		}

		// Field MovieName
		tmpfld = ((String) x_MovieName);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("MovieName");
		}else{
			rs.updateString("MovieName", tmpfld);
		}

		// Field MovieID
		tmpfld = ((String) x_MovieID).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("MovieID");
		} else {
			rs.updateInt("MovieID",Integer.parseInt(tmpfld));
		}

		// Field MovieType
		tmpfld = ((String) x_MovieType);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("MovieType");
		}else{
			rs.updateString("MovieType", tmpfld);
		}

		// Field MovieTime
		tmpfld = ((String) x_MovieTime);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("MovieTime");
		}else{
			rs.updateString("MovieTime", tmpfld);
		}

		// Field HitTime
		tmpfld = ((String) x_HitTime).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("HitTime");
		} else {
			rs.updateInt("HitTime",Integer.parseInt(tmpfld));
		}

		// Field TheaterName
		tmpfld = ((String) x_TheaterName);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("TheaterName");
		}else{
			rs.updateString("TheaterName", tmpfld);
		}

		// Field Location
		tmpfld = ((String) x_Location);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Location");
		}else{
			rs.updateString("Location", tmpfld);
		}
		rs.updateRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("movielist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
		out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Edit TABLE: movie<br><br><a href="movielist.jsp">Back to List</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_MovieName && !EW_hasValue(EW_this.x_MovieName, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_MovieName, "TEXT", "Invalid Field - Movie Name"))
                return false; 
        }
if (EW_this.x_MovieID && !EW_hasValue(EW_this.x_MovieID, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_MovieID, "TEXT", "Incorrect integer - Movie ID"))
                return false; 
        }
if (EW_this.x_MovieID && !EW_checkinteger(EW_this.x_MovieID.value)) {
        if (!EW_onError(EW_this, EW_this.x_MovieID, "TEXT", "Incorrect integer - Movie ID"))
            return false; 
        }
if (EW_this.x_MovieType && !EW_hasValue(EW_this.x_MovieType, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_MovieType, "TEXT", "Invalid Field - Movie Type"))
                return false; 
        }
if (EW_this.x_MovieTime && !EW_hasValue(EW_this.x_MovieTime, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_MovieTime, "TEXT", "Invalid Field - Movie Time"))
                return false; 
        }
if (EW_this.x_HitTime && !EW_checkinteger(EW_this.x_HitTime.value)) {
        if (!EW_onError(EW_this, EW_this.x_HitTime, "TEXT", "Incorrect integer - Hit Time"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="movieedit" action="movieedit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Movie Name</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_MovieName" size="30" maxlength="50" value="<%= HTMLEncode((String)x_MovieName) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Movie ID</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_MovieID" size="30" value="<%= HTMLEncode((String)x_MovieID) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Movie Type</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_MovieType" size="30" maxlength="100" value="<%= HTMLEncode((String)x_MovieType) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Movie Time</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_MovieTime" size="30" maxlength="255" value="<%= HTMLEncode((String)x_MovieTime) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Hit Time</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_HitTime" size="30" value="<%= HTMLEncode((String)x_HitTime) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Theater Name</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_TheaterName" size="30" maxlength="100" value="<%= HTMLEncode((String)x_TheaterName) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Location</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Location" size="30" maxlength="100" value="<%= HTMLEncode((String)x_Location) %>"></span>&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="EDIT">
</form>
<%@ include file="footer.jsp" %>
