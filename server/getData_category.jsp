<%@ page language="java" contentType="application/json; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="tw.org.iii.ideas.service.*,
zz.*,
tw.org.iii.ideas.object.*,
java.text.SimpleDateFormat" %>
<%@ page import="org.json.JSONArray,
org.json.JSONException,
org.json.JSONObject"%>
<%
ibuzz_service srv = new ibuzz_service();

String dbname="";
Vector<String> fieldVector = new Vector<String>();
Vector<String> conditionFieldVector = new Vector<String>();
Vector<String> conditionFieldValueVector = new Vector<String>();

JSONArray itemJSONArr =null;
String category = java.net.URLDecoder.decode(request.getParameter("category").toString(),"UTF-8");
String type =  request.getParameter("type").toString();
dbname = "category";
fieldVector.add("category");
conditionFieldVector.add("category");
conditionFieldValueVector.add(category);
conditionFieldVector.add("type");
conditionFieldValueVector.add(type);
itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"","");
%>
<%=itemJSONArr%>