<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="tw.org.iii.ideas.service.*,
tw.org.iii.ideas.object.*,
java.text.SimpleDateFormat,
org.iii.ideas.pages.*,
org.json.JSONArray,
org.json.JSONException,
org.json.JSONObject" %>
<%
String category =  java.net.URLDecoder.decode(request.getParameter("category").toString(),"UTF-8");
String type =  request.getParameter("type").toString();
String oper =  java.net.URLDecoder.decode(request.getParameter("oper").toString(),"UTF-8");
ibuzz_service srv = new ibuzz_service();

String dbname="category";
String result="done";
Vector<String> fieldVector = new Vector<String>();
Vector<String> fieldValueVector = new Vector<String>();

fieldVector.add("category");
fieldVector.add("type");
fieldValueVector.add(category);
fieldValueVector.add(type);

if(oper.equals("add")){
   srv.addSettings(dbname,fieldVector,fieldValueVector);
}else{
   srv.deleteSettings(dbname,fieldVector,fieldValueVector);
}
%>
<%=result%>