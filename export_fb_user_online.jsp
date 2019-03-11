<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="tw.org.iii.ideas.service.*" %>
<%@ page import="java.util.*"%> 
<%@ page import="org.json.JSONArray,
org.json.JSONException,
org.json.JSONObject"%>

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
	});
	
	function addNewFBPage(){
		var export_name = encodeURIComponent($("#export_name").val());
		var page_id =$("#page_id").val();
		var post_id =$("#post_id").val();
		var startdate =$("#startdate").val();
		$.post('./server/modifyNewFBUser_online.jsp', {'export_name':export_name,'page_id':page_id,'post_id':post_id,'startdate':startdate},
			
			function(result) {
				result = trim(result);
				if(result=="done"){
					alert("更新完成");
					$("#article_list").jqGrid('setGridParam',{datatype:'json',sortname: 'update_time',sortorder: 'desc'}).trigger('reloadGrid');
					$("span.s-ico",jQuery("#article_list").jqGrid.hDiv).hide();
					refreshField();
				}else{
					alert("更新失敗:" + result);
				}
			}
			
		);
	};
	function refreshField(){
	};
</script>
</head>

<body>
<div id="wrapper" class="clear">
	<jsp:include page="menubar.jsp" />
    <div id="main">
	<div>
		<h2>單次報表：FB回應使用者清單</h2>
		
		<div style="padding-left:30px;position:relative;z-index:0">
			<table id="article_list"></table>
			<div id="article_pagered"></div>
	    </div><br/>
		<ul class="formframe">
		<div id="fb">
		<li>請輸入報表名稱：<br/>
		<input type="text" id="export_name" name="export_name" size="60" />&nbsp&nbsp;ex:機車專案
		</li>
		<li>請輸入粉絲頁ID：<br/>
		<input type="text" id="page_id" name="page_id" size="60" />&nbsp&nbsp;ex:canontaiwan 或 333338480975
		</li>
		<li>請輸入文章ID：<br/>
		<input type="text" id="post_id" name="post_id" size="60" />&nbsp&nbsp;ex:10152138324874936
		</li>
		<li>請選擇發文日期：
		<input type="text" id="startdate" name="startdate" size="30" style="position:relative;z-index:5" disabled />&nbsp;(最多回溯前90天的文章)</li>
		</ul>
		<input id="addBtn" type="button" value="新增" class="btnposition" onClick="addNewFBPage();">
	  <input id="clearBtn" type="button" value="清空" class="btnposition" onClick="refreshField()"><br/><br/><br/>	  
	</div>
</div><br/><br/>
<div id="footer"> 亞洲指標數位行銷股份有限公司版權所有 © 2012 Indexasia Digital Consulting co.,Inc. All Rights Reserved </div>

</body>
</html>
<script type="text/javascript">
	jQuery("#article_list").jqGrid({      
		url:"./server/fbuserTable_paging_online.jsp", 
		datatype: "json",
	//datatype: "local",
		height: 260,
		  colNames:['No','報表名稱','頁面ID','文章ID','部份的內容','發文時間','文章最後更新時間','檔案下載'], //欄位名稱
   		colModel:[
			{name:'No',index:'No', width:20, sorttype:"int", editable: false,align:"center",sortable:false},
			{name:'export_name',index:'export_name', width:100,sorttype:"text", editable: true,editoptions:{size:50},sortable:true},
			{name:'page_account',index:'page_account', width:80,sorttype:"text", editable: true,sortable:false},
			{name:'post_id',index:'post_id', width:100,sorttype:"text", editable: true,sortable:false},
		  {name:'content',index:'content', width:220,sorttype:"text", editable: true},
		  {name:'startdate',index:'startdate', width:70,sorttype:"text", editable: true},
		  {name:'updated_time',index:'updated_time', width:100,sorttype:"text", editable: true,sortable:false},
		  {name:'filepath',index:'filepath', width:120,sorttype:"int", editable: true,sortable:false}
			],
		sortname: "update_time",
		sortorder: "desc",
		rowNum:20,
   		rowList:[20,30,50],
   		pager: '#article_pagered',
		//autowidth:true,
		gridview:true,
		viewrecords:true,
	onSelectRow: function(id){
		refreshField();
	},
});

jQuery("#article_list").jqGrid('navGrid','#article_pagered',  { edit: false, add: false, del: false, search: false, refresh: false }, //options 
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

