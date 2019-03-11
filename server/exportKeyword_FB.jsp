<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="tw.org.iii.ideas.service.*,
tw.org.iii.ideas.object.*" %>
<%@ page import="org.json.JSONArray,
org.json.JSONException,
org.json.JSONObject"%>
<%
String query_type = request.getParameter("query_type").toString();
String customer_id = session.getAttribute("customer_id")==null?"1":(String)session.getAttribute("customer_id");
String export_type = request.getParameter("export_type")==null ?"" : request.getParameter("export_type").toString();

ibuzz_service srv = new ibuzz_service();

String dbname="";
Vector<String> fieldVector = new Vector<String>();
Vector<String> conditionFieldVector = new Vector<String>();
Vector<String> conditionFieldValueVector = new Vector<String>();
Vector<String> chtFieldName = new Vector<String>();
String filename="";
JSONArray itemJSONArr =null;
if(query_type.equals("fbKeywordCrawlList")){
	chtFieldName.add("分類");
	chtFieldName.add("關鍵字");
	chtFieldName.add("資料起始日期");
	fieldVector.add("category");
	fieldVector.add("keyword");
	fieldVector.add("startfrom");
	filename = srv.getExportList("fb_keyword_crawl_list",chtFieldName,fieldVector,conditionFieldVector,conditionFieldValueVector,"CONVERT(category using big5)","asc","設定擷取關鍵字_FB");	
}else if(query_type.equals("fbKeywordExportList")){
	String export_file="固定報表_FB廣大搜尋報表";
	if(export_type.equals("3")){
	   export_file="固定報表_FB日報表";
	}else if(export_type.equals("4")){
		 export_file="固定報表_FB關鍵字搜尋";
	}else if(export_type.equals("6")){
		 export_file="固定報表_FB廣大搜尋群組報表";
	}
	if(export_type.equals("2")||export_type.equals("3")||export_type.equals("6")){		
		chtFieldName.add("報表名稱");
		chtFieldName.add("關鍵字");
		chtFieldName.add("頁面ID");
		chtFieldName.add("頁面名稱");
		chtFieldName.add("email");
		fieldVector.add("export_name");
		fieldVector.add("keywords");
		fieldVector.add("page_id");
		fieldVector.add("page_name");
		fieldVector.add("email");
		filename = srv.getExportListWithSQL("select * from (select export_name,null as keywords,page_id,(select page_name from fb_crawl_list where page_id= b.page_id)as page_name,email from fb_export_list a left join  fb_export_page b on a.export_id=b.export_id where export_type='" + export_type + "' "
             + "UNION "
             + "select export_name,keywords,null as page_id,null as page_name,email from fb_export_list a left join  fb_export_keyword b on a.export_id=b.export_id where export_type='" + export_type + "' and keywords!='')as temptable order by export_name,keywords,page_name;",
		chtFieldName,fieldVector,export_file);
	}else if(export_type.equals("4")){
		chtFieldName.add("匯出路徑");
		chtFieldName.add("關鍵字");
		chtFieldName.add("頁面ID");
		chtFieldName.add("頁面名稱");
		chtFieldName.add("email");
		fieldVector.add("export_path");
		fieldVector.add("keywords");
		fieldVector.add("page_id");
		fieldVector.add("page_name");
		fieldVector.add("email");
		filename = srv.getExportListWithSQL("select * from (select export_path,null as keywords,page_id,(select page_name from fb_crawl_list where page_id= b.page_id)as page_name,email from fb_export_list a left join  fb_export_page b on a.export_id=b.export_id where export_type='4'"
               + " UNION "
               + "select export_path,keywords,null as page_id,null as page_name,email from fb_export_list a left join  fb_export_keyword b on a.export_id=b.export_id where export_type='4' and keywords!='')as temptable order by export_path,keywords,page_name;",
		chtFieldName,fieldVector,"固定報表_FB廣大搜尋報表");
	}
}
%>
<%=filename%>