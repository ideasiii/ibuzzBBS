<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="tw.org.iii.ideas.service.*,
tw.org.iii.ideas.object.*,
java.text.SimpleDateFormat" %>
<%@ page import="org.json.JSONArray,
org.json.JSONException,
org.json.JSONObject"%>
<%
String oper = request.getParameter("oper").toString();
String source_type = request.getParameter("source_type").toString();
String board = request.getParameter("board")==null ?"" :request.getParameter("board").toString();
String keywordSets = request.getParameter("keywordSets")==null ?"" : java.net.URLDecoder.decode(request.getParameter("keywordSets").toString(),"UTF-8");
String export_path = request.getParameter("export_path")==null ?"" : java.net.URLDecoder.decode( request.getParameter("export_path").toString(),"UTF-8");
String customer_id = session.getAttribute("customer_id")==null?"1":(String)session.getAttribute("customer_id");
String db_ID = request.getParameter("db_ID")==null ?"" : request.getParameter("db_ID").toString();

//plurk
String category = request.getParameter("category")==null ?"" : java.net.URLDecoder.decode(request.getParameter("category").toString(),"UTF-8");
String keyword = request.getParameter("keyword")==null ?"" : java.net.URLDecoder.decode(request.getParameter("keyword").toString(),"UTF-8");
String startFrom = request.getParameter("startFrom")==null ?"" : request.getParameter("startFrom").toString();
ibuzz_service srv = new ibuzz_service();

String dbname="";
Vector<String> fieldVector = new Vector<String>();
Vector<String> fieldValueVector = new Vector<String>();
Vector<String> conditionFieldVector = new Vector<String>();
Vector<String> conditionFieldValueVector = new Vector<String>();

Calendar current = Calendar.getInstance();
SimpleDateFormat db_time_format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
if(source_type.equals("bbs")){
	if(oper.equals("add")){
		//add new keyword sets
		fieldVector.add("export_path");
		fieldVector.add("isAlive");
		fieldVector.add("customer_id");
		fieldVector.add("update_time");
		fieldVector.add("board");
		fieldValueVector.add(export_path);
		fieldValueVector.add("1");
		fieldValueVector.add(customer_id);
		fieldValueVector.add(db_time_format.format(current.getTime()));
		fieldValueVector.add(board);
		srv.addSettings("bbs_keyword_export_list",fieldVector,fieldValueVector);
		
		//get keyword set export_id
		fieldVector.clear();
		fieldVector.add("export_id");
		conditionFieldVector.add("export_path");
		conditionFieldVector.add("isAlive");
		conditionFieldVector.add("customer_id");
		conditionFieldValueVector.add(export_path);
		conditionFieldValueVector.add("1");
		conditionFieldValueVector.add(customer_id);
		JSONArray resultJSONArr = srv.getSettings("bbs_keyword_export_list", fieldVector,conditionFieldVector,
									conditionFieldValueVector, 0, 0,"","");
		JSONObject itemJSON =  (JSONObject)resultJSONArr.get(0);
		String export_id = itemJSON.getString("export_id");
		
		String[] keywordArr = keywordSets.split("Ω");
		for(int i=0; i<keywordArr.length; i++){
			fieldVector.clear();
			fieldValueVector.clear();
			fieldVector.add("export_id");
			fieldVector.add("keyword");
			fieldValueVector.add(export_id);
			fieldValueVector.add(keywordArr[i]);
			srv.addSettings("bbs_keyword_export_detail",fieldVector,fieldValueVector);
		}
	}else if(oper.equals("edit")){
		//edit export list
		fieldVector.add("export_path");
		fieldVector.add("isAlive");
		fieldVector.add("customer_id");
		fieldVector.add("update_time");
		fieldVector.add("board");		
		fieldValueVector.add(export_path);
		fieldValueVector.add("1");
		fieldValueVector.add(customer_id);
		fieldValueVector.add(db_time_format.format(current.getTime()));
		fieldValueVector.add(board);
		conditionFieldVector.add("export_id");
		conditionFieldValueVector.add(db_ID);
		srv.editSettings("bbs_keyword_export_list",fieldVector,fieldValueVector,conditionFieldVector,conditionFieldValueVector);
		
		//delete all keywords whom belong to specific export_id
		fieldVector.clear();
		fieldValueVector.clear();
		fieldVector.add("export_id");
		fieldValueVector.add(db_ID);
		srv.deleteSettings("bbs_keyword_export_detail",fieldVector,fieldValueVector);
		
		//add keyword 
		String[] keywordArr = keywordSets.split("Ω");
		for(int i=0; i<keywordArr.length; i++){
			fieldVector.clear();
			fieldValueVector.clear();
			fieldVector.add("export_id");
			fieldVector.add("keyword");
			fieldValueVector.add(db_ID);
			fieldValueVector.add(keywordArr[i]);
			srv.addSettings("bbs_keyword_export_detail",fieldVector,fieldValueVector);
		}
	}
}else if(source_type.equals("plurk_crawl")){
	if(oper.equals("add")){
		fieldVector.add("category");
		fieldVector.add("keyword");
		fieldVector.add("isRoutine");
		fieldVector.add("startFrom");
		fieldValueVector.add(category);
		fieldValueVector.add(keyword);
		fieldValueVector.add("1");
		fieldValueVector.add(startFrom);
		srv.addSettings("plurk_keyword_crawl_list",fieldVector,fieldValueVector);
	}
}else if(source_type.equals("plurk_export")){
	if(oper.equals("add")){
		//add new keyword sets
		fieldVector.add("export_path");
		fieldVector.add("customer_id");
		fieldVector.add("update_time");
		fieldValueVector.add(export_path);
		fieldValueVector.add(customer_id);
		fieldValueVector.add(db_time_format.format(current.getTime()));
		srv.addSettings("plurk_keyword_export_list",fieldVector,fieldValueVector);
		
		//get keyword set export_id
		fieldVector.clear();
		fieldVector.add("export_id");
		conditionFieldVector.add("export_path");
		conditionFieldVector.add("customer_id");
		conditionFieldValueVector.add(export_path);
		conditionFieldValueVector.add(customer_id);
		JSONArray resultJSONArr = srv.getSettings("plurk_keyword_export_list", fieldVector,conditionFieldVector,
									conditionFieldValueVector, 0, 0,"","");
		JSONObject itemJSON =  (JSONObject)resultJSONArr.get(0);
		String export_id = itemJSON.getString("export_id");
		
		String[] keywordArr = keywordSets.split(",");
		for(int i=0; i<keywordArr.length; i++){
			fieldVector.clear();
			fieldValueVector.clear();
			fieldVector.add("export_id");
			fieldVector.add("keyword");
			fieldValueVector.add(export_id);
			fieldValueVector.add(keywordArr[i]);
			srv.addSettings("plurk_keyword_export_detail",fieldVector,fieldValueVector);
		}
	}else if(oper.equals("edit")){
		//edit export list
		fieldVector.add("export_path");
		fieldVector.add("customer_id");
		fieldVector.add("update_time");
		fieldValueVector.add(export_path);
		fieldValueVector.add(customer_id);
		fieldValueVector.add(db_time_format.format(current.getTime()));
		conditionFieldVector.add("export_id");
		conditionFieldValueVector.add(db_ID);
		srv.editSettings("plurk_keyword_export_list",fieldVector,fieldValueVector,conditionFieldVector,conditionFieldValueVector);
		
		//delete all keywords whom belong to specific export_id
		fieldVector.clear();
		fieldValueVector.clear();
		fieldVector.add("export_id");
		fieldValueVector.add(db_ID);
		srv.deleteSettings("plurk_keyword_export_detail",fieldVector,fieldValueVector);
		
		//add keyword 
		String[] keywordArr = keywordSets.split(",");
		for(int i=0; i<keywordArr.length; i++){
			fieldVector.clear();
			fieldValueVector.clear();
			fieldVector.add("export_id");
			fieldVector.add("keyword");
			fieldValueVector.add(db_ID);
			fieldValueVector.add(keywordArr[i]);
			srv.addSettings("plurk_keyword_export_detail",fieldVector,fieldValueVector);
		}
	}
}

%>
done