<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="tw.org.iii.ideas.service.*,
tw.org.iii.ideas.object.*,
java.text.SimpleDateFormat" %>
<%
String oper = request.getParameter("oper").toString();
String db_ID = request.getParameter("db_ID").toString();
String dbname = request.getParameter("dbname").toString();

ibuzz_service srv = new ibuzz_service();

Vector<String> fieldVector = new Vector<String>();
Vector<String> fieldValueVector = new Vector<String>();
System.out.println("oper="+oper);
if(oper.equals("del")){
	if(dbname.equals("bbs_keyword_export_list") || dbname.equals("bbs_keyword_export_detail") || 
	dbname.equals("plurk_keyword_export_list") || dbname.equals("plurk_keyword_export_detail")){
		fieldVector.add("export_id");
	}else{
		fieldVector.add("id");
	}
	fieldValueVector.add(db_ID);
	srv.deleteSettings(dbname,fieldVector,fieldValueVector);
}else if(oper.equals("edit")){
	
}
%>
done