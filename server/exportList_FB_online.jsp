
<%@ page language="java" contentType="application/vnd.ms-excel; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="tw.org.iii.ideas.service.*" %>
<%@ page import="java.util.*"%> 
<%@ page import="org.json.JSONArray,
org.json.JSONException,
org.json.JSONObject,
java.net.URLEncoder"%>
<%
String export_name = request.getParameter("export_name")==null ?"" : java.net.URLDecoder.decode( request.getParameter("export_name").toString(),"UTF-8");
String tablename = request.getParameter("tablename")==null ?"" : request.getParameter("tablename").toString();
String post_id = request.getParameter("post_id")==null ?"" : request.getParameter("post_id").toString();
String datatype = request.getParameter("datatype")==null ?"" : request.getParameter("datatype").toString();
String update_time = request.getParameter("update_time")==null ?"" : request.getParameter("update_time").toString().substring(0,16);

String sidx = "";
String sord = "";

ibuzz_service srv = new ibuzz_service();

Vector<String> fieldVector = new Vector<String>();
Vector<String> conditionFieldVector = new Vector<String>();
Vector<String> conditionFieldValueVector = new Vector<String>();

if(datatype.equals("1")){
	fieldVector.add("id");
	fieldVector.add("name");
}else if(datatype.equals("2")){
  fieldVector.add("id");
	fieldVector.add("from_id");
	fieldVector.add("from_name");
	fieldVector.add("message");
	fieldVector.add("created_time");
	fieldVector.add("likes");
	
	sidx = "created_time";
  sord = "asc";
}else if(datatype.equals("3")){
  fieldVector.add("id");
}

conditionFieldVector.add("post_id");
conditionFieldValueVector.add(post_id);

JSONArray itemJSONArr = srv.getFBSettings(tablename,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,sidx,sord);

%>
<%if(datatype.equals("1")){%>
<%response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(export_name, "UTF-8") + "(" + post_id + ")" + URLEncoder.encode("按讚清單", "UTF-8")+ "_" + update_time + ".xls"); %>
<%}%>
<%if(datatype.equals("2")){%>
<%response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(export_name, "UTF-8") + "(" + post_id + ")" + URLEncoder.encode("留言清單", "UTF-8")+ "_" + update_time + ".xls"); %>
<%}%>
<%if(datatype.equals("3")){%>
<%response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(export_name, "UTF-8") + "(" + post_id + ")" + URLEncoder.encode("分享清單", "UTF-8")+ "_" + update_time + ".xls"); %>
<%}%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<body>
	<table width="80%" border="1">
	<%if(datatype.equals("1")){%>
	<caption>
	<%=export_name%>(<%=post_id%>)按讚清單
	</caption>
	<tr><td>ID</td><td>帳號</td></tr>
	<%
	for(int i=0;i<itemJSONArr.length();i++){
		  JSONObject itemJSON =  (JSONObject)itemJSONArr.get(i);
	%>
	<tr><td><%=itemJSON.getString("id")%></td><td><%=itemJSON.getString("name")%></td></tr>
	<%}%>
	<%}%>
	<%if(datatype.equals("2")){%>
	<caption>
	<%=export_name%>(<%=post_id%>)留言清單
	</caption>
	<tr><td>ID</td><td>帳號</td><td>內容</td><td>時間</td><td>按讚數</td></tr>
	<%
	for(int i=0;i<itemJSONArr.length();i++){
		  JSONObject itemJSON =  (JSONObject)itemJSONArr.get(i);
	%>
	<tr><td><%=itemJSON.getString("from_id")%></td><td><%=itemJSON.getString("from_name")%></td><td><%=itemJSON.getString("message")%></td><td><%=itemJSON.getString("created_time")%></td><td><%=itemJSON.getString("likes")%></td></tr>
	<%}%>
	<%}%>
	<%if(datatype.equals("3")){%>
	<caption>
	<%=export_name%>(<%=post_id%>)分享清單
	</caption>
	<tr><td>ID</td></tr>
	<%
	for(int i=0;i<itemJSONArr.length();i++){
		  JSONObject itemJSON =  (JSONObject)itemJSONArr.get(i);
	%>
	<tr><td><%=itemJSON.getString("id")%></td></tr>
	<%}%>
	<%}%>
	</table>
</body>
</html>

