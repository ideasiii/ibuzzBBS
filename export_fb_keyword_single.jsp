<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="tw.org.iii.ideas.service.*" %>
<%@ page import="java.util.*"%> 
<%@ page import="org.json.JSONArray,
org.json.JSONException,
org.json.JSONObject"%>
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
	$(function() {
		$("#menu>#nav>li:nth-child(5)").addClass("current");
		minDate = new Date();
		minDate.setDate(minDate.getDate()-90);
		var pickerOpts = {
			dateFormat: 'yy-mm-dd',
			minDate: new Date(minDate.getFullYear() , minDate.getMonth(),  minDate.getDate()),
			buttonImage: "images/calendar_red.png",
			buttonImageOnly: true,
			showOn: "button"
		};
		today = new Date();
		$("#startdate").val(today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate());
		$("#startdate").datepicker(pickerOpts);
		//$("#startDate").datepicker(pickerOpts,today.getFullYear()+"-"+today.getMonth()+"-"+today.getDate());
		//console.log(today.getFullYear()+"-"+today.getMonth()+"-"+today.getDate());
	});
	
	$(function() {
		minDate = new Date();
		minDate.setDate(minDate.getDate()-90);
		var pickerOpts = {
			dateFormat: 'yy-mm-dd',
			minDate: new Date(minDate.getFullYear() , minDate.getMonth(),  minDate.getDate()),
			buttonImage: "images/calendar_red.png",
			buttonImageOnly: true,
			showOn: "button"
		};
		today = new Date();
		$("#enddate").val(today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate());
		$("#enddate").datepicker(pickerOpts);
		//$("#startDate").datepicker(pickerOpts,today.getFullYear()+"-"+today.getMonth()+"-"+today.getDate());
		//console.log(today.getFullYear()+"-"+today.getMonth()+"-"+today.getDate());
	});	
	function addNewFBPage(){
		var oper;
		var db_ID = $("#db_id_hidden").val();
		if(db_ID==""){
			oper = "add";
		}else{
			oper = "edit";
		}
		var isassigndate="";
		isassigndate=$('input[name=isassigndate]:checked').val();
		var startdate="";
		var enddate="";
		if(isassigndate=="1"){
		   startdate=$("#startdate").val();
		   enddate=$("#enddate").val();		   
		}
		var progress = encodeURIComponent($("#progress_hidden").val());
		var export_name = encodeURIComponent($("#export_name").val());
		var keywords = encodeURIComponent($("#keywords").val());
		$.post('./server/modifyNewFBKeyword_single.jsp', {'source_type':'fb_keyword','oper':oper,'export_id':db_ID,'export_type':'<%=export_type%>','export_name':export_name,'keywords':keywords,'email':$("#email").val(),'isassigndate':isassigndate,'startdate':startdate,'enddate':enddate,'progress':progress,'fbpages':$("#page_ids").val()},
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
		$("#export_name").val('');
		$("#email").val('');
		$("#keywords").val('');
		$("#db_id_hidden").val('');
		$("#addBtn").val('新增');
		$("#copyBtn").hide();
		$("#clearBtn").hide();
	};
	
	function exportList(){
		$.post('./server/exportKeyword_FB_single.jsp', {'query_type':"fbKeywordExportList",'export_type':"<%=export_type%>"},
			function(file_path) {
			//	alert(file_path);
				document.location.href = file_path;
			}
		);
	};
	
	function copyField(){
		$("#db_id_hidden").val('');
		$("#addBtn").val('新增');
		$("#copyBtn").hide();
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
		<h2>單次報表：FB廣大搜尋報表</h2>
		<%}%>
		<%
		if(export_type.equals("3")){
		%>
		<h2>單次報表：FB日報表</h2>
		<%}%>
		<%
		if(export_type.equals("5")){
		%>
		<h2>單次報表：FB話題列表</h2>
		<%}%>
		<%
		if(export_type.equals("7")){
		%>
		<h2>單次報表：FB群組話題列表</h2>
		<%}%>
		<input type="button" value="匯出全部" class="btnposition" style="margin-top:-20px" onClick="exportList()" /></br>
		<div style="padding-left:30px;position:relative;z-index:0">
			<table id="article_list"></table>
			<div id="article_pagered"></div>
	    </div><br/>
		<ul class="formframe">
		<div id="fb">
		<input type="hidden" id="db_id_hidden" name="db_id_hidden" value="" />
		<input type="hidden" id="progress_hidden" name="progress_hidden" />
		<li>指定統計區間：
		  <input type="radio" id="isassigndate" name="isassigndate" value="1" />是
		  <input type="radio" id="isassigndate" name="isassigndate" value="0" checked/>否
		  </li>
		<li>
		<label>請輸入統計區間:</label>
		<input type="text" id="startdate" name="startdate" size="10" />~<input type="text" id="enddate" name="enddate" size="10" />
		</li>
		<li>請選擇關鍵字組合(多選)：<input type="button" value="選擇" onclick="window.open('keyword_list.jsp?keywords='+document.getElementById('keywords').value, 'newWin', config='height=500,width=800,scrollbars=yes')">
		<textarea name="keywords" id="keywords" value="" rows="4" cols="80" disabled></textarea>
		</li>
		<li>請選擇Facebook頁面(多選)：<input type="button" value="選擇" onclick="window.open('page_list.jsp?page_ids='+document.getElementById('page_ids').value, 'newWin', config='height=500,width=800,scrollbars=yes')">
		<textarea name="page_accounts" id="page_accounts" value="" rows="4" cols="80" disabled></textarea>
		</li>	
		<li>請輸入報表名稱：
		<input type="text" id="export_name" name="export_name" size="60" />ex:機車專案
		</li>
		<li>請輸入Email：
		<input type="text" id="email" name="email" size="60" />(若有多組請用分號;區隔)
		</li>
		</ul>
		<input id="page_ids" name="page_ids" value="" type="hidden" />
	  <input id="addBtn" type="button" value="新增" class="btnposition" onClick="addNewFBPage();">
	  <input id="copyBtn" type="button" value="複製" class="btnposition" onClick="copyField();">
	  <input id="clearBtn" type="button" value="清空" class="btnposition" onClick="refreshField()"><br/><br/><br/>	  
	</div>
</div><br/><br/>
<div id="footer"> 亞洲指標數位行銷股份有限公司版權所有 © 2012 Indexasia Digital Consulting co.,Inc. All Rights Reserved </div>

</body>
</html>
<script type="text/javascript">
	$("#clearBtn").hide();
	$("#copyBtn").hide();
	jQuery("#article_list").jqGrid({      
		url:"./server/fbkeywordlistTable_paging_single.jsp?datatype=fbKeywordExportList&q=2&export_type=<%=export_type%>", 
		datatype: "json",
	//datatype: "local",
		height: 260,
		  <%
		    //if(export_type.equals("3")){
		  %>
		  colNames:['ID','No','報表名稱','關鍵字組合','頁面名稱','起始日期','結束日期','Email','處理進度','檔案下載','page_ids'], //欄位名稱
		  <%//}else{%>
		 <!-- colNames:['ID','No','報表名稱','關鍵字組合','起始日期','結束日期','Email','處理進度','檔案下載'], //欄位名稱--->
		  <%//}%>
   		colModel:[
			{name:'ID',index:'ID', width:10, sorttype:"int", editable: false, hidden:true},
			{name:'No',index:'No', width:20, sorttype:"int", editable: false,align:"center",sortable:false},
			{name:'export_name',index:'export_name', width:120,sorttype:"text", editable: true,editoptions:{size:50}},
			
			<%
		    //if(export_type.equals("3")){
		  %>
			{name:'keywords',index:'keywords', width:100,sorttype:"int", editable: true,sortable:false},
			{name:'page_accounts',index:'page_accounts', width:120,sorttype:"text", editable: true,sortable:false},
		  <%//}else{%>
		  <!--{name:'keywords',index:'keywords', width:220,sorttype:"int", editable: true,sortable:false},-->
		  <%//}%>
			{name:'startdate',index:'startdate', width:70,sorttype:"int", editable: true},
			{name:'enddate',index:'enddate', width:70,sorttype:"int", editable: true},
			{name:'email',index:'email', width:120,sorttype:"int", editable: true},
			{name:'progress',index:'progress', width:70,sorttype:"int", editable: true},
			{name:'filepath',index:'filepath', width:120,sorttype:"int", editable: true},
			<%
		    //if(export_type.equals("3")){
		  %>
			{name:'page_ids',index:'page_ids', width:20, sorttype:"int", editable: false, hidden:true},
		  <%//}%>		
			],
		rowNum:5,
   		rowList:[20,30,50],
   		pager: '#article_pagered',
		//autowidth:true,
		gridview:true,
		viewrecords:true,
	onSelectRow: function(id){
		refreshField();
	  
		var rowdata = jQuery('#article_list').getRowData(id);	
		<%
		   // if(export_type.equals("3")){
		%>		
		$("#page_ids").val(rowdata.page_ids);
		$("#page_accounts").val(rowdata.page_accounts);		
	  <%//}%>
		$("#export_name").val(rowdata.export_name);
		$("#keywords").val(rowdata.keywords);
		$("#startdate").val(rowdata.startdate);
		$("#enddate").val(rowdata.enddate);
		$("#email").val(rowdata.email);
		$("#db_id_hidden").val(rowdata.ID);
		$("#progress_hidden").val(rowdata.progress);		
		$("#addBtn").val('修改');
		$("#copyBtn").show();
		$("#clearBtn").show();
		if(rowdata.startdate!=""){
		   $('input:radio[name=isassigndate]')[0].checked = true;
	  }
	},
	editurl: "./server/deleteData_FBKeyword_single.jsp",
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
	  $.post('./server/deleteData_FBKeyword_single.jsp', {oper: postdata.oper,'db_ID':rowdata.ID,dbname:'fb_export_list_single','progress':encodeURIComponent(rowdata.progress)},
			function(result) {
			  result = trim(result);
				if(result=="done"){
					alert("刪除完成");					
				}else{
					alert("更新失敗:" + result);
				}
			}
		);
      return {oper: postdata.oper, db_ID: rowdata.ID,dbname:'fb_export_list_single'};
 }}, // del options 
{} // search options 
);
</script>

