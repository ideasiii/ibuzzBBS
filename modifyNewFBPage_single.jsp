﻿<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="tw.org.iii.ideas.service.*,
tw.org.iii.ideas.object.*,
tw.org.iii.ideas.util.*,
java.text.SimpleDateFormat" %>
<%@ page import="org.json.JSONArray,
org.json.JSONException,
org.json.JSONObject"%>
<%
String oper = request.getParameter("oper").toString();
String source_type = request.getParameter("source_type").toString();
String fbpages = request.getParameter("fbpages").toString();
String export_name = request.getParameter("export_name")==null ?"" : java.net.URLDecoder.decode( request.getParameter("export_name").toString(),"UTF-8");
String send_email = request.getParameter("send_email")==null ?"" : request.getParameter("send_email").toString();
String customer_id = session.getAttribute("customer_id")==null?"1":(String)session.getAttribute("customer_id");
String db_ID = request.getParameter("db_ID")==null ?"" : request.getParameter("db_ID").toString();
String isassigndate = request.getParameter("isassigndate")==null ?"" : request.getParameter("isassigndate").toString();
String startdate = request.getParameter("startdate")==null ?"" : request.getParameter("startdate").toString();
String enddate = request.getParameter("enddate")==null ?"" : request.getParameter("enddate").toString();
String progress = request.getParameter("progress")==null ?"" : java.net.URLDecoder.decode(request.getParameter("progress").toString(),"UTF-8");
String result="done";

ibuzz_service srv = new ibuzz_service();

String dbname="";
Vector<String> fieldVector = new Vector<String>();
Vector<String> fieldValueVector = new Vector<String>();
Vector<String> conditionFieldVector = new Vector<String>();
Vector<String> conditionFieldValueVector = new Vector<String>();

Calendar current = Calendar.getInstance();
SimpleDateFormat db_time_format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
SimpleDateFormat time_format = new SimpleDateFormat("yyyy-MM-dd");

TimeUtil time = new TimeUtil();
if(isassigndate.equals("0")){
   startdate=time.getMonthFirstDay(time_format.format(current.getTime()),-1);
   enddate=time.getMonthLastDay(time_format.format(current.getTime()), -1);
}

if(source_type.equals("fb")||source_type.equals("fb_rank")){
	String export_type="0";
	if(source_type.equals("fb")){
	   export_type="1";
	}
	if(oper.equals("add")){
		//add new fb export sets
		//fieldVector.add("export_id");
		fieldVector.add("export_name");
		fieldVector.add("customer_id");
		fieldVector.add("update_time");
		fieldVector.add("email");
		fieldVector.add("export_type");
		fieldVector.add("isassigndate");
		fieldVector.add("startdate");
		fieldVector.add("enddate");
		fieldVector.add("progress");
		
		fieldValueVector.add(export_name);
		fieldValueVector.add(customer_id);
		fieldValueVector.add(db_time_format.format(current.getTime()));
		fieldValueVector.add(send_email);
		fieldValueVector.add(export_type);
		fieldValueVector.add(isassigndate);
		fieldValueVector.add(startdate);
		fieldValueVector.add(enddate);		    
		fieldValueVector.add("資料擷取中");
		srv.addSettings("fb_export_list_single",fieldVector,fieldValueVector);
	  
	  fieldVector.clear();
		fieldVector.add("export_id");
		conditionFieldVector.add("export_name");
		conditionFieldVector.add("export_type");
		conditionFieldVector.add("isassigndate");
		conditionFieldVector.add("email");
		conditionFieldVector.add("customer_id");
		conditionFieldValueVector.add(export_name);
		conditionFieldValueVector.add(export_type);
		conditionFieldValueVector.add(isassigndate);		
		conditionFieldValueVector.add(send_email);
		conditionFieldValueVector.add(customer_id);
		JSONArray resultJSONArr = srv.getSettings("fb_export_list_single", fieldVector,conditionFieldVector,
									conditionFieldValueVector, 0, 0,"update_time","desc");
										
		JSONObject itemJSON =  (JSONObject)resultJSONArr.get(0);
		String export_id = itemJSON.getString("export_id");
		System.out.println("===export_id add====="+export_id);
		//get keyword set export_id
		fieldVector.clear();
		fieldVector.add("export_id");
		fieldVector.add("page_id");
		//conditionFieldVector.add("page_id");
		System.out.println(fbpages);
		String[] pageids = fbpages.split(",");
		for(int i=0; i<pageids.length; i++){
			System.out.println(pageids[i]);
			fieldValueVector.clear();
			fieldValueVector.add(export_id);
			fieldValueVector.add(pageids[i]);
			srv.addSettings("fb_export_page_single",fieldVector,fieldValueVector);
		}
	}else if(oper.equals("edit")){
		//edit export list
		if(progress.equals("資料擷取中")){
			String export_id = request.getParameter("export_id")==null ?"" : java.net.URLDecoder.decode( request.getParameter("export_id").toString(),"UTF-8");
			
			fieldVector.add("export_name");
			fieldVector.add("customer_id");
			fieldVector.add("update_time");
			fieldVector.add("email");
			fieldVector.add("export_type");
			fieldVector.add("isassigndate");
			fieldVector.add("startdate");
			fieldVector.add("enddate");
			fieldValueVector.add(export_name);
			fieldValueVector.add(customer_id);
			fieldValueVector.add(db_time_format.format(current.getTime()));
			fieldValueVector.add(send_email);
			fieldValueVector.add(export_type);
			fieldValueVector.add(isassigndate);
			fieldValueVector.add(startdate);
			fieldValueVector.add(enddate);		    
			conditionFieldVector.add("export_id");
			conditionFieldValueVector.add(export_id);
			srv.editSettings("fb_export_list_single",fieldVector,fieldValueVector, conditionFieldVector,conditionFieldValueVector);
			
			//get keyword set export_id
			fieldVector.clear();
			fieldValueVector.clear();
			fieldVector.add("export_id");
			fieldValueVector.add(export_id);
			srv.deleteSettings("fb_export_page_single",fieldVector,fieldValueVector);
			String[] pageids = fbpages.split(",");
			for(int i=0; i<pageids.length; i++){
				System.out.println(pageids[i]);
				fieldVector.clear();
			  fieldValueVector.clear();
			  fieldVector.add("export_id");
			  fieldVector.add("page_id");
				fieldValueVector.add(export_id);
				fieldValueVector.add(pageids[i]);
				srv.addSettings("fb_export_page_single",fieldVector,fieldValueVector);
			}
		}else{
		  result = progress ;
		}
	}
}
%>
<%=result%>