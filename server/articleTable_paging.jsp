<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="tw.org.iii.ideas.service.*" %>
<%@ page import="java.util.*"%> 
<%@ page import="org.json.JSONArray,
org.json.JSONException,
org.json.JSONObject"%>
<%
int thePage=Integer.valueOf(request.getParameter("page").toString());
int limit=Integer.valueOf(request.getParameter("rows").toString());
String sidx = request.getParameter("sidx").toString();//for jqgrid table sorting
String sord = request.getParameter("sord")==null ?"asc" : request.getParameter("sord").toString();//for jqgrid table sorting
String datatype=request.getParameter("datatype")==null?"":request.getParameter("datatype").toString();
String customer_id = session.getAttribute("customer_id")==null?"1":(String)session.getAttribute("customer_id");
String query=request.getParameter("query")==null?"":request.getParameter("query").toString();
String searchKeyword=request.getParameter("searchKeyword")==null?"":request.getParameter("searchKeyword").toString();
/*if(sidx.length()==0){ //for default
	sidx = "ranking";
	sord = "desc";
}else{
	sidx =  request.getParameter("sidx").toString();//for jqgrid table sorting
}*/

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
System.out.println("sidx="+sidx+"&sord="+sord+"&datatype="+datatype);
if(datatype.equals("bbsCrawlList")){
	if(sidx.length()==0){
		sidx = "board";
	}
	JSONArray itemJSONArr = new JSONArray();
	if(query.equals("bbs_source_search")){ //尋找版塊
		dbname = "bbs_crawl_list";
		fieldVector.add("id");
		fieldVector.add("board");
		fieldVector.add("startFrom");
		fieldVector.add("update_pastday");
		
		Vector<String> conditionLikeFieldVector = new Vector<String>();
		Vector<String> conditionLikeFieldValue = new Vector<String>();
		conditionLikeFieldVector.add("board");
		conditionLikeFieldValue.add(searchKeyword);
		
		itemJSONArr = srv.getSettingsWithLike(dbname,fieldVector,conditionLikeFieldVector,conditionLikeFieldValue,
			conditionFieldVector,conditionFieldValueVector, (index-1),limit,"","");
	//	count = itemJSONArr.length();
		count = srv.getSettingsWithLikeCount(dbname,fieldVector,conditionLikeFieldVector,conditionLikeFieldValue,
			conditionFieldVector,conditionFieldValueVector);
	}else{// 取得所有版塊
		dbname = "bbs_crawl_list";
		fieldVector.add("id");
		fieldVector.add("board");
		fieldVector.add("startFrom");
		fieldVector.add("update_pastday");
		
		itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,(index-1),limit,sidx,sord);
		count = srv.getSettingsCount(dbname,conditionFieldVector,conditionFieldValueVector);
	}
	for(int i=0; i<itemJSONArr.length(); i++){
		cellJSONObject = new JSONObject();
		jsonArr = new JSONArray();
		
		JSONObject itemJSON =  (JSONObject)itemJSONArr.get(i);
		jsonArr.put(itemJSON.getString("id")); 
		jsonArr.put(index); 
		jsonArr.put(itemJSON.getString("board")); 
		jsonArr.put(itemJSON.getString("update_pastday")); 
		jsonArr.put(itemJSON.getString("startFrom")); 
		
		cellJSONObject.put("ID",String.valueOf(index));
		cellJSONObject.put("cell",jsonArr);
		rowJSONArr.put(cellJSONObject);
		index++;
	}
	
}else if(datatype.equals("bbsExportList")){
	dbname = "bbs_board_export_list";
	if(sidx.length()==0){
		sidx = "board";
	}
	fieldVector.add("id");
	fieldVector.add("board");
	fieldVector.add("export_path");
	fieldVector.add("startFrom");
	fieldVector.add("isRoutine");
	fieldVector.add("parent_folder");
	conditionFieldVector.add("isAlive");
	conditionFieldVector.add("customer_id");
	conditionFieldValueVector.add("1");
	conditionFieldValueVector.add(customer_id);
	JSONArray itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,(index-1),limit,sidx,sord);
	count = srv.getSettingsCount(dbname,conditionFieldVector,conditionFieldValueVector);
	for(int i=0; i<itemJSONArr.length(); i++){
		cellJSONObject = new JSONObject();
		jsonArr = new JSONArray();
		
		JSONObject itemJSON =  (JSONObject)itemJSONArr.get(i);
		jsonArr.put(itemJSON.getString("id")); 
		jsonArr.put(index); 
		jsonArr.put(itemJSON.getString("board")); 
		jsonArr.put(itemJSON.getString("export_path")); 
		jsonArr.put(itemJSON.getString("startFrom")); 
		jsonArr.put(itemJSON.getString("isRoutine")); 
		if(itemJSON.getString("parent_folder").equals("first/")){
			jsonArr.put("01:30"); 
		}else{
			jsonArr.put("02:30"); 
		}
		cellJSONObject.put("ID",String.valueOf(index));
		cellJSONObject.put("cell",jsonArr);
		rowJSONArr.put(cellJSONObject);
		index++;
	}
}else if(datatype.equals("bbsKeywordExportList")){
	dbname = "bbs_keyword_export_list";
	fieldVector.add("export_id");
	fieldVector.add("export_path");
	fieldVector.add("board");
	conditionFieldVector.add("isAlive");
	conditionFieldVector.add("customer_id");
	conditionFieldValueVector.add("1");
	conditionFieldValueVector.add(customer_id);
	JSONArray itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,(index-1),limit,sidx,sord);
	count = srv.getSettingsCount(dbname,conditionFieldVector,conditionFieldValueVector);
	for(int i=0; i<itemJSONArr.length(); i++){
		cellJSONObject = new JSONObject();
		jsonArr = new JSONArray();
		
		JSONObject itemJSON =  (JSONObject)itemJSONArr.get(i);
		jsonArr.put(itemJSON.getString("export_id")); 
		jsonArr.put(index); 
		jsonArr.put(itemJSON.getString("board")); 
		jsonArr.put(itemJSON.getString("export_path")); 
		
		cellJSONObject.put("ID",String.valueOf(index));
		cellJSONObject.put("cell",jsonArr);
		rowJSONArr.put(cellJSONObject);
		index++;
	}
}else if(datatype.equals("plurkKeywordCrawlList")){
	dbname = "plurk_keyword_crawl_list";
	
	JSONArray itemJSONArr = new JSONArray();
	if(query.equals("plurk_keyword_search")){ //尋找關鍵字
		fieldVector.add("id");
		fieldVector.add("category");
		fieldVector.add("keyword");
		fieldVector.add("startFrom");
		
		Vector<String> conditionLikeFieldVector = new Vector<String>();
		Vector<String> conditionLikeFieldValue = new Vector<String>();
		conditionLikeFieldVector.add("keyword");
		conditionLikeFieldValue.add(searchKeyword);
		conditionLikeFieldVector.add("category");
		conditionLikeFieldValue.add(searchKeyword);
		itemJSONArr = srv.getSettingsWithLike(dbname,fieldVector,conditionLikeFieldVector,conditionLikeFieldValue,
			conditionFieldVector,conditionFieldValueVector,(index-1),limit,"","");
		count = srv.getSettingsWithLikeCount(dbname,fieldVector,conditionLikeFieldVector,conditionLikeFieldValue,
			conditionFieldVector,conditionFieldValueVector);
	}else{
		fieldVector.add("id");
		fieldVector.add("category");
		fieldVector.add("keyword");
		fieldVector.add("startFrom");
		itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,(index-1),limit,sidx,sord);
		count = srv.getSettingsCount(dbname,conditionFieldVector,conditionFieldValueVector);
	}
	for(int i=0; i<itemJSONArr.length(); i++){
		cellJSONObject = new JSONObject();
		jsonArr = new JSONArray();
		
		JSONObject itemJSON =  (JSONObject)itemJSONArr.get(i);
		jsonArr.put(itemJSON.getString("id")); 
		jsonArr.put(index); 
		jsonArr.put(itemJSON.getString("category")); 
		jsonArr.put(itemJSON.getString("keyword")); 
		jsonArr.put(itemJSON.getString("startFrom")); 
		
		cellJSONObject.put("ID",String.valueOf(index));
		cellJSONObject.put("cell",jsonArr);
		rowJSONArr.put(cellJSONObject);
		index++;
	}
}else if(datatype.equals("plurkKeywordExportList")){
	dbname = "plurk_keyword_export_list";
	fieldVector.add("a.export_id");
	fieldVector.add("keyword");
	fieldVector.add("export_path");
	conditionFieldVector.add("customer_id");
	conditionFieldValueVector.add("1");
	
	JSONArray itemJSONArr = srv.getSettingsWithLeftJoin("plurk_keyword_export_list", "plurk_keyword_export_detail",
			"export_id", "export_id" ,fieldVector,conditionFieldVector,conditionFieldValueVector, (index-1),limit,sidx,sord);
	
//	JSONArray itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,(index-1),limit,sidx,sord);
	count = srv.getSettingsCount(dbname,conditionFieldVector,conditionFieldValueVector);
	for(int i=0; i<itemJSONArr.length(); i++){
		cellJSONObject = new JSONObject();
		jsonArr = new JSONArray();
		
		JSONObject itemJSON =  (JSONObject)itemJSONArr.get(i);
		jsonArr.put(itemJSON.getString("export_id")); 
		jsonArr.put(index); 
		jsonArr.put(itemJSON.getString("keyword")); 
		jsonArr.put(itemJSON.getString("export_path")); 
		
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