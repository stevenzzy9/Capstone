<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"%>
<% Locale locale = Locale.getDefault();
response.setLocale(locale);%>
<%
boolean validpwd = false;
String escapeString = "\\\\'";
if (request.getParameter("submit") != null && ((String) request.getParameter("submit")).length() > 0) {

	// Setup variables
	String userid = request.getParameter("userid") + "";
	String passwd = request.getParameter("passwd") + "";
    if (!validpwd) {
			Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			ResultSet rs = null;
			rs = stmt.executeQuery("SELECT * FROM `user` WHERE `username` = '" + userid.replaceAll("'",escapeString) + "'");
			if (rs.next()) {
				if (rs.getString("userpassword").toUpperCase().equals(passwd.toUpperCase())) {
					session.setAttribute("project3_status_User", rs.getString("username"));
				 	session.setAttribute("project3_status_UserID", rs.getString("userid"));
					validpwd = true;
				}
			}
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
	}
	if (validpwd) {

		// Write cookies
		if (request.getParameter("rememberme") != null && ((String)request.getParameter("rememberme")).length() > 0) {
			Cookie cookie = new Cookie("project3_userid", new String(userid));
			cookie.setMaxAge(365*24*60*60);
			response.addCookie(cookie);
		}
		session.setAttribute("project3_status", "login");
		response.sendRedirect("index.jsp");
	}
}else{
	validpwd = true;
}
%>
<html>
<head>
	<title>DataBase Edit</title>
	<style type="text/css">
	<!--
 	INPUT, TEXTAREA, SELECT {font-size: large;}
	.jspmaker {font-size: large;}
	.ewTableOrderIndicator {font-family: Webdings;}
	-->
	</style>
<meta name="generator" content="JSPMaker v1.0.0.0" />
</head>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start JavaScript
function  EW_checkMyForm(EW_this) {
if  (!EW_hasValue(EW_this.userid, "TEXT" )) {
            if  (!EW_onError(EW_this, EW_this.userid, "TEXT", "Please enter user ID"))
                return false;
        }
if  (!EW_hasValue(EW_this.passwd, "PASSWORD" )) {
            if  (!EW_onError(EW_this, EW_this.passwd, "PASSWORD", "Please enter password"))
                return false;
        }
return true;
}

// end JavaScript -->
</script>
<body leftmargin="0" topmargin="0" marginheight="0" marginwidth="0">
<table border="0" cellspacing="0" cellpadding="2" align="center">
	<tr>
		<td><span class="jspmaker">DataBase Edit</span></td>
	</tr>
</table>
<% if (!validpwd) { %>
<p align="center"><span class="jspmaker" style="color: Red;">Incorrect user ID or password</span></p>
<% } %>
<%
Cookie cookie = null;
Cookie [] ar_cookie = request.getCookies();
String userid = "";
for (int i = 0; i < ar_cookie.length; i++){
	cookie = ar_cookie[i];
	if (cookie.getName().equals("project3_userid")){
		userid = (String) cookie.getValue();
	}
}
%>
<form action="login.jsp" method="post" onSubmit="return EW_checkMyForm(this);">
<table border="0" cellspacing="0" cellpadding="4" align="center">
	<tr>
		<td><span class="jspmaker">User ID</span></td>
		<td><span class="jspmaker"><input type="text" name="userid" size="20" value="<%= userid %>"></span></td>
	</tr>
	<tr>
		<td><span class="jspmaker">Password</span></td>
		<td><span class="jspmaker"><input type="password" name="passwd" size="20"></span></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><span class="jspmaker"><input type="checkbox" name="rememberme" value="true">Remember me</span></td>
	</tr>
	<tr>
		<td colspan="2" align="center"><span class="jspmaker"><input type="submit" name="submit" value="Login"></span></td>
	</tr>
</table>
</form>
<br>
</body>
</html>
