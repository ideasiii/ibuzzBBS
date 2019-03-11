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
String query_type = request.getParameter("query_type").toString();
String keyword =  java.net.URLDecoder.decode(request.getParameter("keyword").toString(),"UTF-8");

ibuzz_service srv = new ibuzz_service();

Vector<String> fieldVector = new Vector<String>();
Vector<String> conditionFieldVector = new Vector<String>();
Vector<String> conditionFieldValueVector = new Vector<String>();

JSONArray itemJSONArr =null;
if(query_type.equals("check_fb_keyword_crawl_list")){
	String dbname = "fb_keyword_crawl_list";
	fieldVector.add("keyword");
	conditionFieldVector.add("keyword");
	conditionFieldValueVector.add(keyword);
	itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"","");
}

%>
<%=itemJSONArr%>