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
if(query_type.equals("plurk_keyword_export")){
	chtFieldName.add("關鍵字組合");
	chtFieldName.add("路徑");
	fieldVector.add("keyword");
	fieldVector.add("export_path");
	filename = srv.getExportListWithLeftJoin("plurk_keyword_export_list","plurk_keyword_export_detail","export_id","export_id",
	chtFieldName,fieldVector,conditionFieldVector,conditionFieldValueVector,"export_path","asc","固定報表_Plurk關鍵字搜尋清單");
	
}else if(query_type.equals("bbsExportList")){//20130128
	dbname = "bbs_board_export_list";
	chtFieldName.add("版塊名稱");
	chtFieldName.add("路徑");
	chtFieldName.add("資料記錄起始");
	fieldVector.add("board");
	fieldVector.add("export_path");
	fieldVector.add("startFrom");
	filename = srv.getExportList(dbname, chtFieldName,fieldVector,conditionFieldVector,conditionFieldValueVector,"board","asc","固定報表_PTT電子報清單");
}else if(query_type.equals("bbs_keyword_export")){//20130128
	chtFieldName.add("版塊名稱");
	chtFieldName.add("路徑");
	chtFieldName.add("關鍵字");
	fieldVector.add("board");
	fieldVector.add("export_path");
	fieldVector.add("keyword");
	filename = srv.getExportListWithLeftJoin("bbs_keyword_export_list","bbs_keyword_export_detail","export_id","export_id",
	chtFieldName,fieldVector,conditionFieldVector,conditionFieldValueVector,"export_path","asc","固定報表_PTT關鍵字搜尋清單");
}else if(query_type.equals("bbs_crawl_list")){//20130128
	dbname = "bbs_crawl_list";
	chtFieldName.add("版塊名稱");
	chtFieldName.add("資料回溯天數");
	chtFieldName.add("資料記錄起始");
	fieldVector.add("board");
	fieldVector.add("update_pastday");
	fieldVector.add("startFrom");
	filename = srv.getExportList(dbname, chtFieldName,fieldVector,conditionFieldVector,conditionFieldValueVector,"board","asc","設定版塊來源_PTT清單");
}else if(query_type.equals("plurk_crawl_list")){//20130128
	dbname = "plurk_keyword_crawl_list";
	chtFieldName.add("分類");
	chtFieldName.add("關鍵字");
	chtFieldName.add("資料設定起始");
	fieldVector.add("category");
	fieldVector.add("keyword");
	fieldVector.add("startFrom");
	filename = srv.getExportList(dbname, chtFieldName,fieldVector,conditionFieldVector,conditionFieldValueVector,"category","asc","設定擷取關鍵字_Plurk清單");
}

%>
<%=filename%>