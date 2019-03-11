<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="tw.org.iii.ideas.service.*,
tw.org.iii.ideas.object.*,
java.text.SimpleDateFormat,
org.iii.ideas.pages.*,
org.json.JSONArray,
org.json.JSONException,
org.json.JSONObject" %>
<%
String export_name = request.getParameter("export_name")==null ?"" : java.net.URLDecoder.decode( request.getParameter("export_name").toString(),"UTF-8");
String page_id = request.getParameter("page_id")==null ?"" : request.getParameter("page_id").toString();
String post_id = request.getParameter("post_id")==null ?"" : request.getParameter("post_id").toString();
String startdate = request.getParameter("startdate")==null ?"" : request.getParameter("startdate").toString();
String result="done";
System.out.println("================" + export_name + "===============");
System.out.println("================" + page_id + "===============");
System.out.println("================" + post_id + "===============");
System.out.println("================" + startdate + "===============");
if(!export_name.equals("")){
		 String fb_response_token="CAAFDQVZCp9CIBAKiZAC2ATvMNoFOqYrbrgPMIgBrITRERRGtlRMf4Cyoe4sgUXiDhpqyqqhJZBugh3vk9cYM8WG4HUM082na5giuqb3KBZB3PEd89QB4pT3LWAq9wGz9CN3EehJpZB1swYLI8Gb74i8tBiwS3ZAfz2bcB2Duz3zxRMH6dqyKWD";
		 ibuzz_service srv = new ibuzz_service();
		 Vector<String> FBfieldVector = new Vector<String>();
		 Vector<String> FBconditionFieldVector = new Vector<String>();
		 Vector<String> FBconditionValueVector = new Vector<String>();
		 
		 FBfieldVector.add("response_token");
	   FBconditionFieldVector.add("can_use");
		 FBconditionValueVector.add("1");
		 JSONArray itemJSONArr = srv.getFBSettings("facebook_accesstoken",FBfieldVector,FBconditionFieldVector,FBconditionValueVector,0,0,"","");
	   if(itemJSONArr.length()>0){
			   JSONObject itemJSON =  (JSONObject)itemJSONArr.get(0);
			   fb_response_token=itemJSON.getString("response_token");
			   System.out.println(fb_response_token);
		 }
	Pages pages = new Pages(fb_response_token);
	String page_id_new="";
	try{
		 System.out.println("================start get page id===============");
		 page_id_new = pages.getPageIDByUsername(page_id);
		 System.out.println("================"+page_id_new+"===============");
	}catch(Exception e){
	}
	if(page_id_new!=null){
		
		String dbname="campaigns_pages";
		Vector<String> fieldVector = new Vector<String>();
		Vector<String> fieldValueVector = new Vector<String>();
		Vector<String> conditionFieldVector = new Vector<String>();
		Vector<String> conditionFieldValueVector = new Vector<String>();
		
		fieldVector.add("last_update_timestamp");
		
		conditionFieldVector.add("page_id");
		conditionFieldValueVector.add(page_id_new);
		
		itemJSONArr = srv.getFBSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"","");	
		if(itemJSONArr.length()>0){
			
			JSONObject itemJSON =  (JSONObject)itemJSONArr.get(0);
			String last_update_timestamp = itemJSON.getString("last_update_timestamp");
			System.out.println(last_update_timestamp);
			
			dbname="fb_export_list_online";
			fieldVector = new Vector<String>();
			fieldValueVector = new Vector<String>();
			conditionFieldVector = new Vector<String>();
			conditionFieldValueVector = new Vector<String>();
				
			fieldVector.add("export_name");
			
			conditionFieldVector.add("page_id");
			conditionFieldVector.add("post_id");
			conditionFieldValueVector.add(page_id_new);
			conditionFieldValueVector.add(post_id);
				
			itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"","");
			
			if(itemJSONArr.length()==0){
				dbname="facebook_pages_posts_" + startdate.substring(0,7).replaceAll("-","_");
			
				fieldVector = new Vector<String>();
				fieldValueVector = new Vector<String>();
				conditionFieldVector = new Vector<String>();
				conditionFieldValueVector = new Vector<String>();
				
				fieldVector.add("id");
				fieldVector.add("message");
				fieldVector.add("name");
				fieldVector.add("caption");
				fieldVector.add("description");
				
				conditionFieldVector.add("id");
				conditionFieldValueVector.add(page_id_new+"_"+post_id);
				
				itemJSONArr = srv.getFBSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"","");
				if(itemJSONArr.length()==0){
				   conditionFieldVector = new Vector<String>();
				   conditionFieldValueVector = new Vector<String>();
				   
				   conditionFieldVector.add("page_id");
				   conditionFieldValueVector.add(page_id_new);
				   
				   conditionFieldVector.add("object_id");
				   conditionFieldValueVector.add(post_id);
				
				   itemJSONArr = srv.getFBSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"","");
				}
				if(itemJSONArr.length()>0){
					itemJSON =  (JSONObject)itemJSONArr.get(0);
				  String content = itemJSON.getString("message");
				  post_id = itemJSON.getString("id").substring(itemJSON.getString("id").indexOf("_")+1,itemJSON.getString("id").length());
					
				  if(content.length()>50){
				     content = content.substring(0,50) + " ...";
				  }
					
					dbname="fb_export_list_online";
					fieldVector = new Vector<String>();
					fieldValueVector = new Vector<String>();
					conditionFieldVector = new Vector<String>();
					conditionFieldValueVector = new Vector<String>();
					
					Calendar current = Calendar.getInstance();
					SimpleDateFormat db_time_format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					
					fieldVector.add("export_name");
					fieldVector.add("page_id");
					fieldVector.add("post_id");
					fieldVector.add("startdate");
					fieldVector.add("page_account");
					fieldVector.add("content");
					fieldVector.add("update_time");
					
					fieldValueVector.add(export_name);
					fieldValueVector.add(page_id_new);
					fieldValueVector.add(post_id);
					fieldValueVector.add(startdate);
					fieldValueVector.add(page_id);
					fieldValueVector.add(content);
					fieldValueVector.add(db_time_format.format(current.getTime()));
							
					srv.addSettings(dbname,fieldVector,fieldValueVector);
				}else{
					result="沒有此文章ID，此頁面ID最後擷取資料時間為"+ last_update_timestamp + "或發文日期填寫錯誤";
				}
		  }else{
		    itemJSON =  (JSONObject)itemJSONArr.get(0);
				export_name = itemJSON.getString("export_name");
					
				result="此文章ID已新增過，報表名稱「" + export_name + "」";
		  }
			
		}else{
		  result="未設定擷取此頁面ID";
		}                      
	}else{
		result="頁面ID輸入錯誤";
	}
}else{
	result="請輸入報表名稱";
}
%>
<%=result%>