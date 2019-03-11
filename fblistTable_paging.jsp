<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="tw.org.iii.ideas.service.*" %>
<%@ page import="java.util.*"%> 
<%@ page import="org.json.JSONArray,
org.json.JSONException,
org.json.JSONObject"%>
<%
String datatype = request.getParameter("datatype").toString();
int thePage=Integer.valueOf(request.getParameter("page").toString());
int limit=Integer.valueOf(request.getParameter("rows").toString());
String sidx = request.getParameter("sidx").toString();//for jqgrid table sorting
String sord = request.getParameter("sord")==null ?"asc" : request.getParameter("sord").toString();//for jqgrid table sorting
String query=request.getParameter("query")==null?"":request.getParameter("query").toString();
String searchKeyword=request.getParameter("searchKeyword")==null?"":request.getParameter("searchKeyword").toString();
/*if(sidx.length()==0){ //for default
	sidx = "ranking";
	sord = "desc";
}else{
	sidx =  request.getParameter("sidx").toString();//for jqgrid table sorting
}*/
//System.out.println("===datatye===="+datatype);

ibuzz_service srv = new ibuzz_service();

int startIndex = (thePage-1)* limit;

String dbname = "";
int count = 0;

JSONArray jsonArr = null;
JSONObject cellJSONObject =null;
JSONArray rowJSONArr = new JSONArray();
JSONObject totalDataJSON = new JSONObject();

Vector<String> fieldVector = new Vector<String>();
Vector<String> conditionFieldVector = new Vector<String>();
Vector<String> conditionFieldValueVector = new Vector<String>();

int index=limit*(thePage-1)+1;	
System.out.println("sidx="+sidx+"&sord="+sord);
	
if(datatype.equals("fbCrawlList")){
  if(sidx.equals("pgae_category")){
		   sidx = "CONVERT(pgae_category using big5)";
	}else if(sidx.equals("page_name")){
		   sidx = "CONVERT(page_name using big5)";
	}
	
  dbname = "fb_crawl_list";
  fieldVector.add("page_category");
	fieldVector.add("page_account");
	fieldVector.add("page_name");
	fieldVector.add("page_type");
	fieldVector.add("startFrom");
	fieldVector.add("update_time");
	
	JSONArray itemJSONArr = new JSONArray();
	if(query.equals("fbCrawlList_Search")){
		
    System.out.println("fbCrawlList_Search");
    Vector<String> conditionLikeFieldVector = new Vector<String>();
		Vector<String> conditionLikeFieldValue = new Vector<String>();
		
		conditionLikeFieldVector.add("page_category");
		conditionLikeFieldValue.add(searchKeyword);
		
		conditionLikeFieldVector.add("page_name");
		conditionLikeFieldValue.add(searchKeyword);
		System.out.println("(index-1)=====" + (index-1));
		System.out.println("limit=====" + limit);
		itemJSONArr = srv.getSettingsWithLike(dbname,fieldVector,conditionLikeFieldVector,conditionLikeFieldValue,
			conditionFieldVector,conditionFieldValueVector,(index-1),limit,sidx,sord);
		count = srv.getSettingsWithLikeCount(dbname,fieldVector,conditionLikeFieldVector,conditionLikeFieldValue,
			conditionFieldVector,conditionFieldValueVector);
  }else{
    System.out.println(sidx);
    System.out.println(sord);
    itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,(index-1),limit,sidx,sord);
		count = srv.getSettingsCount(dbname,conditionFieldVector,conditionFieldValueVector);
  }
	
	for(int i=0; i<itemJSONArr.length(); i++){
		cellJSONObject = new JSONObject();
		jsonArr = new JSONArray();
		
		JSONObject itemJSON =  (JSONObject)itemJSONArr.get(i);
		jsonArr.put(index); 
		jsonArr.put(itemJSON.getString("page_category"));
		jsonArr.put(itemJSON.getString("page_name"));
		jsonArr.put(itemJSON.getString("page_account"));  
		String page_type = "";
		if(itemJSON.getString("page_type").equals("1")){
		   page_type = "粉絲頁";
		}else if(itemJSON.getString("page_type").equals("2")){
			 page_type = "個人頁面";
		}else if(itemJSON.getString("page_type").equals("3")){
			 page_type = "公開社團";
		}
		jsonArr.put(page_type); 
		jsonArr.put(itemJSON.getString("startFrom")); 
		
		cellJSONObject.put("ID",String.valueOf(index));
		cellJSONObject.put("cell",jsonArr);
		rowJSONArr.put(cellJSONObject);
		index++;
	}
	
}else if(datatype.equals("fbPageExportList")){
	
	dbname = "fb_export_list";
	fieldVector.add("export_id");
	fieldVector.add("export_name");
	fieldVector.add("email");
	
	conditionFieldVector.add("export_type");
	conditionFieldValueVector.add("1");
	
	JSONArray itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,(index-1),limit,sidx,sord);
	count = srv.getSettingsCount(dbname,conditionFieldVector,conditionFieldValueVector);	
	
	for(int i=0; i<itemJSONArr.length(); i++){
		String fbpageids="";
	  String fbpagenames="";
	
		cellJSONObject = new JSONObject();
		jsonArr = new JSONArray();
		
		JSONObject itemJSON =  (JSONObject)itemJSONArr.get(i);
		jsonArr.put(itemJSON.getString("export_id"));
		jsonArr.put(index); 		
		jsonArr.put(itemJSON.getString("export_name"));
	
		dbname = "fb_export_page";
	  fieldVector.clear();
	  conditionFieldVector.clear();
	  conditionFieldValueVector.clear();
	  fieldVector.add("page_id");
	  
	  conditionFieldVector.add("export_id");
	  conditionFieldValueVector.add(itemJSON.getString("export_id"));
	
	  JSONArray itemJSONArr_pageid = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"","");
	  //System.out.println("export_id==="+itemJSON.getString("export_id"));
	  for(int j=0; j<itemJSONArr_pageid.length(); j++){
		   JSONObject itemJSON_pageid =  (JSONObject)itemJSONArr_pageid.get(j);
		   //System.out.println(j); 
		   fbpageids=fbpageids+itemJSON_pageid.getString("page_id");
		   dbname = "fb_crawl_list";
	     fieldVector.clear();
	     conditionFieldVector.clear();
	     conditionFieldValueVector.clear();
	     fieldVector.add("page_name");
	  
	     conditionFieldVector.add("page_id");
	     conditionFieldValueVector.add(itemJSON_pageid.getString("page_id"));
		   JSONArray itemJSONArr_pagename = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"","");
	     //System.out.println("page_id===="+itemJSON_pageid.getString("page_id"));
	     
	     JSONObject itemJSON_pagename =  (JSONObject)itemJSONArr_pagename.get(0);			   
			 fbpagenames = fbpagenames + itemJSON_pagename.getString("page_name").replaceAll("'","").replaceAll(",","");			   
			 //System.out.println("page_name==="+itemJSON_pagename.getString("page_name"));
			 if(j!=itemJSONArr_pageid.length()-1){
				   fbpageids=fbpageids+",";
				   fbpagenames = fbpagenames + ",";
			 }
			   
		   //System.out.println("==fbpageids=="+fbpageids);
		   //System.out.println("==fbpagenames=="+fbpagenames);	  
		}
		
		jsonArr.put(fbpagenames);
		jsonArr.put(itemJSON.getString("email")); 
		jsonArr.put(fbpageids);
		cellJSONObject.put("ID",String.valueOf(index));
		cellJSONObject.put("cell",jsonArr);
		rowJSONArr.put(cellJSONObject);
		index++;
	}
}
else if(datatype.equals("fbRankExportList")){
	
	dbname = "fb_export_list";
	fieldVector.add("export_id");
	fieldVector.add("export_path");
	
	conditionFieldVector.add("export_type");
	conditionFieldValueVector.add("0");
	
	if(sidx.equals("export_name")){
	   sidx = "CONVERT(export_name using big5)";
	}
	
	if(sidx.equals("export_path")){
	   sidx = "CONVERT(export_path using big5)";
	}
	
	JSONArray itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,(index-1),limit,sidx,sord);
	count = srv.getSettingsCount(dbname,conditionFieldVector,conditionFieldValueVector);
	
	
	for(int i=0; i<itemJSONArr.length(); i++){
		String fbpageids="";
	  String fbpagenames="";
	
		cellJSONObject = new JSONObject();
		jsonArr = new JSONArray();
		
		JSONObject itemJSON =  (JSONObject)itemJSONArr.get(i);
		jsonArr.put(itemJSON.getString("export_id"));
		jsonArr.put(index); 		
		jsonArr.put(itemJSON.getString("export_path"));
	
		dbname = "fb_export_page";
	  fieldVector.clear();
	  conditionFieldVector.clear();
	  conditionFieldValueVector.clear();
	  fieldVector.add("page_id");
	  
	  conditionFieldVector.add("export_id");
	  conditionFieldValueVector.add(itemJSON.getString("export_id"));
	
	  JSONArray itemJSONArr_pageid = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"","");
	  //System.out.println("export_id==="+itemJSON.getString("export_id"));
	  for(int j=0; j<itemJSONArr_pageid.length(); j++){
		   JSONObject itemJSON_pageid =  (JSONObject)itemJSONArr_pageid.get(j);
		   //System.out.println(j); 
		   fbpageids=fbpageids+itemJSON_pageid.getString("page_id");
		   dbname = "fb_crawl_list";
	     fieldVector.clear();
	     conditionFieldVector.clear();
	     conditionFieldValueVector.clear();
	     fieldVector.add("page_name");
	  
	     conditionFieldVector.add("page_id");
	     conditionFieldValueVector.add(itemJSON_pageid.getString("page_id"));
		   JSONArray itemJSONArr_pagename = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"","");
	     //System.out.println("page_id===="+itemJSON_pageid.getString("page_id"));
	     
	     JSONObject itemJSON_pagename =  (JSONObject)itemJSONArr_pagename.get(0);			   
			 fbpagenames = fbpagenames + itemJSON_pagename.getString("page_name").replaceAll("'","").replaceAll(",","");			   
			 //System.out.println("page_name==="+itemJSON_pagename.getString("page_name"));
			 if(j!=itemJSONArr_pageid.length()-1){
				   fbpageids=fbpageids+",";
				   fbpagenames = fbpagenames + ",";
			 }
			   
		   //System.out.println("==fbpageids=="+fbpageids);
		   //System.out.println("==fbpagenames=="+fbpagenames);	  
		}
		
		jsonArr.put(fbpagenames);
		jsonArr.put(fbpageids);
		cellJSONObject.put("ID",String.valueOf(index));
		cellJSONObject.put("cell",jsonArr);
		rowJSONArr.put(cellJSONObject);
		index++;
	}
}

int total_pages=0;
if(count>0){
	if( count%limit != 0){
		total_pages = (count/limit)+1;
	}else{
		total_pages = count/limit;
	}
}
	
totalDataJSON.put("page",thePage);
totalDataJSON.put("total",total_pages);
totalDataJSON.put("records",count);
totalDataJSON.put("rows",rowJSONArr);



%>
<%=totalDataJSON.toString()%>