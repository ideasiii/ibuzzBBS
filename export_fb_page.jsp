<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.util.*"%> 
<%
boolean isCheckIn =  session.getAttribute("isLoginTag")==null ? false:(Boolean)session.getAttribute("isLoginTag");
if(!isCheckIn ){
	response.sendRedirect("login.html"); 
}
%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

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
	$(document).ready(function ()  {
		$("#menu>#nav>li:nth-child(4)").addClass("current"); //根據頁面，設定menu class=current(ex:此頁是固定報表)
		$("#clearBtn").hide();
	});
	function addNewFBPage(){
		var oper;
		var db_ID = $("#db_id_hidden").val();
		if(db_ID==""){
			oper = "add";
		}else{
			oper = "edit";
		}
		var selected;
		var name = encodeURIComponent($("#export_name").val());
		
		$.post('./server/modifyNewFBPage.jsp', {'source_type':'fb','oper':oper,'export_id':db_ID,'fbpages':$("#page_ids").val(),
		'export_name':name,'send_email':$("#send_email").val()},
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
	
		$("#p_scnt").val("");
		var keywordInputCount = $('#keywordTextInputArea p').size();
		//console.log("keywordInputCount="+keywordInputCount);
		if( keywordInputCount > 1 ) {
			//console.log("here");
			for(var i = keywordInputCount; i>1; i--){
				$("#keywordTextInputArea>p:last-child").remove();
				keywordInputCount--;
			}
		}	
		$("#page_ids").val('');
		$("#page_accounts").val('');
		$("#export_name").val('');
		$("#send_email").val('');
		$("#addBtn").val('新增');
		$("#clearBtn").hide();
	};
	function exportList(){
		$.post('./server/exportList_FB.jsp', {'query_type':"fbPageExportList"},
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
		<h2>固定報表：FB官方粉絲頁監測報表</h2>
		<input type="button" value="匯出全部" class="btnposition" style="margin-top:-20px" onClick="exportList()" /></br>
		<div style="padding-left:30px;position:relative;z-index:2">
			<table id="article_list"></table>
			<div id="article_pagered"></div>
	    </div><br/>
		<ul class="formframe">
		<div id="fb">
		<li>請輸入報表名稱：
		<input type="text" id="export_name" name="export_name" size="80" /></li>
		
		<li>週期：一個月一次&nbsp;&nbsp;統計區間：上月1號至該月最後一天&nbsp;&nbsp;匯出時間:每月3號</li>
		<li>請選擇Facebook頁面(多選)：<input type="button" value="選擇" onclick="window.open('page_list.jsp?page_ids='+document.getElementById('page_ids').value, 'newWin', config='height=500,width=800,scrollbars=yes')">
		<textarea name="page_accounts" id="page_accounts" value="" rows="4" cols="80" disabled></textarea>
		</li>
		<li>請輸入Email：
		<input type="text" id="send_email" name="send_email" size="60" />(若有多組請用分號;區隔)</li>
		<input id="db_id_hidden" name="db_id_hidden" value="" type="hidden" />
		<input id="page_ids" name="page_ids" value="" type="hidden" />
		</div></li>
		</ul>
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
	jQuery("#article_list").jqGrid({      
		url:"./server/fblistTable_paging.jsp?datatype=fbPageExportList&q=2", 
		datatype: "json",
	//datatype: "local",
		height: 260,
		colNames:['ID','No','報表名稱','頁面名稱','Email','page_ids'], //欄位名稱
   		colModel:[
			{name:'ID',index:'ID', width:20, sorttype:"int", editable: false, hidden:true},
			{name:'No',index:'No', width:20, sorttype:"int", editable: false,align:"center",sortable:false},
			{name:'export_name',index:'export_name', width:200,sorttype:"text", editable: true,editoptions:{size:50}},
			{name:'page_accounts',index:'page_accounts', width:320,sorttype:"text", editable: true,sortable:false},
			{name:'email',index:'email', width:220,sorttype:"text", editable: true},
			{name:'page_ids',index:'page_ids', width:20, sorttype:"int", editable: false, hidden:true},
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
		$("#export_name").val(rowdata.export_name);
		$("#send_email").val(rowdata.email);
		$("#db_id_hidden").val(rowdata.ID);
		$("#addBtn").val('修改');
		$("#clearBtn").show();
	},
	editurl: "./server/deleteData_FB.jsp",
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
	 /* $.post('./server/deleteData_FB.jsp', {oper: postdata.oper,'db_ID':rowdata.ID,dbname:'fb_export_list'},
			function(result) {}
		);*/
    return {oper: postdata.oper, db_ID: rowdata.ID,dbname:'fb_export_list'};
 }}, // del options 
{} // search options 
);
</script>

