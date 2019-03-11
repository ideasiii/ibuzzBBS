<%@ page language="java" contentType="application/json; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="tw.org.iii.ideas.service.*,
tw.org.iii.ideas.object.*" %>
<%@ page import="org.json.JSONArray,
org.json.JSONException,
org.json.JSONObject"%>
<%
String query_type = request.getParameter("query_type").toString();
String board = request.getParameter("board")==null?"":request.getParameter("board").toString();
String export_id = request.getParameter("export_id")==null?"":request.getParameter("export_id").toString();
String customer_id = session.getAttribute("customer_id")==null?"1":(String)session.getAttribute("customer_id");
String keyword = request.getParameter("keyword")==null?"":java.net.URLDecoder.decode(request.getParameter("keyword").toString(),"UTF-8");

ibuzz_service srv = new ibuzz_service();

String dbname="";
Vector<String> fieldVector = new Vector<String>();
Vector<String> conditionFieldVector = new Vector<String>();
Vector<String> conditionFieldValueVector = new Vector<String>();

JSONArray itemJSONArr =null;
if(query_type.equals("bbs_board_startFrom")){
	dbname = "bbs_crawl_list";
	fieldVector.add("startFrom");
	conditionFieldVector.add("board");
	conditionFieldValueVector.add(board);
	
	itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"","");
}else if(query_type.equals("bbs_board_isExist")){
	dbname = "bbs_board_export_list";
	fieldVector.add("id");
	conditionFieldVector.add("board");
	conditionFieldVector.add("customer_id");
	conditionFieldValueVector.add(board);
	conditionFieldValueVector.add(customer_id);
	
	itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"","");
}else if(query_type.equals("bbs_keyword_detail")){
	dbname = "bbs_keyword_export_detail";
	fieldVector.add("keyword");
	conditionFieldVector.add("export_id");
	conditionFieldValueVector.add(export_id);
	itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"","");
}else if(query_type.equals("check_bbs_crawl_list")){
	dbname = "bbs_crawl_list";
	fieldVector.add("id");
	conditionFieldVector.add("board");
	conditionFieldValueVector.add(board);
	itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"","");
}else if(query_type.equals("check_bbs_count")){
	dbname = "bbs_crawl_list";
	int count = srv.getSettingsCount(dbname,conditionFieldVector,conditionFieldValueVector);
	itemJSONArr  = new JSONArray();
	itemJSONArr.put(count);
}else if(query_type.equals("check_plurk_crawl_list")){
	dbname = "plurk_keyword_crawl_list";
	fieldVector.add("id");
	conditionFieldVector.add("keyword");
	conditionFieldValueVector.add(keyword);
	itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"","");
}

%>
<%=itemJSONArr%>