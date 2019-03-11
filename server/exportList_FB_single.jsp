<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="tw.org.iii.ideas.service.*,
tw.org.iii.ideas.object.*" %>
<%@ page import="org.json.JSONArray,
org.json.JSONException,
org.json.JSONObject"%>
<%
String query_type = request.getParameter("query_type").toString();
String customer_id = session.getAttribute("customer_id")==null?"1":(String)session.getAttribute("customer_id");

ibuzz_service srv = new ibuzz_service();

String dbname="";
Vector<String> fieldVector = new Vector<String>();
Vector<String> conditionFieldVector = new Vector<String>();
Vector<String> conditionFieldValueVector = new Vector<String>();
Vector<String> chtFieldName = new Vector<String>();
String filename="";
JSONArray itemJSONArr =null;
if(query_type.equals("fbPageExportList")){
	chtFieldName.add("報表名稱");
	chtFieldName.add("頁面id");
	chtFieldName.add("頁面名稱");
	chtFieldName.add("起始日期");
	chtFieldName.add("結束日期");
	chtFieldName.add("Email");
	fieldVector.add("export_name");
	fieldVector.add("page_id");
	fieldVector.add("startdate");
	fieldVector.add("enddate");
	fieldVector.add("email");
	conditionFieldVector.add("export_type");
	conditionFieldValueVector.add("1");
	filename = srv.getExportListWithLeftJoinHaveName("fb_export_list_single","fb_export_page_single","fb_crawl_list","export_id","export_id","page_id","page_id",
	chtFieldName,fieldVector,conditionFieldVector,conditionFieldValueVector,"page_name","CONVERT(export_name using big5),startdate,enddate","asc","單次報表_FB官方粉絲頁監測報表");
}
%>
<%=filename%>