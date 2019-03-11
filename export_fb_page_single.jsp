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
		$("#clearBtn").hide();
		$("#copyBtn").hide();
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
	
	
	$(document).ready(function ()  {		
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
		if(db_ID==""){
			oper = "add";
		}else{
			oper = "edit";
		}
		var selected_fb ="";
		
		//alert(selected_fb+"----");
		/*alert("db_ID="+db_ID);
		alert("oper="+oper);
		alert("selected_fb="+selected_fb);
		alert("export_name="+$("#export_name").val());
		alert("send_email="+$("#send_email").val());*/
		
		var name = encodeURIComponent($("#export_name").val());
		var progress = encodeURIComponent($("#progress_hidden").val());
		var isassigndate="";
		isassigndate=$('input[name=isassigndate]:checked').val();
		var startdate="";
		var enddate="";
		if(isassigndate=="1"){
		   startdate=$("#startdate").val();
		   enddate=$("#enddate").val();		   
		}
		$.post('./server/modifyNewFBPage_single.jsp', {'source_type':'fb','oper':oper,'export_id':db_ID,'fbpages':$("#page_ids").val(),
		'export_name':name,'send_email':$("#send_email").val(),'isassigndate':isassigndate,'startdate':startdate,'enddate':enddate,'progress':progress},
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
					alert("[更新失敗]:"+result);
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
		$("#db_id_hidden").val('');
		$("#addBtn").val('新增');
		$("#copyBtn").hide();
		$("#clearBtn").hide();
	};
	
	function copyField(){
		$("#db_id_hidden").val('');
		$("#addBtn").val('新增');
		$("#copyBtn").hide();
	};
	
	function exportList(){
		$.post('./server/exportList_FB_single.jsp', {'query_type':"fbPageExportList"},
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
		<h2>單次報表：FB官方粉絲頁監測報表(含上月比較)</h2>
		<input type="button" value="匯出全部" class="btnposition" style="margin-top:-20px" onClick="exportList()" /></br>
		<div style="padding-left:30px;position:relative;z-index:0">
			<table id="article_list"></table>
			<div id="article_pagered"></div>
	    </div><br/>
		<ul class="formframe">
		<div id="fb">
		<input type="hidden" id="progress_hidden" name="progress_hidden" />
		<li>請輸入報表名稱:
    <input type="text" id="export_name" name="export_name" size="70" />
    <label>ex:機車專案</label></li>
			<li>指定統計區間：
		  <input type="radio" id="isassigndate" name="isassigndate" value="1" />是
		  <input type="radio" id="isassigndate" name="isassigndate" value="0" checked/>否
		  </li>
		<li>
		<label>請輸入統計區間:</label>
		<input type="text" id="startdate" name="startdate" size="10" />~<input type="text" id="enddate" name="enddate" size="10" />
		<li>請選擇Facebook頁面(多選)：<input type="button" value="選擇" onclick="window.open('page_list.jsp?page_ids='+document.getElementById('page_ids').value, 'newWin', config='height=500,width=800,scrollbars=yes')">
		<textarea name="page_accounts" id="page_accounts" value="" rows="4" cols="80" disabled></textarea>
		</li>
		<li>請輸入Email：
		<input type="text" id="send_email" name="send_email"size="60" />(若有多組請用分號;區隔)</li>
		<input id="db_id_hidden" name="db_id_hidden" value="" type="hidden" />
		<input id="page_ids" name="page_ids" value="" type="hidden" />
		</div></li>
		</ul>
	  <input id="addBtn" type="button" value="新增" class="btnposition" onClick="addNewFBPage();">
	  <input id="copyBtn" type="button" value="複製" class="btnposition" onClick="copyField();">
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
		url:"./server/fblistTable_paging_single.jsp?datatype=fbPageExportList&q=2", 
		datatype: "json",
	//datatype: "local",
		height: 260,
		colNames:['ID','No','報表名稱','頁面名稱','起始日期','結束日期','Email','處理進度','檔案下載','page_ids'], //欄位名稱
   		colModel:[
			{name:'ID',index:'ID', width:10, sorttype:"int", editable: false, hidden:true},
			{name:'No',index:'No', width:20, sorttype:"int", editable: false,align:"center",sortable:false},
			{name:'export_name',index:'export_name', width:120,sorttype:"text", editable: true,editoptions:{size:50}},
			{name:'page_accounts',index:'page_accounts', width:200,sorttype:"int", editable: true,sortable:false},
			{name:'startdate',index:'startdate', width:70,sorttype:"int", editable: true},
			{name:'enddate',index:'enddate', width:70,sorttype:"int", editable: true},
			{name:'email',index:'email', width:100,sorttype:"int", editable: true},
			{name:'progress',index:'progress', width:90,sorttype:"int", editable: true},
			{name:'filepath',index:'filepath', width:120,sorttype:"int", editable: true},
			{name:'page_ids',index:'page_ids', width:10, sorttype:"int", editable: false, hidden:true},
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
		$("#page_ids").val(rowdata.page_ids);
		$("#page_accounts").val(rowdata.page_accounts);		
		$("#export_name").val(rowdata.export_name);
		$("#startdate").val(rowdata.startdate);
		$("#enddate").val(rowdata.enddate);
		$("#send_email").val(rowdata.email);
		$("#db_id_hidden").val(rowdata.ID);
		$("#progress_hidden").val(rowdata.progress);
		if(rowdata.startdate!=""){
		   $('input:radio[name=isassigndate]')[0].checked = true;
	  }
		$("#addBtn").val('修改');
		$("#copyBtn").show();
		$("#clearBtn").show();
	},
	editurl: "./server/deleteData_FB_single.jsp",
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
	  $.post('./server/deleteData_FB_single.jsp', {oper: postdata.oper,'db_ID':rowdata.ID,dbname:'fb_export_list_single','progress':encodeURIComponent(rowdata.progress)},
			function(result) {
			   result = trim(result);
				if(result=="done"){
					alert("刪除完成");					
				}else{
					alert("更新失敗:" + result);
				}	
			}
		);
      return {oper: postdata.oper, db_ID: rowdata.ID,dbname:'fb_export_list_single','progress':rowdata.progress};
 }}, // del options 
{} // search options 
);
</script>

