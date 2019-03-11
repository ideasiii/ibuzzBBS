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
String board = request.getParameter("board").toString();
String export_path = request.getParameter("export_path")==null ?"" : java.net.URLDecoder.decode(request.getParameter("export_path").toString(),"UTF-8");
String startFrom = request.getParameter("date")==null ?"" : request.getParameter("date").toString();
String customer_id = session.getAttribute("customer_id")==null?"1":(String)session.getAttribute("customer_id");
String db_ID = request.getParameter("db_ID")==null ?"" : request.getParameter("db_ID").toString();
String transferTime = request.getParameter("transferTime")==null ?"" : request.getParameter("transferTime").toString();

ibuzz_service srv = new ibuzz_service();

String dbname="";
Vector<String> fieldVector = new Vector<String>();
Vector<String> fieldValueVector = new Vector<String>();
Vector<String> conditionFieldVector = new Vector<String>();
Vector<String> conditionFieldValueVector = new Vector<String>();

String isDone = "false";
Calendar current = Calendar.getInstance();
SimpleDateFormat db_time_format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
SimpleDateFormat date_format = new SimpleDateFormat("yyyy-MM-dd");
if(source_type.equals("bbs")){
	dbname = "bbs_board_export_list";
	if(oper.equals("add")){
		//check if it is exist in export list
		fieldVector.add("id");
		conditionFieldVector.add("board");
		conditionFieldValueVector.add(board);
		JSONArray itemJSONArr = new JSONArray();
		itemJSONArr = srv.getSettings(dbname,fieldVector,
			conditionFieldVector,conditionFieldValueVector, 0,0,"","");
		if(itemJSONArr.length()>0){
			isDone = "already";
		}else{
			fieldVector.clear();
			fieldValueVector.clear();
			fieldVector.add("board");
			fieldVector.add("export_path");
			fieldVector.add("isAlive");
			fieldVector.add("customer_id");
			fieldVector.add("update_time");
			fieldValueVector.add(board);
			fieldValueVector.add(export_path);
			fieldValueVector.add("1");
			fieldValueVector.add(customer_id);
			fieldValueVector.add(db_time_format.format(current.getTime()));
			
			String isRoutine = "0";
			if(date_format.format(current.getTime()).equals(startFrom) || startFrom.length()==0){
				isRoutine = "1";
			}
			if(startFrom.length() >0){
				fieldVector.add("startFrom");
				fieldValueVector.add(startFrom);
			}
			fieldVector.add("isRoutine");
			fieldValueVector.add(isRoutine);
			
			fieldVector.add("parent_folder");
			if(transferTime.equals("01:30")){
				fieldValueVector.add("first/");
			}else{
				fieldValueVector.add("second/");
			}
			isDone = "true";
		}
	}else if(oper.equals("edit")){
		fieldVector.add("board");
		fieldVector.add("export_path");
		fieldValueVector.add(board);
		fieldValueVector.add(export_path);
		
		fieldVector.add("parent_folder");
		if(transferTime.equals("01:30")){
			fieldValueVector.add("first/");
		}else{
			fieldValueVector.add("second/");
		}
		conditionFieldVector.add("id");
		conditionFieldValueVector.add(db_ID);
		isDone = "true";
	}
}

if(oper.equals("add")){
	srv.addSettings(dbname,fieldVector,fieldValueVector);
}else if(oper.equals("edit")){
	srv.editSettings(dbname,fieldVector, fieldValueVector, conditionFieldVector,conditionFieldValueVector);
}
%>
<%=isDone%>