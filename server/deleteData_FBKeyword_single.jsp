<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="tw.org.iii.ideas.service.*,
tw.org.iii.ideas.object.*,
java.text.SimpleDateFormat" %>
<%
String oper = request.getParameter("oper").toString();
String dbname = request.getParameter("dbname").toString();
String progress = request.getParameter("progress")==null ?"" : java.net.URLDecoder.decode(request.getParameter("progress").toString(),"UTF-8");
String result="done";

ibuzz_service srv = new ibuzz_service();

Vector<String> fieldVector = new Vector<String>();
Vector<String> fieldValueVector = new Vector<String>();

if(oper.equals("del")){
	if(dbname.equals("fb_export_list_single")){
	  if(progress.equals("資料擷取中")){
		  String export_id = request.getParameter("db_ID").toString();
			fieldVector.add("export_id");
			fieldValueVector.add(export_id);
			srv.deleteSettings("fb_export_keyword_single",fieldVector,fieldValueVector);
			srv.deleteSettings(dbname,fieldVector,fieldValueVector);
			srv.deleteSettings("fb_export_page_single",fieldVector,fieldValueVector);
			srv.deleteSettings(dbname,fieldVector,fieldValueVector);
		}else{
		  result = progress;
		}
	}
	
}
%>
<%=result%>