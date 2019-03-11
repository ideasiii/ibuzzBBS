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
if(query_type.equals("fbKeywordExportList")){
	String export_file="固定報表_FB廣大搜尋報表";
	if(export_type.equals("3")){
	   export_file="單次報表_FB日報表";
	}else if(export_type.equals("4")){
		 export_file="單次報表_FB關鍵字搜尋";
	}
	if(export_type.equals("2")||export_type.equals("3")){		
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
		filename = srv.getExportListWithSQL("select * from (select export_name,null as keywords,page_id,(select page_name from fb_crawl_list where page_id= b.page_id)as page_name,email from fb_export_list_single a left join  fb_export_page_single b on a.export_id=b.export_id where export_type='" + export_type + "' "
             + "UNION "
             + "select export_name,keywords,null as page_id,null as page_name,email from fb_export_list_single a left join  fb_export_keyword_single b on a.export_id=b.export_id where export_type='" + export_type + "' and keywords!='')as temptable order by export_name,keywords,page_name;",
		chtFieldName,fieldVector,export_file);
	}
}
%>
<%=filename%>