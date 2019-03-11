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

String dbname = "fb_crawl_list";
fieldVector.add("page_id");
fieldVector.add("page_name");
JSONArray itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"CONVERT(page_name using big5)","asc");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
String export_type = request.getParameter("export_type").toString();
%>
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
	$(document).ready(function ()  {
		$("#menu>#nav>li:nth-child(4)").addClass("current"); //根據頁面，設定menu class=current(ex:此頁是固定報表)
		$('#remScnt').live('click', function() { 
			if( keywordInputCount > 2 ) {
					$(this).parents('p').remove();
					keywordInputCount--;
			}
			return false;
        });
	});
	function addNewFBPage(){
		var oper;
		var db_ID = $("#db_id_hidden").val();
		var month = "0";
		var week = "0";
		var day = "0";
		if(db_ID==""){
			oper = "add";
		}else{
			oper = "edit";
		}
		var selected_fb ="";
		
		var export_name = encodeURIComponent($("#export_name").val());
		var export_path = encodeURIComponent($("#export_path").val());
		if(typeof($("#export_name").val()) == 'undefined'){
			export_name = '';
		}
		if(typeof($("#export_path").val()) == 'undefined'){
			export_path = '';
		}
		if($("#month").val()!='undefined' && $("#month").attr('checked')){
			month = "1";
		}
		if($("#week").val()!='undefined' && $("#week").attr('checked')){
			week = "1";
		}
		if($("#day").val()!='undefined' && $("#day").attr('checked')){
			day = "1";
		}
		var keywords = encodeURIComponent($("#keywords").val());
	  $.post('./server/modifyNewFBKeyword.jsp', {'source_type':'fb_keyword','oper':oper,'export_id':db_ID,'export_type':'<%=export_type%>','export_name':export_name,'keywords':keywords,'email':$("#email").val(),'export_path':export_path,'fbpages':$("#page_ids").val(),
			                                         'month':month,'week':week,'day':day},
		function(result) {
				result = trim(result);
				if(result=="done"){
					alert("更新完成");
					if(oper=="edit"){
					   $("#article_list").jqGrid('setGridParam',{datatype:'json'}).trigger('reloadGrid');
				  }else if(oper=="add"){
					   $("#article_list").jqGrid('setGridParam',{datatype:'json',sortname: 'update_time',sortorder: 'desc'}).trigger('reloadGrid');
					   $("span.s-ico",jQuery("#article_list").jqGrid.hDiv).hide();
				  }
					refreshField();
				}else{
					alert("更新失敗");
				}
			}	
			
		);
	};
	function refreshField(){	
		
		$("#page_ids").val('');
		$("#page_accounts").val('');
		$("#export_path").val('');		
		$("#export_name").val('');
		$("#email").val('');
		$("#keywords").val('');
		$("#db_id_hidden").val('');
		if($("#month").attr('checked')==false){
		   $('#month').click();
	  }
		if($("#week").attr('checked')==true){
		   $('#week').click();
	  }
	  if($("#day").attr('checked')==true){
		   $('#day').click();
	  }
		$("#addBtn").val('新增');
		$("#clearBtn").hide();
	};
	function exportList(){
		$.post('./server/exportKeyword_FB.jsp', {'query_type':"fbKeywordExportList",'export_type':"<%=export_type%>"},
			function(file_path) {
			//	alert(file_path);
				document.location.href = file_path;
			}
		);
	};
	/*function setCalendarMinDate(theDate){
		minDate = new Date(theDate);
		//minDate.setDate(minDate.getDate()-120);
		alert("minDate.getFullYear()="+minDate.getFullYear()+"&"+minDate.getMonth()+"&"+minDate.getDate());
		var pickerOpts = {
			dateFormat: 'yy-mm-dd',
			minDate: new Date(minDate.getFullYear() , minDate.getMonth(),  minDate.getDate()),
			buttonImage: "images/calendar_red.png",
			buttonImageOnly: true,
			showOn: "button"
		};  
		$("#startDate").datepicker(pickerOpts);
	};*/
</script>
</head>

<body>
<div id="wrapper" class="clear">
	<jsp:include page="menubar.jsp" />
    <div id="main">
	<div>
		<%
		if(export_type.equals("2")){
		%>
		<h2>固定報表：FB廣大搜尋報表</h2>
		<%}%>
		<%
		if(export_type.equals("6")){
		%>
		<h2>固定報表：FB廣大搜尋群組報表</h2>
		<%}%>
		<%
		if(export_type.equals("3")){
		%>
		<h2>固定報表：FB日報表</h2>
		<%}%>
		<%
		if(export_type.equals("4")){
		%>
		<h2>固定報表：FB關鍵字搜尋</h2>
		<%}%>
		<input type="button" value="匯出全部" class="btnposition" style="margin-top:-20px" onClick="exportList()" /></br>
		<div style="padding-left:30px;position:relative;z-index:2">
			<table id="article_list"></table>
			<div id="article_pagered"></div>
	    </div><br/>
		<ul class="formframe">
		<div id="fb">
		<input type="hidden" id="db_id_hidden" name="db_id_hidden" value="" />
		<li>週期：<br/>
		 <%
		    if(export_type.equals("2")||export_type.equals("6")){
		 %>
			一個月一次&nbsp;&nbsp;統計區間：上月1號至該月最後一天&nbsp;&nbsp;匯出時間:每月3號<br/>
		 <%}%>
		 <%
		    if(export_type.equals("3")){
		 %>
			<input type="checkbox" name="month" id="month" checked >一個月一次&nbsp;&nbsp;統計區間：上月1號至該月最後一天&nbsp;&nbsp;匯出時間:每月3號<br/>
			<input type="checkbox" name="week" id="week">一週一次&nbsp;&nbsp;統計區間：上週一至該週日&nbsp;&nbsp;匯出時間:每週一<br/>
			<input type="checkbox" name="day" id="day">一天一次&nbsp;&nbsp;統計區間：前一天 00:00~24:00&nbsp;&nbsp;匯出時間:每天<br/>
		 <%}%>
		 <%
		    if(export_type.equals("4")){
		 %>
			一日三次&nbsp;&nbsp;匯出時間:每日07:00、15:00、23:00<br/>
		 <%}%>
		</li>
		<li>請選擇關鍵字組合(多選)：<input type="button" value="選擇" onclick="window.open('keyword_list.jsp?keywords='+document.getElementById('keywords').value, 'newWin', config='height=500,width=800,scrollbars=yes')">
		<textarea name="keywords" id="keywords" value="" rows="4" cols="80" disabled></textarea>
		</li>
		<%
		//if(export_type.equals("4")||export_type.equals("3")){
		%>
		<li>請選擇Facebook頁面(多選)：<input type="button" value="選擇" onclick="window.open('page_list.jsp?page_ids='+document.getElementById('page_ids').value, 'newWin', config='height=500,width=800,scrollbars=yes')">
		<textarea name="page_accounts" id="page_accounts" value="" rows="4" cols="80" disabled></textarea>
		</li>	
		<%//}%>
		<%
		if(export_type.equals("2")||export_type.equals("3")||export_type.equals("6")){
		%>
		<li>請輸入報表名稱：
		<input type="text" id="export_name" name="export_name" size="60" />ex:機車專案
		</li>
		<li>請輸入Email：
		<input type="text" id="email" name="email" size="60" />(若有多組請用分號;區隔)
		</li>
		<%}%>
		<%
		if(export_type.equals("4")){
		%>
		<li>請輸入路徑：
		<input type="text" id="export_path" name="export_path" size="60" /><br/>
		ex:voc online plus/XML/SmartPhone/Apple/
		</li>
		<%}%>
		</ul>
		<input id="page_ids" name="page_ids" value="" type="hidden" />
	  <input id="addBtn" type="button" value="新增" class="btnposition" onClick="addNewFBPage();">
	  <input id="clearBtn" type="button" value="清空" class="btnposition" onClick="refreshField()"><br/><br/><br/>	  
	</div>
</div><br/><br/>
<div id="footer"> 亞洲指標數位行銷股份有限公司版權所有 © 2012 Indexasia Digital Consulting co.,Inc. All Rights Reserved </div>

</body>
</html>
<script type="text/javascript">
	if(!Array.indexOf){
	  Array.prototype.indexOf = function(obj){
	  for(var i=0; i<this.length; i++){
		if(this[i]==obj){
		 return i;
		}
		  }
		  return -1;
		 }
	}
	$("#clearBtn").hide();
	jQuery("#article_list").jqGrid({      
		url:"./server/fbkeywordlistTable_paging.jsp?datatype=fbKeywordExportList&q=2&export_type=<%=export_type%>", 
		datatype: "json",
	//datatype: "local",
		height: 260,
		  <%
		    if(export_type.equals("2")||export_type.equals("3")||export_type.equals("6")){
		  %>
		  colNames:['ID','No','報表名稱','關鍵字組合','頁面名稱','email','page_ids','export_period_month','export_period_week','export_period_day'], //欄位名稱
		  <%}%>
		  <%
		    if(export_type.equals("4")){
		  %>
		  colNames:['ID','No','關鍵字組合','頁面名稱','匯出路徑','page_ids','export_period_month','export_period_week','export_period_day'], //欄位名稱
		  <%}%>
   		colModel:[
			{name:'ID',index:'ID', width:20, sorttype:"int", editable: false, hidden:true},
			{name:'No',index:'No', width:20, sorttype:"int", editable: false,align:"center",sortable:false},
			<%
		    if(export_type.equals("2")||export_type.equals("3")||export_type.equals("6")){
		  %>
			{name:'export_name',index:'export_name', width:150,sorttype:"text", editable: true},
			<%}%>
			{name:'keywords',index:'keywords', width:270,sorttype:"text", editable: true,sortable:false},			
			{name:'page_accounts',index:'page_accounts', width:220,sorttype:"text", editable: true,sortable:false},
		  <%
		    if(export_type.equals("2")||export_type.equals("3")||export_type.equals("6")){
		  %>
			{name:'email',index:'email', width:150, sorttype:"text", editable: false},
		  <%}%>
		  <%
		    if(export_type.equals("2")||export_type.equals("3")||export_type.equals("6")){
		  %>
			{name:'page_ids',index:'page_ids', width:20, sorttype:"int", editable: false, hidden:true},
		  <%}%>		  
		  <%
		    if(export_type.equals("4")){
		  %>
			{name:'export_path',index:'export_path', width:270,sorttype:"text", editable: true},
			{name:'page_ids',index:'page_ids', width:20, sorttype:"int", editable: false, hidden:true},
		  <%}%>
		  {name:'export_period_month',index:'export_period_month', width:20, sorttype:"int", editable: false, hidden:true},
		  {name:'export_period_week',index:'export_period_week', width:20, sorttype:"int", editable: false, hidden:true},
		  {name:'export_period_day',index:'export_period_day', width:20, sorttype:"int", editable: false, hidden:true},
			],
		rowNum:20,
   		rowList:[20,30,50],
   		pager: '#article_pagered',
		//autowidth:true,
		gridview:true,
		viewrecords:true,
	onSelectRow: function(id){
		
		refreshField();
		var rowdata = jQuery('#article_list').getRowData(id);		
		$("#page_ids").val(rowdata.page_ids);
		$("#page_accounts").val(rowdata.page_accounts);		
	  $("#export_path").val(rowdata.export_path);
		$("#export_name").val(rowdata.export_name);
		$("#keywords").val(rowdata.keywords);
		$("#email").val(rowdata.email);
		$("#db_id_hidden").val(rowdata.ID);
		if(rowdata.export_period_month==0){
		   $('#month').click();
	  }
		if(rowdata.export_period_week==1){
		   $('#week').click();
	  }
	  if(rowdata.export_period_day==1){
		   $('#day').click();
	  }
		$("#addBtn").val('修改');
		$("#clearBtn").show();
	},
	editurl: "./server/deleteData_FBKeyword.jsp",
});

jQuery("#article_list").jqGrid('navGrid','#article_pagered',  { edit: false, add: false, del: true, search: false, refresh: false }, //options 
{height:200,reloadAfterSubmit:false,  closeAfterEdit: true,
	serializeEditData: function (postdata) { 
 }}, // edit options 
{height:400,reloadAfterSubmit:true, closeAfterAdd: true, 
	serializeEditData: function (postdata) {
 }
}, // add options 
{reloadAfterSubmit:true,serializeDelData: function (postdata) {
	  var rowdata = jQuery('#article_list').getRowData(postdata.id);
	  refreshField();
	 /* $.post('./server/deleteData_FBKeyword.jsp', {oper: postdata.oper,'db_ID':rowdata.ID,dbname:'fb_export_list'},
			function(result) {}
		);*/
      return {oper: postdata.oper, db_ID: rowdata.ID,dbname:'fb_export_list'};
 }}, // del options 
{} // search options 
);
</script>

