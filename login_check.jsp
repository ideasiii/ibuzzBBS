<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="tw.org.iii.ideas.service.*" %>
<%@ page import="java.util.*"%> 
<%@ page import="org.json.JSONArray,
org.json.JSONException,
org.json.JSONObject"%>
<%
String account = request.getParameter("account")==null?"":request.getParameter("account").toString();
String pw = request.getParameter("pw")==null?"":request.getParameter("pw").toString();
ibuzz_service srv = new ibuzz_service();
String remoteAddr = request.getRemoteAddr();
boolean checkResult = false;
String authority ="";
String projectID="";
if(!account.equals("") && !pw.equals("")){
	JSONObject check_result = srv.checkLoginAccount(account, pw,remoteAddr);
	checkResult = check_result.getBoolean("isLogin");
	System.out.println(new Boolean(checkResult));

	if (!checkResult) {
		response.sendRedirect("login.html");
	}
}
session.setAttribute( "isLoginTag", checkResult );
session.setAttribute( "account", account );
session.setAttribute( "password", pw );
%>

<%=new Boolean(checkResult).toString()%> 