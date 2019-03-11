<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="tw.org.iii.ideas.service.*,
java.text.SimpleDateFormat" %>
<%
String source_type = request.getParameter("source_type").toString();
String board = request.getParameter("board").toString();
String theDate = request.getParameter("date")==null ?"" : request.getParameter("date").toString();

ibuzz_service srv = new ibuzz_service();

String dbname="";
Vector<String> fieldVector = new Vector<String>();
Vector<String> fieldValueVector = new Vector<String>();


Calendar current = Calendar.getInstance();
SimpleDateFormat db_time_format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
if(source_type.equals("bbs")){
	dbname = "bbs_crawl_list";
	fieldVector.add("board");
	fieldVector.add("crawl_type_id");
	fieldVector.add("startFrom");
	fieldVector.add("isRoutine");
	fieldVector.add("update_pastday");
	fieldVector.add("resource");
	fieldVector.add("update_time");
	fieldValueVector.add(board);
	fieldValueVector.add("1");
	fieldValueVector.add(theDate);
	fieldValueVector.add("0");
	fieldValueVector.add("4");//預設回溯四天
	fieldValueVector.add("1");//resource 預設為1
	fieldValueVector.add(db_time_format.format(current.getTime()));
}

srv.addSettings(dbname,fieldVector,fieldValueVector);
%>
done