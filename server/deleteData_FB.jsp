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
String dbname = request.getParameter("dbname").toString();
String result = "done";

ibuzz_service srv = new ibuzz_service();

Vector<String> fieldVector = new Vector<String>();
Vector<String> fieldValueVector = new Vector<String>();

if(oper.equals("del")||oper.equals("forcedel")){
	System.out.println("oper=="+oper);
	if(dbname.equals("fb_crawl_list")){		
			Vector<String> conditionFieldVector = new Vector<String>();
      Vector<String> conditionFieldValueVector = new Vector<String>();
			String account = request.getParameter("page_account").toString();
			JSONArray itemJSONArr =null;
      dbname = "fb_crawl_list";
			fieldVector.add("page_id");
			conditionFieldVector.add("page_account");
			conditionFieldValueVector.add(account);
			itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"","");
			String page_id = new String();
			
			if(itemJSONArr!=null&&itemJSONArr.length()>0){
			   fieldVector = new Vector<String>();
         conditionFieldVector = new Vector<String>();
         conditionFieldValueVector = new Vector<String>();
			   JSONObject itemJSON_pagename =  (JSONObject) itemJSONArr.get(0);
			   page_id = itemJSON_pagename.getString("page_id");
			   dbname = "fb_export_page";
			   fieldVector.add("page_id");
			   fieldVector.add("export_id");
			   conditionFieldVector.add("page_id");
			   conditionFieldValueVector.add(page_id);
			   itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"","");
			   if(itemJSONArr!=null&&itemJSONArr.length()>0&&oper.equals("del")){
				     result = " ";
				     for(int i=0; i<itemJSONArr.length(); i++){
				         JSONObject itemJSON =  (JSONObject)itemJSONArr.get(i);
				         JSONArray itemJSONArr_1 = null;
				         fieldVector = new Vector<String>();
                 conditionFieldVector = new Vector<String>();
                 conditionFieldValueVector = new Vector<String>();
                 dbname = "fb_export_list";
			           fieldVector.add("export_type");
			           fieldVector.add("export_name");
			           fieldVector.add("export_path");
			           conditionFieldVector.add("export_id");
			           conditionFieldValueVector.add(itemJSON.getString("export_id"));
			           itemJSONArr_1 = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"","");
				         if(itemJSONArr_1!=null&&itemJSONArr_1.length() > 0){
				            itemJSON =  (JSONObject)itemJSONArr_1.get(0);
				            if(itemJSON.getString("export_type").equals("4")||itemJSON.getString("export_type").equals("0")){
				               result = result + itemJSON.getString("export_path") + "\n";
				            }else{
				               result = result + itemJSON.getString("export_name") + "\n";
				            }
				         }
				     }
				     result = "此版塊已設定固定報表，無法刪除，\n被設定固定報表清單如下：\n"  + result ;
				 }else{
				  	dbname = "fb_crawl_list";
				  	fieldVector = new Vector<String>();
				  	fieldVector.add("page_account");
				    fieldValueVector.add(account);
				    srv.deleteSettings(dbname,fieldVector,fieldValueVector);
				    dbname = "fb_export_page";
				  	fieldVector = new Vector<String>();
				  	fieldValueVector = new Vector<String>();
				  	fieldVector.add("page_id");
				    fieldValueVector.add(page_id);
				    srv.deleteSettings(dbname,fieldVector,fieldValueVector);
				    result = "刪除成功";
				 }
		  }
	}else if(dbname.equals("fb_export_list")){
	  String export_id = request.getParameter("db_ID").toString();
		fieldVector.add("export_id");
		fieldValueVector.add(export_id);
		srv.deleteSettings("fb_export_page",fieldVector,fieldValueVector);
		
		fieldVector.add("export_id");
		fieldValueVector.add(export_id);
		srv.deleteSettings("fb_export_list",fieldVector,fieldValueVector);
	}	
}
%>
<%=result%>