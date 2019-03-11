<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="tw.org.iii.ideas.service.*" %>
<%@ page import="java.util.*"%> 
<%@ page import="org.json.JSONArray,
org.json.JSONException,
org.json.JSONObject"%>
<%
ibuzz_service srv = new ibuzz_service();

Vector<String> fieldVector = new Vector<String>();
Vector<String> conditionFieldVector = new Vector<String>();
Vector<String> conditionFieldValueVector = new Vector<String>();

String dbname = "fb_keyword_crawl_list";
fieldVector.add("category");
fieldVector.add("keyword");
JSONArray itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"category","asc");

String keywords =  java.net.URLDecoder.decode( request.getParameter("keywords").toString(),"UTF-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>IndexAsia亞洲指標</title>
<link href="css/indexasiaser.css" rel="stylesheet" type="text/css" />
<link href="css/dropdownmenu.css" rel="stylesheet" type="text/css" />
<link href="css/reset.css" rel="stylesheet" type="text/css" />
<script src="util.js" type="text/javascript"></script>

<script src="jquery-ui-1.7.2/js/jquery-1.7.2.min.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" media="screen" href="jquery-ui-1.7.2/css/ui-lightness/jquery-ui-1.8.23.custom.css" />

<link rel="stylesheet" type="text/css" media="screen" href="JQGrid/theme/ui.jqgrid.css" />
<script src="JQGrid/js/jquery.js" type="text/javascript"></script>
<script src="jquery-ui-1.7.2/js/jquery-ui-1.8.23.custom.min.js" type="text/javascript"></script>
<script src="JQGrid/js/jquery.layout.js" type="text/javascript"></script>
<script src="JQGrid/js/i18n/grid.locale-en.js" type="text/javascript"></script>
<script src="JQGrid/js/jquery.jqGrid.min.js" type="text/javascript"></script>
<script type="text/javascript">
	$.jgrid.no_legacy_api = true;
	$.jgrid.useJSON = true;
</script>
<!--multi-select-->
<script type="text/javascript" src="jquery-ui-1.7.2/js/jquery.multiselect.min.js"></script>
<link rel="stylesheet" type="text/css" media="screen" href="jquery-ui-1.7.2/css/jquery.multiselect.css" />
<script src="JQGrid/js/jquery.tablednd.js" type="text/javascript"></script>
<script src="JQGrid/js/jquery.contextmenu.js" type="text/javascript"></script>
<!--date picker-->
<script type="text/javascript" src="jquery-ui-1.8.21.custom/js/jquery-ui-timepicker-addon.js"></script>
<script type="text/javascript" src="jquery-ui-1.8.21.custom/js/jquery-ui-sliderAccess.js"></script>
<style type="text/css">
.ui-jqgrid .ui-jqgrid-title{font-size:13px;}    /*修改grid标题的字体大小*/ 

.ui-jqgrid-sortable {font-size:15px; padding-top:5px}   /*修改列名的字体大小*/ 

.ui-jqgrid tr.jqgrow td {font-size:13px; padding-top:3px} /*修改表格内容字体*/  

/* This is the style for the trigger icon. The margin-bottom value causes the icon to shift down to center it. */
.ui-datepicker-trigger {
	   margin-left:5px;
	   margin-top: 8px;
	   margin-bottom: -8px;
	  }
	  
p { padding:0 0 5px 0; }  /*added by huating 20121017*/
</style>
<script type="text/javascript">
	function loadFBKeyword(keywords){
	    var a = keywords.split(",") // Delimiter is a string
			for (var i = 0; i < a.length; i++)
			{
				//alert(a[i]);
		        
				var el = document.getElementsByName('keyword');
		    var len = el.length;
		    for(var j=0; j<len; j++)
		    {
		        if(el[j].value == a[i])
		        {
		           el[j].checked = true ;
		        }
		    }
			} 
	}
	function addFBKeyword(){
	    var keywords="";
	    var el = document.getElementsByName('keyword');
	    var len = el.length;
	    for(var i=0; i<len; i++)
	    {
	        if(el[i].checked == true)
	        {
	           keywords = keywords + el[i].value + ","; 
	        }
	    }
	    opener.document.getElementById('keywords').value=keywords.substring(0,keywords.length-1);
	    window.close();
	}
	
	function clearFBKeyword(){
	    var el = document.getElementsByName('keyword');
	    var len = el.length;
	    for(var i=0; i<len; i++)
	    {
	        if(el[i].checked == true)
	        {
	           el[i].checked = false; 
	        }
	    }
	}
	
	function selectCategoryFBPage(category_num){
	    var category_div = document.getElementById("category_"+category_num);
      var keyword_input = category_div.getElementsByTagName("input");
      for(var i=0; i<keyword_input.length; i++){
          if(document.getElementById(category_num).checked == true){
             keyword_input[i].checked = true;
          }else{
          	 keyword_input[i].checked = false;
          }
      }
	}
</script>
</head>

<body onLoad="loadFBKeyword('<%=keywords%>');">
<div id="wrapper" class="clear">
    <div id="main" style="width:700px">
	<div >
		<h2>FB擷取關鍵字列表</h2><br/>
		
		<ul class="formframe">
		<div id="fb" width="100px">
		<%
		String category="";
		int j=0;
		for(int i=0;i<itemJSONArr.length();i++){
		    JSONObject itemJSON =  (JSONObject)itemJSONArr.get(i);
		    if(!itemJSON.getString("category").equals(category)){
		    category = itemJSON.getString("category");
		%>
		    </div>
		    <%j=j+1;%>
		    <br/><br/><li><font size="4"><input type="checkbox" name="<%=j%>" id="<%=j%>" value="<%=itemJSON.getString("category")%>" onclick="selectCategoryFBPage('<%=j%>');"><%=itemJSON.getString("category")%></input></></font></></li>
		    <div id="category_<%=j%>">
		<%  }
		%>		
		    <input type="checkbox" name="keyword" id="keyword" value="<%=category%>|<%=itemJSON.getString("keyword")%>"><%=itemJSON.getString("keyword")%>&nbsp;
		<%
		    
		}%>		
		</ul>
	  <input type="button" value="送出" class="btnposition" onClick="addFBKeyword();">
	  <input type="button" value="全部清除" class="btnposition" onClick="clearFBKeyword();">
	  <input type="button" value="關閉視窗" class="btnposition" onClick="window.close();"><br/><br/><br/>	  
	</div>
</div><br/><br/>
<div id="footer"> 亞洲指標數位行銷股份有限公司版權所有 © 2012 Indexasia Digital Consulting co.,Inc. All Rights Reserved </div>
</body>
</html>

