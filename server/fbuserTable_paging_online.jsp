<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="tw.org.iii.ideas.service.*" %>
<%@ page import="java.util.*"%> 
<%@ page import="org.json.JSONArray,
org.json.JSONException,
org.json.JSONObject,
java.net.URLEncoder"%>

<%
int thePage=Integer.valueOf(request.getParameter("page").toString());
int limit=Integer.valueOf(request.getParameter("rows").toString());
String sidx = request.getParameter("sidx")==null ?"update_time" : request.getParameter("sidx").toString();//for jqgrid table sorting
String sord = request.getParameter("sord")==null ?"desc" : request.getParameter("sord").toString();//for jqgrid table sorting
if(sidx.equals("export_name")){
	   sidx = "CONVERT(export_name using big5)";
	}
System.out.println(sidx);
System.out.println(sord);
ibuzz_service srv = new ibuzz_service();

int startIndex = (thePage-1)* limit;

String dbname = "";
int count = 0;

JSONArray jsonArr = null;
JSONArray rowJSONArr = new JSONArray();
JSONObject cellJSONObject =new JSONObject();
JSONObject totalDataJSON = new JSONObject();

Vector<String> fieldVector = new Vector<String>();
Vector<String> conditionFieldVector = new Vector<String>();
Vector<String> conditionFieldValueVector = new Vector<String>();

int index=limit*(thePage-1)+1;	

dbname = "fb_export_list_online";
fieldVector.add("export_name");
fieldVector.add("page_id");
fieldVector.add("post_id");
fieldVector.add("startdate");
fieldVector.add("page_account");
fieldVector.add("content");
fieldVector.add("update_time");
	
JSONArray itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,(index-1),limit,sidx,sord);
count = srv.getSettingsCount(dbname,conditionFieldVector,conditionFieldValueVector);
	
for(int i=0; i<itemJSONArr.length(); i++){
     
     cellJSONObject = new JSONObject();
     jsonArr = new JSONArray();
		 
		 JSONObject itemJSON =  (JSONObject)itemJSONArr.get(i);	
	   dbname="facebook_pages_posts_" + itemJSON.getString("startdate").substring(0,7).replaceAll("-","_");
		 String post_id_full = itemJSON.getString("page_id")+"_"+itemJSON.getString("post_id");
		 String tablename_like = "facebook_pages_posts_likes_" + itemJSON.getString("page_id").substring(itemJSON.getString("page_id").length()-2,itemJSON.getString("page_id").length()) + "_" + itemJSON.getString("startdate").substring(0,7).replaceAll("-","_");
		 String tablename_comment = "facebook_pages_comments_" + itemJSON.getString("startdate").substring(0,7).replaceAll("-","_");;
		 String tablename_share = "facebook_pages_posts_shares";
		 String export_name = URLEncoder.encode(itemJSON.getString("export_name"), "UTF-8");
		 
		 fieldVector = new Vector<String>();
		 conditionFieldVector = new Vector<String>();
		 conditionFieldValueVector = new Vector<String>();
			
		 fieldVector.add("updatetime");
		 conditionFieldVector.add("id");
		 conditionFieldValueVector.add(itemJSON.getString("page_id")+"_"+itemJSON.getString("post_id"));
			
		 JSONArray subitemJSONArr = srv.getFBSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"","");
		 JSONObject subitemJSON =  (JSONObject)subitemJSONArr.get(0);
		 
	   jsonArr.put(String.valueOf(i+1)); 		
		 jsonArr.put(itemJSON.getString("export_name"));
		 jsonArr.put(itemJSON.getString("page_id"));
		 jsonArr.put(itemJSON.getString("post_id"));
		 jsonArr.put(itemJSON.getString("content"));	
		 jsonArr.put(itemJSON.getString("startdate").substring(0,10));
		 jsonArr.put(subitemJSON.getString("updatetime"));	
		 jsonArr.put("<a href='./server/exportList_FB_online.jsp?post_id=" + post_id_full + "&datatype=1&tablename=" + tablename_like + "&export_name=" + export_name + "&update_time=" + subitemJSON.getString("updatetime") + "'>按讚</a> <a href='./server/exportList_FB_online.jsp?post_id=" + post_id_full + "&datatype=2&tablename=" + tablename_comment + "&export_name=" + export_name + "&update_time=" + subitemJSON.getString("updatetime") + "'>留言</a> <a href='./server/exportList_FB_online.jsp?post_id=" + post_id_full + "&datatype=3&tablename=" + tablename_share + "&export_name=" + export_name + "&update_time=" + subitemJSON.getString("updatetime") + "'>分享</a>");	
		 cellJSONObject.put("ID",String.valueOf(i+1));
		 cellJSONObject.put("cell",jsonArr);
		 rowJSONArr.put(cellJSONObject);
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