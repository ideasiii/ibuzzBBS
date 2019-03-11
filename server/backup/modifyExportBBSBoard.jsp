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
String export_path = request.getParameter("export_path").toString();

ibuzz_service srv = new ibuzz_service();

Vector<String> fieldVector = new Vector<String>();
Vector<String> fieldValueVector = new Vector<String>();
Vector<String> conditionFieldVector = new Vector<String>();
Vector<String> conditionFieldValueVector = new Vector<String>();

if(oper.equals("del")){
	fieldVector.add("id");
	fieldValueVector.add(db_ID);
	srv.deleteSettings(dbname,fieldVector,fieldValueVector);
}else if(oper.equals("edit")){
	fieldVector.add("export_path");
	fieldValueVector.add(export_path);
	conditionFieldVector.add("id");
	conditionFieldValueVector.add(db_ID);
	srv.editSettings(dbname,fieldVector, fieldValueVector, conditionFieldVector,conditionFieldValueVector);
}
%>
done