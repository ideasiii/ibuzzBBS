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
if(query_type.equals("fb_crawl_list")){
	chtFieldName.add("分類");
	chtFieldName.add("頁面名稱");
	chtFieldName.add("頁面帳號");
	chtFieldName.add("類別");
	chtFieldName.add("資料起始日期");
	fieldVector.add("page_category");
	fieldVector.add("page_name");
	fieldVector.add("page_account");
	fieldVector.add("page_type");
	fieldVector.add("startfrom");
	filename = srv.getExportList("fb_crawl_list",chtFieldName,fieldVector,conditionFieldVector,conditionFieldValueVector,"CONVERT(page_category using big5)","asc","設定版塊來源_FB");	
}else if(query_type.equals("fbPageExportList")){
	chtFieldName.add("報表名稱");
	chtFieldName.add("頁面id");
	chtFieldName.add("頁面名稱");
	chtFieldName.add("Email");
	fieldVector.add("export_name");
	fieldVector.add("page_id");
	fieldVector.add("email");
	conditionFieldVector.add("export_type");
	conditionFieldValueVector.add("1");
	filename = srv.getExportListWithLeftJoinHaveName("fb_export_list","fb_export_page","fb_crawl_list","export_id","export_id","page_id","page_id",
	chtFieldName,fieldVector,conditionFieldVector,conditionFieldValueVector,"page_name","CONVERT(export_name using big5)","asc","固定報表_FB官方粉絲頁監測報表");
}else if(query_type.equals("fb_crawl_list_error")){
	chtFieldName.add("分類");
	chtFieldName.add("頁面名稱");
	chtFieldName.add("頁面帳號");
	chtFieldName.add("類別");
	chtFieldName.add("資料起始日期");
	fieldVector.add("page_category");
	fieldVector.add("page_name");
	fieldVector.add("page_account");
	fieldVector.add("page_type");
	fieldVector.add("startfrom");
	filename = srv.getExportListWithSQL("select * from ibuzz.fb_crawl_list where page_id not in " + 
  "(select id from ideas_crawl_facebook.facebook_pages a join ibuzz.fb_crawl_list b on a.id=b.page_id where DATE_ADD(CURDATE(),INTERVAL -30 DAY) < updatetime "+
  "UNION "+
  "select id from ideas_crawl_facebook.facebook_groups a join ibuzz.fb_crawl_list b on a.id=b.page_id where DATE_ADD(CURDATE(),INTERVAL -3 DAY) < updatetime "+
  "UNION " +
  "select id from ideas_crawl_facebook.facebook_user a join ibuzz.fb_crawl_list b on a.id=b.page_id where DATE_ADD(CURDATE(),INTERVAL -3 DAY) < updatetime);",
		chtFieldName,fieldVector,"設定版塊來源_FB_不正常擷取");
}
%>
<%=filename%>