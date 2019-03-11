<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="tw.org.iii.ideas.service.*,
tw.org.iii.ideas.object.*,
java.text.SimpleDateFormat,
org.iii.ideas.pages.*,
org.json.JSONArray" %>
<%
String source_type = request.getParameter("source_type").toString();
String category = java.net.URLDecoder.decode(request.getParameter("category").toString(),"UTF-8");
String keyword =  java.net.URLDecoder.decode(request.getParameter("keyword").toString(),"UTF-8");
String theDate = request.getParameter("date")==null ?"" : request.getParameter("date").toString();
ibuzz_service srv = new ibuzz_service();

String dbname="";
String result="done";
Vector<String> fieldVector = new Vector<String>();
Vector<String> fieldValueVector = new Vector<String>();

Calendar current = Calendar.getInstance();
SimpleDateFormat db_time_format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String page_id="";
if(source_type.equals("fb")){	
	
	Vector<String> FBfieldVector = new Vector<String>();
  Vector<String> FBfieldValueVector = new Vector<String>();
  
  Vector<String> FBconditionFieldVector = new Vector<String>();
  Vector<String> FBconditionValueVector = new Vector<String>();

  String[] keywords = keyword.split("AND"); //ruby 2014.09.12 改and 為 AND
  keyword="";
  System.out.println("keywords="+keywords);
	boolean isexist=false;
	for(int i=0;i<keywords.length;i++){
	    
	    String Keyword_single=keywords[i].toString().replace(" ", "");
	    
	    if(i!=keywords.length-1){
	          keyword = keyword + Keyword_single + " AND ";
	    }else{
	      	  keyword = keyword + Keyword_single ;
		  }
	    System.out.println("keyword="+keyword);
		 FBfieldVector.add("keyword");
	    FBconditionFieldVector.add("keyword");
	    FBconditionValueVector.add(keyword);
	    JSONArray itemJSONArr = srv.getFBSettings("campaigns_keywords",FBfieldVector,FBconditionFieldVector,FBconditionValueVector,0,0,"","");
		  if(itemJSONArr.length()>0){
		     isexist=true;
		  }
	}
	dbname = "fb_keyword_crawl_list";
	
	fieldVector.add("category");
	fieldVector.add("keyword");
	fieldVector.add("startFrom");
	fieldVector.add("update_time");	
	
	fieldValueVector.add(category);
	fieldValueVector.add(keyword);
	fieldValueVector.add(theDate);
	fieldValueVector.add(db_time_format.format(current.getTime()));      	  
	
  srv.addSettings(dbname,fieldVector,fieldValueVector);
  
  if(isexist==false){  
	  String Keyword_single="";
	  for(int i=0;i<keywords.length;i++){		    
		    if(Keyword_single.length() < keywords[i].toString().replace(" ", "").length()){
		       Keyword_single=keywords[i].toString().replace(" ", "");		
		    }	        
		}   
		FBfieldVector = new Vector<String>();
    FBfieldValueVector = new Vector<String>();
		
		//FBfieldVector.add("campaign_id");
	  FBfieldVector.add("keyword");
	  System.out.println("========="+Keyword_single+"==========");
		  	  
	  //FBfieldValueVector.add("2");
	  FBfieldValueVector.add(Keyword_single);
	  srv.addFBSettings("campaigns_keywords",FBfieldVector,FBfieldValueVector);	  
	  
	  System.out.println("========="+Keyword_single+"==========");
  }
}
%>
<%=result%>