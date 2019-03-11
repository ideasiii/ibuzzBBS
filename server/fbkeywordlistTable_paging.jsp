<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="tw.org.iii.ideas.service.*" %>
<%@ page import="java.util.*"%> 
<%@ page import="org.json.JSONArray,
org.json.JSONException,
org.json.JSONObject"%>
<%
String datatype = request.getParameter("datatype")==null ?"" : request.getParameter("datatype").toString();
String export_type = request.getParameter("export_type")==null ?"" : request.getParameter("export_type").toString();
int thePage=Integer.valueOf(request.getParameter("page").toString());
int limit=Integer.valueOf(request.getParameter("rows").toString());
String sidx = request.getParameter("sidx").toString();//for jqgrid table sorting
String sord = request.getParameter("sord")==null ?"asc" : request.getParameter("sord").toString();//for jqgrid table sorting
String query=request.getParameter("query")==null?"":request.getParameter("query").toString();
String searchKeyword=request.getParameter("searchKeyword")==null?"":request.getParameter("searchKeyword").toString();

if(sidx.equals("export_name")){
	   sidx = "CONVERT(export_name using big5)";
	}
	
	if(sidx.equals("export_path")){
	   sidx = "CONVERT(export_path using big5)";
	}

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
//System.out.println("sidx="+sidx+"&sord="+sord);

if(sidx.equals("category")){
	   sidx = "CONVERT(category using big5)";
}else if(sidx.equals("keyword")){
	   sidx = "CONVERT(keyword using big5)";
}
		
if(datatype.equals("fbKeywordCrawlList")){
  dbname = "fb_keyword_crawl_list";
	fieldVector.add("category");
	fieldVector.add("keyword");
	fieldVector.add("startFrom");
	
	JSONArray itemJSONArr = new JSONArray(); 
	if(query.equals("fbKeywordCrawlList_Search")){
		
    Vector<String> conditionLikeFieldVector = new Vector<String>();
		Vector<String> conditionLikeFieldValue = new Vector<String>();
		
		conditionLikeFieldVector.add("category");
		conditionLikeFieldValue.add(searchKeyword);
		
		conditionLikeFieldVector.add("keyword");
		conditionLikeFieldValue.add(searchKeyword);
		itemJSONArr = srv.getSettingsWithLike(dbname,fieldVector,conditionLikeFieldVector,conditionLikeFieldValue,
			conditionFieldVector,conditionFieldValueVector,(index-1),limit,sidx,sord);
		count = srv.getSettingsWithLikeCount(dbname,fieldVector,conditionLikeFieldVector,conditionLikeFieldValue,
			conditionFieldVector,conditionFieldValueVector);
  }else{
    itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,(index-1),limit,sidx,sord);
	  count = srv.getSettingsCount(dbname,conditionFieldVector,conditionFieldValueVector);	
  }
	for(int i=0; i<itemJSONArr.length(); i++){
		cellJSONObject = new JSONObject();
		jsonArr = new JSONArray();
		
		JSONObject itemJSON =  (JSONObject)itemJSONArr.get(i);
		jsonArr.put(index); 
		jsonArr.put(itemJSON.getString("category"));
		jsonArr.put(itemJSON.getString("keyword"));  
		//jsonArr.put(itemJSON.getString("startFrom")); 
		
		cellJSONObject.put("ID",String.valueOf(index));
		cellJSONObject.put("cell",jsonArr);
		rowJSONArr.put(cellJSONObject);
		index++;
	}
	
}else if(datatype.equals("fbKeywordExportList")){
	dbname = "fb_export_list";
	fieldVector.add("export_id");
	fieldVector.add("export_name");
	fieldVector.add("email");
	fieldVector.add("export_path");
	fieldVector.add("export_period_month");
	fieldVector.add("export_period_week");
	fieldVector.add("export_period_day");
	
	conditionFieldVector.add("export_type");
	conditionFieldValueVector.add(export_type);
	
	JSONArray itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,(index-1),limit,sidx,sord);
	count = srv.getSettingsCount(dbname,conditionFieldVector,conditionFieldValueVector);
	
	for(int i=0; i<itemJSONArr.length(); i++){
		String keywords="";
	  
		cellJSONObject = new JSONObject();
		jsonArr = new JSONArray();
		
		JSONObject itemJSON =  (JSONObject)itemJSONArr.get(i);	
	  jsonArr.put(itemJSON.getString("export_id"));
		jsonArr.put(index); 		
		
		if(export_type.equals("2")||export_type.equals("3")||export_type.equals("6")){
		   jsonArr.put(itemJSON.getString("export_name"));
		}
		System.out.println();
		dbname = "fb_export_keyword";
	  fieldVector.clear();
	  conditionFieldVector.clear();
	  conditionFieldValueVector.clear();
	  fieldVector.add("groupname");
	  fieldVector.add("keywords");
	  
	  conditionFieldVector.add("export_id");
	  conditionFieldValueVector.add(itemJSON.getString("export_id"));
	
	  JSONArray itemJSONArr_keywords = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"","");
	  //System.out.println("export_id==="+itemJSON.getString("export_id"));
	  for(int j=0; j<itemJSONArr_keywords.length(); j++){
		   JSONObject itemJSON_keywords =  (JSONObject)itemJSONArr_keywords.get(j);
		   //System.out.println(j); 
		   keywords=keywords+itemJSON_keywords.getString("groupname")+"|"+itemJSON_keywords.getString("keywords")+",";		    
		}		
		if(keywords.length()>0){
		   jsonArr.put(keywords.substring(0,keywords.length()-1));
	  }else{
	  	 jsonArr.put("");
		}
		dbname = "fb_export_page";
	  fieldVector.clear();
	  conditionFieldVector.clear();
	  conditionFieldValueVector.clear();
	  fieldVector.add("page_id");
	  
	  conditionFieldVector.add("export_id");
	  conditionFieldValueVector.add(itemJSON.getString("export_id"));
	  
	  JSONArray itemJSONArr_pageid = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"","");
	  //System.out.println("export_id==="+itemJSON.getString("export_id"));
	  String fbpageids="";
	  String fbpagenames="";
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
	     
	     if(itemJSONArr_pagename.length()>0){
	     JSONObject itemJSON_pagename =  (JSONObject)itemJSONArr_pagename.get(0);			   
			 fbpagenames = fbpagenames + itemJSON_pagename.getString("page_name").replaceAll("'","").replaceAll(",","");			   
			 //System.out.println("page_name==="+itemJSON_pagename.getString("page_name"));
			 }else{
			 fbpagenames = fbpagenames + itemJSON_pageid.getString("page_id");
			 }
			 if(j!=itemJSONArr_pageid.length()-1){
				   fbpageids=fbpageids+",";
				   fbpagenames = fbpagenames + ",";
			 }
			   
		   //System.out.println("=====================fbpageids=="+fbpageids);
		   //System.out.println("==============fbpagenames=="+fbpagenames);	  
		}
		
		jsonArr.put(fbpagenames);
		
		if(export_type.equals("2")||export_type.equals("3")||export_type.equals("6")){
		   jsonArr.put(itemJSON.getString("email")); 
		}
		if(export_type.equals("4")){
		   jsonArr.put(itemJSON.getString("export_path")); 
		}
    
		jsonArr.put(fbpageids);
		jsonArr.put(itemJSON.getString("export_period_month")); 
		jsonArr.put(itemJSON.getString("export_period_week")); 
		jsonArr.put(itemJSON.getString("export_period_day")); 
		//System.out.println("=====================fbpageids=="+fbpageids+"==========");
		
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
		   JSONArray itemJSONArr_pagename = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,sidx,sord);
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