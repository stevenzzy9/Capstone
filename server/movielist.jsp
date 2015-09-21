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
			b_search = b_search + "`MovieName` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`MovieType` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`MovieTime` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`TheaterName` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Location` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`MovieName` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`MovieType` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`MovieTime` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`TheaterName` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Location` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("movie_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("movie_REC", new Integer(startRec));
}else{
	if (session.getAttribute("movie_searchwhere") != null)
		searchwhere = (String) session.getAttribute("movie_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("movie_searchwhere", searchwhere);
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("movie_searchwhere", searchwhere);
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("movie_REC", new Integer(startRec));
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
	if (session.getAttribute("movie_OB") != null &&
		((String) session.getAttribute("movie_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("movie_OT")).equals("ASC")) {
			session.setAttribute("movie_OT", "DESC");
		}else{
			session.setAttribute("movie_OT", "ASC");
		}
	}else{
		session.setAttribute("movie_OT", "ASC");
	}
	session.setAttribute("movie_OB", OrderBy);
	session.setAttribute("movie_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("movie_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("movie_OB", OrderBy);
		session.setAttribute("movie_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `movie`";
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
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("movie_OT");
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
	session.setAttribute("movie_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("movie_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("movie_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("movie_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("movie_REC") != null)
		startRec = ((Integer) session.getAttribute("movie_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("movie_REC", new Integer(startRec));
	}
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">TABLE: movie</span></p>
<form action="movielist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Quick Search (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="GO">
		&nbsp;&nbsp;<a href="movielist.jsp?cmd=reset">Show all</a>
		</span></td>
	</tr>
	<tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Exact phrase&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">All words&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Any word</span></td></tr>
</table>
</form>
<form method="post">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="movielist.jsp?order=<%= java.net.URLEncoder.encode("MovieName","UTF-8") %>" style="color: #FFFFFF;">Movie Name&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("MovieName")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("movie_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("movie_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="movielist.jsp?order=<%= java.net.URLEncoder.encode("MovieID","UTF-8") %>" style="color: #FFFFFF;">Movie ID&nbsp;<% if (OrderBy != null && OrderBy.equals("MovieID")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("movie_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("movie_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="movielist.jsp?order=<%= java.net.URLEncoder.encode("MovieType","UTF-8") %>" style="color: #FFFFFF;">Movie Type&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("MovieType")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("movie_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("movie_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="movielist.jsp?order=<%= java.net.URLEncoder.encode("MovieTime","UTF-8") %>" style="color: #FFFFFF;">Movie Time&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("MovieTime")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("movie_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("movie_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="movielist.jsp?order=<%= java.net.URLEncoder.encode("HitTime","UTF-8") %>" style="color: #FFFFFF;">Hit Time&nbsp;<% if (OrderBy != null && OrderBy.equals("HitTime")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("movie_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("movie_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="movielist.jsp?order=<%= java.net.URLEncoder.encode("TheaterName","UTF-8") %>" style="color: #FFFFFF;">Theater Name&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("TheaterName")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("movie_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("movie_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="movielist.jsp?order=<%= java.net.URLEncoder.encode("Location","UTF-8") %>" style="color: #FFFFFF;">Location&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Location")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("movie_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("movie_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
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
	String x_MovieName = "";
	String x_MovieID = "";
	String x_MovieType = "";
	String x_MovieTime = "";
	String x_HitTime = "";
	String x_TheaterName = "";
	String x_Location = "";

	// Load Key for record
	String key = "";
	if(rs.getString("MovieName") != null){
		key = rs.getString("MovieName");
	}

	// MovieName
	if (rs.getString("MovieName") != null){
		x_MovieName = rs.getString("MovieName");
	}else{
		x_MovieName = "";
	}

	// MovieID
	x_MovieID = String.valueOf(rs.getLong("MovieID"));

	// MovieType
	if (rs.getString("MovieType") != null){
		x_MovieType = rs.getString("MovieType");
	}else{
		x_MovieType = "";
	}

	// MovieTime
	if (rs.getString("MovieTime") != null){
		x_MovieTime = rs.getString("MovieTime");
	}else{
		x_MovieTime = "";
	}

	// HitTime
	x_HitTime = String.valueOf(rs.getLong("HitTime"));

	// TheaterName
	if (rs.getString("TheaterName") != null){
		x_TheaterName = rs.getString("TheaterName");
	}else{
		x_TheaterName = "";
	}

	// Location
	if (rs.getString("Location") != null){
		x_Location = rs.getString("Location");
	}else{
		x_Location = "";
	}
%>
	<tr bgcolor="<%= bgcolor %>">
		<td><span class="jspmaker"><% out.print(x_MovieName); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_MovieID); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_MovieType); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_MovieTime); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_HitTime); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_TheaterName); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_Location); %></span>&nbsp;</td>
<td><span class="jspmaker"><a href="<% key =  rs.getString("MovieName"); 
if (key != null && key.length() > 0) { 
	out.print("movieview.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">View</a></span></td>
<td><span class="jspmaker"><a href="<% key =  rs.getString("MovieName"); 
if (key != null && key.length() > 0) { 
	out.print("movieedit.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Edit</a></span></td>
<td><span class="jspmaker"><a href="<% key =  rs.getString("MovieName"); 
if (key != null && key.length() > 0) { 
	out.print("movieadd.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Copy</a></span></td>
<td><span class="jspmaker"><a href="<% key =  rs.getString("MovieName"); 
if (key != null && key.length() > 0) { 
	out.print("moviedelete.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
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
	<td><a href="movielist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="movielist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="movielist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="movielist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
	<% } %>
	<td><a href="movieadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a></td>
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
<a href="movieadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>
