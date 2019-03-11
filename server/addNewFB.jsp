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
//String source_type = "fb";
String account = request.getParameter("account").toString();
String name =  java.net.URLDecoder.decode(request.getParameter("name").toString(),"UTF-8");
String type = request.getParameter("type").toString();
String category = java.net.URLDecoder.decode(request.getParameter("category").toString(),"UTF-8");
String back_day = request.getParameter("back_day").toString();
String theDate = request.getParameter("date")==null ?"" : request.getParameter("date").toString();
String oper = request.getParameter("oper").toString();
ibuzz_service srv = new ibuzz_service();

String dbname="";
String result="done";
Vector<String> fieldVector = new Vector<String>();
Vector<String> fieldValueVector = new Vector<String>();

Calendar current = Calendar.getInstance();
SimpleDateFormat db_time_format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String page_id="";	
//if(source_type.equals("fb")){	
//if(source_type.compareTo("fb") == 0){	
if(source_type == "fb"){	
	dbname = "fb_crawl_list";
	Vector<String> FBfieldVector = new Vector<String>();
  Vector<String> FBfieldValueVector = new Vector<String>();
  
  Vector<String> FBconditionFieldVector = new Vector<String>();
  Vector<String> FBconditionValueVector = new Vector<String>();
  //String fb_response_token="CAAFDQVZCp9CIBAKiZAC2ATvMNoFOqYrbrgPMIgBrITRERRGtlRMf4Cyoe4sgUXiDhpqyqqhJZBugh3vk9cYM8WG4HUM082na5giuqb3KBZB3PEd89QB4pT3LWAq9wGz9CN3EehJpZB1swYLI8Gb74i8tBiwS3ZAfz2bcB2Duz3zxRMH6dqyKWD";
  //String fb_response_token="360681664129763|g7sDKQq9_1XU7i8sKj62x9yuY0M";
  String fb_response_token="EAAMZCtZB6h3dIBAFdjct5ujCZBZA6lvAr44hhqD4Wcf1ZCsYXFSff4bnbe23SmRwSem09ZAQ34ifYkDcYCHxvuacrhCcIwqPeEDdQYh2MFa9c9viHfZAJihgytJstZB1YVs8skcB7MKcY6Om9i8xwqxeW0SOub0pMnsZD";
	try{
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
	   System.out.println("================start get page id===============");
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
	fieldVector.add("back_day");
	fieldVector.add("update_time");	
	
	fieldValueVector.add(page_id);
	fieldValueVector.add(account);
	fieldValueVector.add(name);
	fieldValueVector.add(type);
	fieldValueVector.add(category);
	fieldValueVector.add(theDate);
	fieldValueVector.add(back_day);
	fieldValueVector.add(db_time_format.format(current.getTime()));
	
	FBfieldVector = new Vector<String>();
  FBfieldValueVector = new Vector<String>();
  
  FBconditionFieldVector = new Vector<String>();
  FBconditionValueVector = new Vector<String>();

  int count = srv.getSettingsCount(dbname,FBconditionFieldVector,FBconditionValueVector);
	//count =1000;
	
	if(count < 1300 || oper.equals("edit")){		
		  
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
			  
			  db_time_format = new SimpleDateFormat("yyyy-MM-dd");
			  Date date = db_time_format.parse(theDate);
			  Calendar calendar = Calendar.getInstance();
			  calendar.setTime(date);
			  calendar.add( Calendar.MONTH,-1);
			  theDate=db_time_format.format(calendar.getTime());
			  //FBfieldVector.add("campaign_id");
			  FBfieldVector.add("page_id");
			  FBfieldVector.add("from_timestamp");
			  FBfieldVector.add("created_time");
			  FBfieldVector.add("back_day");
			  
			  //FBfieldValueVector.add("1");
			  FBfieldValueVector.add(page_id);
			  FBfieldValueVector.add(theDate);
			  FBfieldValueVector.add(db_time_format.format(current.getTime()));
			  FBfieldValueVector.add(back_day);
			   
			if(itemJSONArr.length()>0){
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
			  FBfieldVector.add("created_time");
			  
			  //FBfieldValueVector.add("1");
			  FBfieldValueVector.add(page_id);
			  FBfieldValueVector.add(theDate);
			  FBfieldValueVector.add(db_time_format.format(current.getTime()));
			  
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
			  FBfieldVector.add("created_time");
			  
			  //FBfieldValueVector.add("1");
			  FBfieldValueVector.add(page_id);
			  FBfieldValueVector.add(theDate);
			  FBfieldValueVector.add(db_time_format.format(current.getTime()));
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
		
		if(type.equals("4")){
		  			
			FBfieldVector = new Vector<String>();
	    FBfieldValueVector = new Vector<String>(); 
	      
	    FBconditionFieldVector = new Vector<String>();
			FBconditionValueVector = new Vector<String>();
			
			boolean isUpdateFB = true;
			FBconditionFieldVector.add("event_id");
			FBconditionValueVector.add(page_id);
			
			FBfieldVector.add("event_id");
			FBfieldVector.add("from_timestamp");  
			
			JSONArray itemJSONArr = srv.getFBSettings("campaigns_events",FBfieldVector,FBconditionFieldVector,FBconditionValueVector,0,0,"","");
			
			FBfieldVector = new Vector<String>();
		  FBfieldValueVector = new Vector<String>(); 
		      
		  FBconditionFieldVector = new Vector<String>();
			FBconditionValueVector = new Vector<String>();
				
			//FBfieldVector.add("campaign_id");
			FBfieldVector.add("event_id");
			FBfieldVector.add("from_timestamp");
			FBfieldVector.add("created_time");
			  
			  //FBfieldValueVector.add("1");
			  FBfieldValueVector.add(page_id);
			  FBfieldValueVector.add(theDate);
			  FBfieldValueVector.add(db_time_format.format(current.getTime()));  
			if(itemJSONArr.length()>0){
			   db_time_format = new SimpleDateFormat("yyyy-MM-dd");
			   JSONObject itemJSON =  (JSONObject)itemJSONArr.get(0);
			   itemJSON.getString("from_timestamp");
			   Date date_old = db_time_format.parse(itemJSON.getString("from_timestamp"));
			   Date date_new = db_time_format.parse(theDate);
			   if(date_old.compareTo(date_new) < 0){
			      isUpdateFB = false;
			   }else{
			     FBconditionFieldVector.add("event_id");
			     FBconditionValueVector.add(page_id);
			     srv.editSettings("campaigns_events",FBfieldVector, FBfieldValueVector,FBconditionFieldVector,FBconditionValueVector);
			   }
			}else{
			   srv.addFBSettings("campaigns_events",FBfieldVector, FBfieldValueVector);
			}
		}
			if(oper.equals("add")){
			   srv.addSettings(dbname,fieldVector,fieldValueVector);
			}else{
				 FBconditionFieldVector = new Vector<String>();
				 FBconditionValueVector = new Vector<String>();
					
				 FBconditionFieldVector.add("page_account");
				 FBconditionValueVector.add(account);
			   srv.editSettings(dbname,fieldVector,fieldValueVector,FBconditionFieldVector,FBconditionValueVector);
			}
   	}else{
   	   result="已超過上限1100個";
   	}
  }else{
  	result="新增失敗";
  }
}
%>
<%=result%>
