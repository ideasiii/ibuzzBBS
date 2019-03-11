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
String export_type = request.getParameter("export_type").toString();
String export_name = request.getParameter("export_name")==null ?"" : java.net.URLDecoder.decode( request.getParameter("export_name").toString(),"UTF-8");
String export_path = request.getParameter("export_path")==null ?"" : java.net.URLDecoder.decode( request.getParameter("export_path").toString(),"UTF-8");
String email = request.getParameter("email")==null ?"" : request.getParameter("email").toString();
String customer_id = session.getAttribute("customer_id")==null?"1":(String)session.getAttribute("customer_id");
String db_ID = request.getParameter("db_ID")==null ?"" : request.getParameter("db_ID").toString();
String keywords = request.getParameter("keywords")==null ?"" : java.net.URLDecoder.decode( request.getParameter("keywords").toString(),"UTF-8");

ibuzz_service srv = new ibuzz_service();

String dbname="";
Vector<String> fieldVector = new Vector<String>();
Vector<String> fieldValueVector = new Vector<String>();
Vector<String> conditionFieldVector = new Vector<String>();
Vector<String> conditionFieldValueVector = new Vector<String>();

Calendar current = Calendar.getInstance();
SimpleDateFormat db_time_format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
if(source_type.equals("fb_keyword")){
	
	if(oper.equals("add")){
		//add new fb export sets
		//fieldVector.add("export_id");
		fieldVector.add("export_name");
		fieldVector.add("customer_id");
		fieldVector.add("update_time");
		fieldVector.add("email");
		fieldVector.add("export_type");
		fieldVector.add("export_path");
		
		fieldValueVector.add(export_name);
		fieldValueVector.add(customer_id);
		fieldValueVector.add(db_time_format.format(current.getTime()));
		fieldValueVector.add(email);
		fieldValueVector.add(export_type);
		fieldValueVector.add(export_path);
		
		srv.addSettings("fb_export_list",fieldVector,fieldValueVector);
	  
	  fieldVector.clear();
		fieldVector.add("export_id");
		conditionFieldVector.add("export_name");
		conditionFieldVector.add("export_type");
		conditionFieldVector.add("email");
		conditionFieldVector.add("customer_id");
		conditionFieldVector.add("export_path");
		conditionFieldValueVector.add(export_name);
		conditionFieldValueVector.add(export_type);
		conditionFieldValueVector.add(email);
		conditionFieldValueVector.add(customer_id);
		conditionFieldValueVector.add(export_path);
		JSONArray resultJSONArr = srv.getSettings("fb_export_list", fieldVector,conditionFieldVector,
									conditionFieldValueVector, 0, 0,"update_time","desc");
										
		JSONObject itemJSON =  (JSONObject)resultJSONArr.get(0);
		String export_id = itemJSON.getString("export_id");
		System.out.println("===export_id add====="+export_id);
		//get keyword set export_id
		fieldVector.clear();
		fieldVector.add("export_id");
		fieldVector.add("keywords");
		//conditionFieldVector.add("page_id");
		System.out.println(keywords);
		String[] keyword = keywords.split(",");
		for(int i=0; i<keyword.length; i++){
			System.out.println(keyword[i]);
			fieldValueVector.clear();
			fieldValueVector.add(export_id);
			fieldValueVector.add(keyword[i]);
			srv.addSettings("fb_export_keyword",fieldVector,fieldValueVector);
		}
	}else if(oper.equals("edit")){
		//edit export list
		String export_id = request.getParameter("export_id")==null ?"" : java.net.URLDecoder.decode( request.getParameter("export_id").toString(),"UTF-8");
		
		fieldVector.add("export_name");
		fieldVector.add("customer_id");
		fieldVector.add("update_time");
		fieldVector.add("email");
		fieldVector.add("export_type");
		fieldVector.add("export_path");
		fieldValueVector.add(export_name);
		fieldValueVector.add(customer_id);
		fieldValueVector.add(db_time_format.format(current.getTime()));
		fieldValueVector.add(email);
		fieldValueVector.add(export_type);
		fieldValueVector.add(export_path);
		conditionFieldVector.add("export_id");
		conditionFieldValueVector.add(export_id);
		srv.editSettings("fb_export_list",fieldVector,fieldValueVector, conditionFieldVector,conditionFieldValueVector);
		
		System.out.println("===export_id=====xxxxxx"+export_id);
		//get keyword set export_id	
		
		fieldVector.clear();
		fieldValueVector.clear();
		fieldVector.add("export_id");
		fieldValueVector.add(export_id);			
		srv.deleteSettings("fb_export_keyword",fieldVector,fieldValueVector);		
		fieldVector.add("keywords");
		System.out.println(keywords);
		String[] keyword = keywords.split(",");
		for(int i=0; i<keyword.length; i++){
			System.out.println(keyword[i]);
			fieldValueVector.clear();
			fieldValueVector.add(export_id);
			fieldValueVector.add(keyword[i]);
			srv.addSettings("fb_export_keyword",fieldVector,fieldValueVector);
		}
		
	}
}


%>
done