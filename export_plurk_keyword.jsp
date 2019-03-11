<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="tw.org.iii.ideas.service.*" %>
<%@ page import="java.util.*"%> 
<%@ page import="org.json.JSONArray,
org.json.JSONException,
org.json.JSONObject"%>
<%
boolean isCheckIn =  session.getAttribute("isLoginTag")==null ? false:(Boolean)session.getAttribute("isLoginTag");
if(!isCheckIn ){
	response.sendRedirect("login.html"); 
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%

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
		$("#menu>#nav>li:nth-child(4)").addClass("current");			
	 });
	function addNewFBPage(){
		var oper;
		var db_ID = $("#db_id_hidden").val();
		if(db_ID==""){
			oper = "add";
		}else{
			oper = "edit";
		}
		var export_name = encodeURIComponent($("#export_name").val());
		var keywords = encodeURIComponent($("#keywords").val());
		var export_path = encodeURIComponent($("#export_path").val());
		$.post('./server/modifyNewKeyword.jsp', {'source_type':'plurk_export',
		'oper':oper,'db_ID':db_ID,'keywordSets':keywords,'export_path':export_path},
			function(result) {
				result = trim(result);
				if(result=="done"){
					alert("更新完成");
					if(oper=="add")
						$("#article_list").jqGrid('setGridParam',{datatype:'json',sortname:'update_time',sortorder:'desc'}).trigger('reloadGrid',[{page:1}]);
					else
						$("#article_list").jqGrid('setGridParam',{datatype:'json'}).trigger('reloadGrid',[{page:1}]);
					refreshField();
				}else{
					alert("更新失敗");
				}
			}
		);
	};
	function refreshField(){		
		$("#export_path").val('');		
		$("#keywords").val('');
		$("#db_id_hidden").val('');
		$("#addBtn").val('新增');
		$("#clearBtn").hide();
	};	
	
	function exportList(){
		$.post('./server/exportList.jsp', {'query_type':"plurk_keyword_export"},
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
		<h2>固定報表：Plurk關鍵字搜尋</h2>
		<input type="button" value="匯出" class="btnposition" style="margin-top:-20px" onClick="exportList()"/>
		<br/>
		<div style="padding-left:30px;position:relative;z-index:2">
			<table id="article_list"></table>
			<div id="article_pagered"></div>
	    </div><br/>
		<ul class="formframe">
		<div id="fb">
		<input type="hidden" id="db_id_hidden" name="db_id_hidden" value="" />
		<li>週期：<br/>	一日三次&nbsp;&nbsp;匯出時間:每日07:00、15:00、23:00</li>
		<li>請選擇Plurk關鍵字(多選)：<input type="button" value="選擇" onclick="window.open('plurk_keyword_list.jsp?keywords='+document.getElementById('keywords').value, 'newWin', config='height=500,width=800,scrollbars=yes')">
		<textarea name="keywords" id="keywords" value="" rows="4" cols="80" disabled></textarea>
		</li>
		<li>請輸入路徑：
		<input type="text" id="export_path" name="export_path" size="60" /><br/>
		ex:voc online plus/XML/SmartPhone/Apple/
		</li>
		</ul>
	  <input id="addBtn" type="button" value="新增" class="btnposition" onClick="addNewFBPage();">
	  <input id="clearBtn" type="button" value="清空" class="btnposition" onClick="refreshField()"><br/><br/><br/>	  
	</div>
</div>
</div><br/><br/>
<div id="footer"> 亞洲指標數位行銷股份有限公司版權所有 © 2012 Indexasia Digital Consulting co.,Inc. All Rights Reserved </div>
</div>
</body>
</html>
<script type="text/javascript">
	$("#clearBtn").hide();
	jQuery("#article_list").jqGrid({      
		url:"./server/articleTable_paging.jsp?datatype=plurkKeywordExportList&q=2", 
		datatype: "json",
	//datatype: "local",
		height: 260,
		colNames:['ID','No','關鍵字組合','路徑'], //欄位名稱
   		colModel:[
			{name:'ID',index:'ID', width:20, sorttype:"int", editable: false, hidden:true},
			{name:'No',index:'No', width:20, sorttype:"int", editable: false,align:"center"},
			{name:'keywords',index:'keywords', width:370,sorttype:"int", editable: true},			
			{name:'export_path',index:'export_path', width:370,sorttype:"int", editable: true},
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
		$("#export_path").val(rowdata.export_path);
		$("#keywords").val(rowdata.keywords);
		$("#db_id_hidden").val(rowdata.ID);
		$("#addBtn").val('修改');
		$("#clearBtn").show();
	},
	editurl: "./server/deleteData.jsp",
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
	  $.post('./server/deleteData.jsp', {oper: postdata.oper,'db_ID':rowdata.ID,dbname:'plurk_keyword_export_detail'},
			function(result) {}
		);
      return {oper: postdata.oper, db_ID: rowdata.ID,dbname:'plurk_keyword_export_list'};
 }}, // del options 
{} // search options 
);
</script>

