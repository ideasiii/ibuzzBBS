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
String source_type = request.getParameter("source_type").toString();
String account = request.getParameter("account").toString();
String name =  java.net.URLDecoder.decode(request.getParameter("name").toString(),"UTF-8");
String type = request.getParameter("type").toString();
String category = java.net.URLDecoder.decode(request.getParameter("category").toString(),"UTF-8");
String theDate = request.getParameter("date")==null ?"" : request.getParameter("date").toString();
ibuzz_service srv = new ibuzz_service();

String dbname="";
String result="done";
Vector<String> fieldVector = new Vector<String>();
Vector<String> fieldValueVector = new Vector<String>();

Calendar current = Calendar.getInstance();
SimpleDateFormat db_time_format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
Pages pages = new Pages("AAAEenGLUkukBACIppZBfHbo39PedDs4vmngk1QceFTGse2sAXOrfZBTrBuK9j1v0bX0HWqPpvpZCq6eAMFZAa0iNKZCMiLSvfEnk8GDNoYgZDZD");
//Pages pages = new Pages("360681664129763|g7sDKQq9_1XU7i8sKj62x9yuY0M");
String page_id="";
if(source_type.equals("fb")){	
	dbname = "fb_crawl_list";
	try{
	   page_id = pages.getPageIDByUsername(account);
	   System.out.println("================"+page_id+"===============");
	}catch(Exception e){
	}
	if(page_id!=null){
	fieldVector.add("page_id");
	fieldVector.add("page_account");
	fieldVector.add("page_name");
	fieldVector.add("page_type");
	fieldVector.add("page_category");
	fieldVector.add("startFrom");
	fieldVector.add("update_time");	
	
	fieldValueVector.add(page_id);
	fieldValueVector.add(account);
	fieldValueVector.add(name);
	fieldValueVector.add(type);
	fieldValueVector.add(category);
	fieldValueVector.add(theDate);
	fieldValueVector.add(db_time_format.format(current.getTime()));
	
	Vector<String> FBfieldVector = new Vector<String>();
  Vector<String> FBfieldValueVector = new Vector<String>();
  
  Vector<String> FBconditionFieldVector = new Vector<String>();
  Vector<String> FBconditionValueVector = new Vector<String>();

  int count = srv.getSettingsCount(dbname,FBconditionFieldVector,FBconditionValueVector);
	//count =1000;
	if(count < 1300){		
		  
			if(type.equals("1")){
			  
			FBfieldVector = new Vector<String>();
	    FBfieldValueVector = new Vector<String>(); 
	      
	    FBconditionFieldVector = new Vector<String>();
			FBconditionValueVector = new Vector<String>();
			
			boolean isUpdateFB = true;
			FBconditionFieldVector.add("page_id");
			FBconditionValueVector.add(page_id);
			
			FBfieldVector.add("page_id");
			FBfieldVector.add("from_timestamp");  
			
			JSONArray itemJSONArr = srv.getFBSettings("campaigns_pages",FBfieldVector,FBconditionFieldVector,FBconditionValueVector,0,0,"","");
			  FBfieldVector = new Vector<String>();
		    FBfieldValueVector = new Vector<String>(); 
		      
		    FBconditionFieldVector = new Vector<String>();
				FBconditionValueVector = new Vector<String>();
			  
			  //FBfieldVector.add("campaign_id");
			  FBfieldVector.add("page_id");
			  FBfieldVector.add("from_timestamp");
			  
			  //FBfieldValueVector.add("1");
			  FBfieldValueVector.add(page_id);
			  FBfieldValueVector.add(theDate);	
			   
			if(itemJSONArr.length()>0){
			   db_time_format = new SimpleDateFormat("yyyy-MM-dd");
			   JSONObject itemJSON =  (JSONObject)itemJSONArr.get(0);
			   itemJSON.getString("from_timestamp");
			   Date date_old = db_time_format.parse(itemJSON.getString("from_timestamp"));
			   Date date_new = db_time_format.parse(theDate);
			   if(date_old.compareTo(date_new) <= 0){
			      isUpdateFB = false;			      
			   }else{
			   	  FBconditionFieldVector.add("page_id");
			      FBconditionValueVector.add(page_id);
			      srv.editFBSettings("campaigns_pages",FBfieldVector, FBfieldValueVector,FBconditionFieldVector,FBconditionValueVector);
			   }
			}else{
			   srv.addFBSettings("campaigns_pages",FBfieldVector, FBfieldValueVector);
			}
		}
		
		if(type.equals("2")){
		  			
			FBfieldVector = new Vector<String>();
	    FBfieldValueVector = new Vector<String>(); 
	      
	    FBconditionFieldVector = new Vector<String>();
			FBconditionValueVector = new Vector<String>();
			
			boolean isUpdateFB = true;
			FBconditionFieldVector.add("user_id");
			FBconditionValueVector.add(page_id);
			
			FBfieldVector.add("user_id");
			FBfieldVector.add("from_timestamp");  
			
			JSONArray itemJSONArr = srv.getFBSettings("campaigns_users",FBfieldVector,FBconditionFieldVector,FBconditionValueVector,0,0,"","");
			FBfieldVector = new Vector<String>();
		    FBfieldValueVector = new Vector<String>(); 
		      
		    FBconditionFieldVector = new Vector<String>();
				FBconditionValueVector = new Vector<String>();
				
			  //FBfieldVector.add("campaign_id");
			  FBfieldVector.add("user_id");
			  FBfieldVector.add("from_timestamp");
			  
			  //FBfieldValueVector.add("1");
			  FBfieldValueVector.add(page_id);
			  FBfieldValueVector.add(theDate);
			if(itemJSONArr.length()>0){
			   db_time_format = new SimpleDateFormat("yyyy-MM-dd");
			   JSONObject itemJSON =  (JSONObject)itemJSONArr.get(0);
			   itemJSON.getString("from_timestamp");
			   Date date_old = db_time_format.parse(itemJSON.getString("from_timestamp"));
			   Date date_new = db_time_format.parse(theDate);
			   if(date_old.compareTo(date_new) < 0){
			      isUpdateFB = false;
			   }else{
			      FBconditionFieldVector.add("user_id");
			     FBconditionValueVector.add(page_id);
			     srv.editSettings("campaigns_users",FBfieldVector, FBfieldValueVector,FBconditionFieldVector,FBconditionValueVector);
			   }
			}else{
			   srv.addFBSettings("campaigns_users",FBfieldVector, FBfieldValueVector);
			}
		}
		
		if(type.equals("3")){
		  FBfieldVector = new Vector<String>();
	    FBfieldValueVector = new Vector<String>(); 
	      
	    FBconditionFieldVector = new Vector<String>();
			FBconditionValueVector = new Vector<String>();
			
			boolean isUpdateFB = true;
			FBconditionFieldVector.add("group_id");
			FBconditionValueVector.add(page_id);
			
			FBfieldVector.add("group_id");
			FBfieldVector.add("from_timestamp");  
			
			JSONArray itemJSONArr = srv.getFBSettings("campaigns_groups",FBfieldVector,FBconditionFieldVector,FBconditionValueVector,0,0,"","");
			FBfieldVector = new Vector<String>();
		    FBfieldValueVector = new Vector<String>(); 
		      
		    FBconditionFieldVector = new Vector<String>();
				FBconditionValueVector = new Vector<String>();
				
			  //FBfieldVector.add("campaign_id");
			  FBfieldVector.add("group_id");
			  FBfieldVector.add("from_timestamp");
			  
			  //FBfieldValueVector.add("1");
			  FBfieldValueVector.add(page_id);
			  FBfieldValueVector.add(theDate);
			if(itemJSONArr.length()>0){
			   JSONObject itemJSON =  (JSONObject)itemJSONArr.get(0);
			   itemJSON.getString("from_timestamp");
			   Date date_old = db_time_format.parse(itemJSON.getString("from_timestamp"));
			   Date date_new = db_time_format.parse(theDate);
			   if(date_old.compareTo(date_new) < 0){
			      isUpdateFB = false;
			   }else{
			   	  FBconditionFieldVector.add("group_id");
			      FBconditionValueVector.add(page_id);
			      srv.editSettings("campaigns_groups",FBfieldVector, FBfieldValueVector,FBconditionFieldVector,FBconditionValueVector);
			   }
			}else{
			   srv.addFBSettings("campaigns_groups",FBfieldVector, FBfieldValueVector);
			}
		}
		   //result=count+"";
		srv.addSettings(dbname,fieldVector,fieldValueVector);
   	}else{
   	   result="已超過上限1000個";
   	}
  }else{
  	result="新增失敗";
  }
}
%>
<%=result%>
