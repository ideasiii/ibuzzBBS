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

ibuzz_service srv = new ibuzz_service();

Vector<String> fieldVector = new Vector<String>();
Vector<String> conditionFieldVector = new Vector<String>();
Vector<String> conditionFieldValueVector = new Vector<String>();

String dbname = "bbs_crawl_list";
fieldVector.add("board");
JSONArray itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"board","asc");

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

<script src="JQGrid/js/ui.multiselect.js" type="text/javascript"></script>
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
</style>
<script type="text/javascript">
	var isInit = true;	
	
	$(function() {
		$("#menu>#nav>li:nth-child(4)").addClass("current"); //根據頁面，設定menu class=current(ex:此頁是固定報表)
		onBoardSelectChange();//initial
		$("#borad_select").change(onBoardSelectChange);
		var pickerOpts = {
			dateFormat: 'yy-mm-dd',
			//minDate: new Date(minDate.getFullYear() , minDate.getMonth(),  minDate.getDate()),
			buttonImage: "images/calendar_red.png",
			buttonImageOnly: true,
			showOn: "button"
		};  
		today = new Date();
		$("#startDate").val(today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate());// set default
		$("#startDate").datepicker(pickerOpts);
		$("#clearBtn").hide();
	});
	
	function addNewExport(){
		var oper;
		var db_ID = $("#db_id_hidden").val();
		if(db_ID==""){
			oper = "add";
		}else{
			oper = "edit";
		}

		var transferTime =$('input[name=transferTime_radio]:checked').val();
		var path = encodeURIComponent($("#export_path").val());
		$.post('./server/modifyNewExport.jsp', {'source_type':"bbs",'oper':oper,'db_ID':db_ID,'board':$("#borad_select").val(),
		'export_path':path,'date':$("#startDate").val(),'transferTime':transferTime},
			function(result) {
				result = trim(result);
				if(result=="true"){
					alert("更新完成");
					if(oper === "add"){
						$("#article_list").jqGrid('setGridParam',{datatype:'json',sortname:'update_time',sortorder:'desc'}).trigger('reloadGrid',[{page:1}]);
					}else if(oper === "edit"){
						$("#article_list").jqGrid('setGridParam',{datatype:'json'}).trigger('reloadGrid',[{page:1}]);
					}
					refreshField();
				}else if(result=="already"){
					alert("此版塊已在固定匯出清單中");
				}else{
					alert("更新失敗");
				}
			}
		);
	};

	function refreshField(){
		$("#borad_select").find(":selected").attr('selected',false);
		$("#board_startFrom").text("");
		today = new Date();
		$("#startDate").val(today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate());// set default
		$("#export_path").val("");
		$("#db_id_hidden").val("");
		$("#startFrom_li").show();
		$("#clearBtn").hide();//新增欄位(for refresh field)
		$("#addBtn").val('新增');
	};
	
	function onBoardSelectChange(){//更換board
		var selected_board = $("#borad_select").val();
		$.post('./server/getData.jsp', {'query_type':"bbs_board_startFrom",'board':selected_board},
			function(JSONArr) {
				if(JSONArr.length>0){
					var jsonObject = JSONArr[0];
					$("#board_startFrom").text("此版塊資料起始時間為："+jsonObject.startFrom);
					//setCalendarMinDate(jsonObject.startFrom);
				}
			}
		);
		if(!isInit){
			$.post('./server/getData.jsp', {'query_type':"bbs_board_isExist",'board':selected_board},
				function(JSONArr) {
					if(JSONArr.length>0){
						alert("提醒：此版塊已設定匯出");
					}
				}
			);
		}
		isInit = false;
	};
	
	function exportList(){
		$.post('./server/exportList.jsp', {'query_type':"bbsExportList"},
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
		<!--<table id="article_list"></table>
		<div id="article_pagered"></div>-->
		<h2>固定報表：PTT電子報</h2>
		<input type="button" value="匯出" class="btnposition" style="margin-top:-20px" onClick="exportList()" />
		<br/>
		<div style="padding-left:30px;position:relative;z-index:2">
		<table id="article_list"></table>
		<div id="article_pagered"></div>
	  </div><br/>
	  
		<ul class="formframe">
		<div id="ptt">
		<li>週期：預設一天一次&nbsp;&nbsp;01:30 或 02:30、07:30、13:30 (24小時制)</li>
		<li>請選擇PTT版塊(單選)：<select name="borad_select" id="borad_select">
		<% for(int i=0; i<itemJSONArr.length(); i++){
			JSONObject itemJSON =  (JSONObject)itemJSONArr.get(i);
		%>
		<option value="<%=itemJSON.getString("board")%>" ><%=itemJSON.getString("board")%></option>
		<%}%>
		</select>&nbsp;<label id="board_startFrom"></label>
		</li>
		<li id="startFrom_li">資料起始日期：
		<input type="text" id="startDate" name="startDate" size="15" style="position:relative;z-index:5"/></li>
		<li>上傳時段：
		<input type="radio" id="tranfer_1" name="transferTime_radio" value="01:30" checked >01:30&nbsp;&nbsp;
		<input type="radio" id="tranfer_2" name="transferTime_radio" value="02:30" >02:30
		</li>
		<li>請輸入路徑：
		<input type="text" id="export_path" name="export_path" size="60" />&nbsp;EX:資料蒐集/PTTGossiping</li>
		<input id="db_id_hidden" name="db_id_hidden" value="" type="hidden" />
	<!--	<label>例行回溯天數</label>
		<select id="update_pastday" name="update_pastday">
			<option value="4" selected>4天</option>
			<option value="0">0天</option>
		</select>
		<br/><br/>-->
		</div>
		</ul>
		<input id="addBtn" type="button" value="送出" class="btnposition" onClick="addNewExport()">
	   <input id="clearBtn" type="button" value="清空" class="btnposition" onClick="refreshField()"><br/><br/><br/>
	</div>
</div><br/><br/>
<div id="footer"> 亞洲指標數位行銷股份有限公司版權所有 © 2012 Indexasia Digital Consulting co.,Inc. All Rights Reserved </div>

</div>
</body>
</html>
<script type="text/javascript">
	jQuery("#article_list").jqGrid({      
		url:"./server/articleTable_paging.jsp?datatype=bbsExportList&q=2", 
		datatype: "json",
	//datatype: "local",
		height: 260,
		colNames:['ID','No','版塊名稱','路徑','資料記錄起始','已例行性產出','上傳時段'], //欄位名稱
   		colModel:[
			{name:'ID',index:'ID', width:20, sorttype:"int", editable: false, hidden:true},
			{name:'No',index:'No', width:60, sorttype:"int", editable: false,align:"center",sortable:false},
			{name:'board',index:'board', width:150,sorttype:"text", editable: false},
			{name:'export_path',index:'export_path', width:290,sorttype:"int", editable: true},
			{name:'startFrom',index:'startFrom', width:100,sorttype:"int", editable: false},
			{name:'isRoutine',index:'isRoutine', width:100,sorttype:"int", editable: false,align:"center",
						formatter:'select',editoptions:{value: '0:否;1:是'}},
			{name:'transferTime',index:'transferTime', width:60,sorttype:"int", sortable: false,editable: false},
			],
		rowNum:10,
   		rowList:[10,30,50],
   		pager: '#article_pagered',
		//autowidth:true,
		gridview:true,
		viewrecords:true,
	onSelectRow: function(id){
		$("#startFrom_li").hide();
		var rowdata = jQuery('#article_list').getRowData(id);
		$("#borad_select").val(rowdata.board);
		$("#export_path").val(rowdata.export_path);
		$("#db_id_hidden").val(rowdata.ID);
		$("#clearBtn").show();
		$("#addBtn").val('修改');
		if(rowdata.transferTime=="00:30"){
			$('#tranfer_1').attr('checked', true);
		}else{
			$('#tranfer_2').attr('checked', true);
		}
	},
	editurl: "./server/deleteData.jsp",
});

jQuery("#article_list").jqGrid('navGrid','#article_pagered',  { edit: false, add: false, del: true, search: false, refresh: false }, //options 
{height:200,reloadAfterSubmit:false,  closeAfterEdit: true,
	serializeEditData: function (postdata) { 
	 var rowdata = jQuery('#article_list').getRowData(postdata.id);
      return {oper: postdata.oper, db_ID: rowdata.ID,dbname:'bbs_board_export_list',export_path:postdata.export_path};
 }}, // edit options 
{height:400,reloadAfterSubmit:true, closeAfterAdd: true, 
	serializeEditData: function (postdata) {
 }
}, // add options 
{reloadAfterSubmit:true,serializeDelData: function (postdata) {
	  refreshField();
	  var rowdata = jQuery('#article_list').getRowData(postdata.id);
      return {oper: postdata.oper, db_ID: rowdata.ID,dbname:'bbs_board_export_list'};
 }}, // del options 
{} // search options 
);
</script>
