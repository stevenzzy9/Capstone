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
	response.sendRedirect("restrantlist.jsp");
	response.flushBuffer();
	return;
}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Get fields from form
Object x_RestrantName = null;
Object x_RestrantID = null;
Object x_RestrantType = null;
Object x_HitTime = null;
Object x_Location = null;
Object x_LocationDescription = null;
Object x_RestrantImage = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `restrant` WHERE `RestrantName`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("restrantlist.jsp");
			response.flushBuffer();
			return;
		}else{
			rs.first();

			// Get the field contents
			if (rs.getString("RestrantName") != null){
				x_RestrantName = rs.getString("RestrantName");
			}else{
				x_RestrantName = "";
			}
	x_RestrantID = String.valueOf(rs.getLong("RestrantID"));
			if (rs.getString("RestrantType") != null){
				x_RestrantType = rs.getString("RestrantType");
			}else{
				x_RestrantType = "";
			}
	x_HitTime = String.valueOf(rs.getLong("HitTime"));
			if (rs.getString("Location") != null){
				x_Location = rs.getString("Location");
			}else{
				x_Location = "";
			}
			if (rs.getString("LocationDescription") != null){
				x_LocationDescription = rs.getString("LocationDescription");
			}else{
				x_LocationDescription = "";
			}
			if (rs.getString("RestrantImage") != null){
				x_RestrantImage = rs.getString("RestrantImage");
			}else{
				x_RestrantImage = "";
			}
		}
		rs.close();
	}else if (a.equals("U")) {// Update

		// Get fields from form
		if (request.getParameter("x_RestrantName") != null){
			x_RestrantName = (String) request.getParameter("x_RestrantName");
		}else{
			x_RestrantName = "";
		}
		if (request.getParameter("x_RestrantID") != null){
			x_RestrantID = (String) request.getParameter("x_RestrantID");
		}else{
			x_RestrantID = "";
		}
		if (request.getParameter("x_RestrantType") != null){
			x_RestrantType = (String) request.getParameter("x_RestrantType");
		}else{
			x_RestrantType = "";
		}
		if (request.getParameter("x_HitTime") != null){
			x_HitTime = (String) request.getParameter("x_HitTime");
		}else{
			x_HitTime = "";
		}
		if (request.getParameter("x_Location") != null){
			x_Location = (String) request.getParameter("x_Location");
		}else{
			x_Location = "";
		}
		if (request.getParameter("x_LocationDescription") != null){
			x_LocationDescription = (String) request.getParameter("x_LocationDescription");
		}else{
			x_LocationDescription = "";
		}
		if (request.getParameter("x_RestrantImage") != null){
			x_RestrantImage = (String) request.getParameter("x_RestrantImage");
		}else{
			x_RestrantImage = "";
		}

		// Open record
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `restrant` WHERE `RestrantName`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("restrantlist.jsp");
			response.flushBuffer();
			return;
		}

		// Field RestrantName
		tmpfld = ((String) x_RestrantName);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("RestrantName");
		}else{
			rs.updateString("RestrantName", tmpfld);
		}

		// Field RestrantID
		tmpfld = ((String) x_RestrantID).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("RestrantID");
		} else {
			rs.updateInt("RestrantID",Integer.parseInt(tmpfld));
		}

		// Field RestrantType
		tmpfld = ((String) x_RestrantType);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("RestrantType");
		}else{
			rs.updateString("RestrantType", tmpfld);
		}

		// Field HitTime
		tmpfld = ((String) x_HitTime).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("HitTime");
		} else {
			rs.updateInt("HitTime",Integer.parseInt(tmpfld));
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

		// Field LocationDescription
		tmpfld = ((String) x_LocationDescription);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("LocationDescription");
		}else{
			rs.updateString("LocationDescription", tmpfld);
		}

		// Field RestrantImage
		tmpfld = ((String) x_RestrantImage);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("RestrantImage");
		}else{
			rs.updateString("RestrantImage", tmpfld);
		}
		rs.updateRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("restrantlist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
		out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Edit TABLE: restrant<br><br><a href="restrantlist.jsp">Back to List</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_RestrantName && !EW_hasValue(EW_this.x_RestrantName, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_RestrantName, "TEXT", "Invalid Field - Restrant Name"))
                return false; 
        }
if (EW_this.x_RestrantID && !EW_hasValue(EW_this.x_RestrantID, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_RestrantID, "TEXT", "Incorrect integer - Restrant ID"))
                return false; 
        }
if (EW_this.x_RestrantID && !EW_checkinteger(EW_this.x_RestrantID.value)) {
        if (!EW_onError(EW_this, EW_this.x_RestrantID, "TEXT", "Incorrect integer - Restrant ID"))
            return false; 
        }
if (EW_this.x_RestrantType && !EW_hasValue(EW_this.x_RestrantType, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_RestrantType, "TEXT", "Invalid Field - Restrant Type"))
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
<form onSubmit="return EW_checkMyForm(this);"  name="restrantedit" action="restrantedit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Restrant Name</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_RestrantName" size="30" maxlength="50" value="<%= HTMLEncode((String)x_RestrantName) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Restrant ID</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_RestrantID" size="30" value="<%= HTMLEncode((String)x_RestrantID) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Restrant Type</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_RestrantType" size="30" maxlength="100" value="<%= HTMLEncode((String)x_RestrantType) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Hit Time</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_HitTime" size="30" value="<%= HTMLEncode((String)x_HitTime) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Location</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Location" size="30" maxlength="100" value="<%= HTMLEncode((String)x_Location) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Location Description</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_LocationDescription" size="30" maxlength="100" value="<%= HTMLEncode((String)x_LocationDescription) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Restrant Image</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_RestrantImage" size="30" maxlength="255" value="<%= HTMLEncode((String)x_RestrantImage) %>"></span>&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="EDIT">
</form>
<%@ include file="footer.jsp" %>
