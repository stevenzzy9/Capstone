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
int displayRecs = 20;
int recRange = 10;
%>
<%
String tmpfld = null;
String escapeString = "\\\\'";
String dbwhere = "";
String masterdetailwhere = "";
String searchwhere = "";
String a_search = "";
String b_search = "";
String whereClause = "";
int startRec = 0, stopRec = 0, totalRecs = 0, recCount = 0;
%>
<%

// Get search criteria for basic search
String pSearch = request.getParameter("psearch");
String pSearchType = request.getParameter("psearchtype");
if (pSearch != null && pSearch.length() > 0) {
	pSearch = pSearch.replaceAll("'",escapeString);
	if (pSearchType != null && pSearchType.length() > 0) {
		while (pSearch.indexOf("  ") > 0) {
			pSearch = pSearch.replaceAll("  ", " ");
		}
		String [] arpSearch = pSearch.trim().split(" ");
		for (int i = 0; i < arpSearch.length; i++){
			String kw = arpSearch[i].trim();
			b_search = b_search + "(";
			b_search = b_search + "`RestrantName` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`RestrantType` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Location` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`LocationDescription` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`RestrantImage` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`RestrantName` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`RestrantType` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Location` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`LocationDescription` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`RestrantImage` LIKE '%" + pSearch + "%' OR ";
	}
}
if (b_search.length() > 4 && b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) {b_search = b_search.substring(0, b_search.length()-4);}
if (b_search.length() > 5 && b_search.substring(b_search.length()-5,b_search.length()).equals(" AND ")) {b_search = b_search.substring(0, b_search.length()-5);}
%>
<%

// Build search criteria
if (a_search != null && a_search.length() > 0) {
	searchwhere = a_search; // Advanced search
}else if (b_search != null && b_search.length() > 0) {
	searchwhere = b_search; // Basic search
}

// Save search criteria
if (searchwhere != null && searchwhere.length() > 0) {
	session.setAttribute("restrant_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("restrant_REC", new Integer(startRec));
}else{
	if (session.getAttribute("restrant_searchwhere") != null)
		searchwhere = (String) session.getAttribute("restrant_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("restrant_searchwhere", searchwhere);
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("restrant_searchwhere", searchwhere);
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("restrant_REC", new Integer(startRec));
}

// Build dbwhere
if (masterdetailwhere != null && masterdetailwhere.length() > 0) {
	dbwhere = dbwhere + "(" + masterdetailwhere + ") AND ";
}
if (searchwhere != null && searchwhere.length() > 0) {
	dbwhere = dbwhere + "(" + searchwhere + ") AND ";
}
if (dbwhere != null && dbwhere.length() > 5) {
	dbwhere = dbwhere.substring(0, dbwhere.length()-5); // Trim rightmost AND
}
%>
<%

// Load Default Order
String DefaultOrder = "";
String DefaultOrderType = "";

// No Default Filter
String DefaultFilter = "";

// Check for an Order parameter
String OrderBy = request.getParameter("order");
if (OrderBy != null && OrderBy.length() > 0) {
	if (session.getAttribute("restrant_OB") != null &&
		((String) session.getAttribute("restrant_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("restrant_OT")).equals("ASC")) {
			session.setAttribute("restrant_OT", "DESC");
		}else{
			session.setAttribute("restrant_OT", "ASC");
		}
	}else{
		session.setAttribute("restrant_OT", "ASC");
	}
	session.setAttribute("restrant_OB", OrderBy);
	session.setAttribute("restrant_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("restrant_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("restrant_OB", OrderBy);
		session.setAttribute("restrant_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `restrant`";
whereClause = "";
if (DefaultFilter.length() > 0) {
	whereClause = whereClause + "(" + DefaultFilter + ") AND ";
}
if (dbwhere.length() > 0) {
	whereClause = whereClause + "(" + dbwhere + ") AND ";
}
if (whereClause.length() > 5 && whereClause.substring(whereClause.length()-5, whereClause.length()).equals(" AND ")) {
	whereClause = whereClause.substring(0, whereClause.length()-5);
}
if (whereClause.length() > 0) {
	strsql = strsql + " WHERE " + whereClause;
}
if (OrderBy != null && OrderBy.length() > 0) {
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("restrant_OT");
}

//out.println(strsql);
rs = stmt.executeQuery(strsql);
rs.last();
totalRecs = rs.getRow();
rs.beforeFirst();
startRec = 0;
int pageno = 0;

// Check for a START parameter
if (request.getParameter("start") != null && Integer.parseInt(request.getParameter("start")) > 0) {
	startRec = Integer.parseInt(request.getParameter("start"));
	session.setAttribute("restrant_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("restrant_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("restrant_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("restrant_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("restrant_REC") != null)
		startRec = ((Integer) session.getAttribute("restrant_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("restrant_REC", new Integer(startRec));
	}
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">TABLE: restrant</span></p>
<form action="restrantlist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Quick Search (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="GO">
		&nbsp;&nbsp;<a href="restrantlist.jsp?cmd=reset">Show all</a>
		</span></td>
	</tr>
	<tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Exact phrase&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">All words&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Any word</span></td></tr>
</table>
</form>
<form method="post">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="restrantlist.jsp?order=<%= java.net.URLEncoder.encode("RestrantName","UTF-8") %>" style="color: #FFFFFF;">Restrant Name&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("RestrantName")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("restrant_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("restrant_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="restrantlist.jsp?order=<%= java.net.URLEncoder.encode("RestrantID","UTF-8") %>" style="color: #FFFFFF;">Restrant ID&nbsp;<% if (OrderBy != null && OrderBy.equals("RestrantID")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("restrant_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("restrant_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="restrantlist.jsp?order=<%= java.net.URLEncoder.encode("RestrantType","UTF-8") %>" style="color: #FFFFFF;">Restrant Type&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("RestrantType")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("restrant_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("restrant_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="restrantlist.jsp?order=<%= java.net.URLEncoder.encode("HitTime","UTF-8") %>" style="color: #FFFFFF;">Hit Time&nbsp;<% if (OrderBy != null && OrderBy.equals("HitTime")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("restrant_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("restrant_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="restrantlist.jsp?order=<%= java.net.URLEncoder.encode("Location","UTF-8") %>" style="color: #FFFFFF;">Location&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Location")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("restrant_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("restrant_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="restrantlist.jsp?order=<%= java.net.URLEncoder.encode("LocationDescription","UTF-8") %>" style="color: #FFFFFF;">Location Description&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("LocationDescription")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("restrant_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("restrant_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="restrantlist.jsp?order=<%= java.net.URLEncoder.encode("RestrantImage","UTF-8") %>" style="color: #FFFFFF;">Restrant Image&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("RestrantImage")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("restrant_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("restrant_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
<%

// Avoid starting record > total records
if (startRec > totalRecs) {
	startRec = totalRecs;
}

// Set the last record to display
stopRec = startRec + displayRecs - 1;

// Move to first record directly for performance reason
recCount = startRec - 1;
if (rs.next()) {
	rs.first();
	rs.relative(startRec - 1);
}
long recActual = 0;
if (startRec == 1)
   rs.beforeFirst();
else
   rs.previous();
while (rs.next() && recCount < stopRec) {
	recCount++;
	if (recCount >= startRec) {
		recActual++;
%>
<%
	String bgcolor = "#FFFFFF"; // Set row color
%>
<%
	if (recCount%2 != 0) { // Display alternate color for rows
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

	// Load Key for record
	String key = "";
	if(rs.getString("RestrantName") != null){
		key = rs.getString("RestrantName");
	}

	// RestrantName
	if (rs.getString("RestrantName") != null){
		x_RestrantName = rs.getString("RestrantName");
	}else{
		x_RestrantName = "";
	}

	// RestrantID
	x_RestrantID = String.valueOf(rs.getLong("RestrantID"));

	// RestrantType
	if (rs.getString("RestrantType") != null){
		x_RestrantType = rs.getString("RestrantType");
	}else{
		x_RestrantType = "";
	}

	// HitTime
	x_HitTime = String.valueOf(rs.getLong("HitTime"));

	// Location
	if (rs.getString("Location") != null){
		x_Location = rs.getString("Location");
	}else{
		x_Location = "";
	}

	// LocationDescription
	if (rs.getString("LocationDescription") != null){
		x_LocationDescription = rs.getString("LocationDescription");
	}else{
		x_LocationDescription = "";
	}

	// RestrantImage
	if (rs.getString("RestrantImage") != null){
		x_RestrantImage = rs.getString("RestrantImage");
	}else{
		x_RestrantImage = "";
	}
%>
	<tr bgcolor="<%= bgcolor %>">
		<td><span class="jspmaker"><% out.print(x_RestrantName); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_RestrantID); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_RestrantType); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_HitTime); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_Location); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_LocationDescription); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_RestrantImage); %></span>&nbsp;</td>
<td><span class="jspmaker"><a href="<% key =  rs.getString("RestrantName"); 
if (key != null && key.length() > 0) { 
	out.print("restrantview.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">View</a></span></td>
<td><span class="jspmaker"><a href="<% key =  rs.getString("RestrantName"); 
if (key != null && key.length() > 0) { 
	out.print("restrantedit.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Edit</a></span></td>
<td><span class="jspmaker"><a href="<% key =  rs.getString("RestrantName"); 
if (key != null && key.length() > 0) { 
	out.print("restrantadd.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Copy</a></span></td>
<td><span class="jspmaker"><a href="<% key =  rs.getString("RestrantName"); 
if (key != null && key.length() > 0) { 
	out.print("restrantdelete.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Delete</a></span></td>
	</tr>
<%

//	}
}
}
%>
</table>
</form>
<%

// Close recordset and connection
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
<table border="0" cellspacing="0" cellpadding="10"><tr><td>
<%
boolean rsEof = false;
if (totalRecs > 0) {
	rsEof = (totalRecs < (startRec + displayRecs));
	int PrevStart = startRec - displayRecs;
	if (PrevStart < 1) { PrevStart = 1;}
	int NextStart = startRec + displayRecs;
	if (NextStart > totalRecs) { NextStart = startRec;}
	int LastStart = ((totalRecs-1)/displayRecs)*displayRecs+1;
	%>
<form>
	<table border="0" cellspacing="0" cellpadding="0"><tr><td><span class="jspmaker">Page</span>&nbsp;</td>
<!--first page button-->
	<% if (startRec==1) { %>
	<td><img src="images/firstdisab.gif" alt="First" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="restrantlist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="restrantlist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="restrantlist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="restrantlist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
	<% } %>
	<td><a href="restrantadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a></td>
	<td><span class="jspmaker">&nbsp;of <%=(totalRecs-1)/displayRecs+1%></span></td>
	</td></tr></table>
</form>
	<% if (startRec > totalRecs) { startRec = totalRecs;}
	stopRec = startRec + displayRecs - 1;
	recCount = totalRecs - 1;
	if (rsEof) { recCount = totalRecs;}
	if (stopRec > recCount) { stopRec = recCount;} %>
	<span class="jspmaker">Records <%= startRec %> to <%= stopRec %> of <%= totalRecs %></span>
<% }else{ %>
	<span class="jspmaker">No records found</span>
<p>
<a href="restrantadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>
