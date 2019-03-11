<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="java.util.*"%> 
<%@ page import="java.text.SimpleDateFormat" %>
<%
boolean isCheckIn =  session.getAttribute("isLoginTag")==null ? false:(Boolean)session.getAttribute("isLoginTag");
if(!isCheckIn ){
	response.sendRedirect("login.html"); 
}

Calendar current = Calendar.getInstance();
current.add(current.DATE,-3);
SimpleDateFormat db_time_format = new SimpleDateFormat("yyyy-MM-dd");
String backdate = db_time_format.format(current.getTime());
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>IndexAsia亞洲指標</title>
<link href="css/indexasiaser.css" rel="stylesheet" type="text/css" />
<link href="css/dropdownmenu.css" rel="stylesheet" type="text/css" />
<link href="css/reset.css" rel="stylesheet" type="text/css" />
<script src="util.js" type="text/javascript"></script>
<!--
<script src="jquery-ui-1.7.2/js/jquery-1.3.2.min.js" type="text/javascript"></script>
<script src="jquery-ui-1.7.2/js/jquery-ui-1.7.2.min.js" type="text/javascript"></script>
<link href="jquery-ui-1.7.2/css/base/ui.core.css" rel="stylesheet" type="text/css" />
<link href="jquery-ui-1.7.2/css/base/ui.theme.css" rel="stylesheet" type="text/css" />
<link href="jquery-ui-1.7.2/css/base/ui.images.css" rel="stylesheet" type="text/css" />
JQGrid article table
<link rel="stylesheet" type="text/css" media="screen" href="JQGrid/theme/redmond/jquery-ui-1.8.1.custom.css" />
<link rel="stylesheet" type="text/css" media="screen" href="JQGrid/theme/ui.jqgrid.css" />
<link rel="stylesheet" type="text/css" media="screen" href="JQGrid/theme/ui.multiselect.css" />
<script src="JQGrid/js/jquery.js" type="text/javascript"></script>
<script src="JQGrid/js/jquery-ui-1.8.1.custom.min.js" type="text/javascript"></script>
<script src="JQGrid/js/jquery.layout.js" type="text/javascript"></script>
<script src="JQGrid/js/i18n/grid.locale-en.js" type="text/javascript"></script>
<script src="JQGrid/js/jquery.jqGrid.min.js" type="text/javascript"></script>
<script type="text/javascript">
	$.jgrid.no_legacy_api = true;
	$.jgrid.useJSON = true;
</script>-->
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
	
  $(function() {
		$("#menu>#nav>li:nth-child(3)").addClass("current");			
	});
	function addNewBoard(){
		$.post('./server/getData.jsp', {'query_type':"check_plurk_crawl_list",'keyword':encodeURIComponent($("#keyword").val())},
			function(JSONArr) {
				if(JSONArr.length>0){ //keyword is already exist in crawl list
					alert("此關鍵字已在擷取清單中");
				}else{
					var category = encodeURIComponent($("#category").val());
					var keyword = encodeURIComponent($("#keyword").val());
					$.post('./server/modifyNewKeyword.jsp', {'source_type':"plurk_crawl",'oper':"add",
					'category':category,'keyword':keyword,'startFrom':$("#startDate").val()},
						function(result) {
							result = trim(result);
							if(result=="done"){
								alert("更新完成");
								$("#article_list").jqGrid('setGridParam',{datatype:'json',sortname:'update_time',sortorder:'desc'}).trigger('reloadGrid');
								$("#account").val("");
								$("#type").val("");
								refreshField();
								//today = new Date();
								//$("#startDate").val(today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate());// set default
							}else{
								alert("更新失敗");
							}
						}
					);
				}
			}
		);
	};
	function refreshField(){		
		$("#category").val('');
		$("#keyword").val('');
	};
	
	/*20130128*/
	function search(){
		var searchKeyword = $("#search_field").val();
		var grid = jQuery("#article_list");
		grid.jqGrid('setGridParam',{postData:{query:"plurk_keyword_search",searchKeyword:searchKeyword}});
		grid.trigger("reloadGrid",[{page:1}]);
	};
	
	function reload(){
		var grid = jQuery("#article_list");
		grid.jqGrid('setGridParam',{postData:{query:"",searchKeyword:""}});
		grid.trigger("reloadGrid",[{page:1}]);
	};
	
	function exportList(){
		$.post('./server/exportList.jsp', {'query_type':"plurk_crawl_list"},
			function(file_path) {
			//	alert(file_path);
				document.location.href = file_path;
			}
		);
	};
</script>
</head>

<body>
<div id="wrapper" class="clear">
	<jsp:include page="menubar.jsp" />
    <div id="main">
	<div>
		<!--<table id="article_list"></table>
		<div id="article_pagered"></div>-->
		<h2>設定擷取關鍵字:Plurk</h2>
		<ul class="formframe">
		<div id="ptt">
		<li>分類：
		<input type="text" id="category" name="category" size="50" />&nbsp;ex:herbiron&nbsp;
		</li>
		<li>關鍵字：
		<input type="text" id="keyword" name="keyword" size="50" />&nbsp;四物鐵 李時珍(以空白為區隔，代表and)&nbsp;
		</li>
		<li>資料起始日期：
		<input type="text" id="startDate" name="startDate" size="30" style="position:relative;z-index:5" value="<%=backdate%>" disabled />&nbsp;
		※回溯更新預設為3天</li>
	<!--	<label>例行回溯天數</label>
		<select id="update_pastday" name="update_pastday">
			<option value="4" selected>4天</option>
			<option value="0">0天</option>
		</select>
		<br/><br/>-->
		</div>
		</ul>
	  <input type="button" value="送出" class="btnposition" onClick="addNewBoard()"><br/><br/><br/>
	  
	  <div style="padding-left:30px">關鍵字：<input type="text" id="search_field" name="search_field" size="30" />
	  <input type="button" value="搜尋" onClick="search()">
	  <input type="button" value="全部" onClick="reload()">
	   <input type="button" value="匯出全部" class="btnposition" style="margin-top:0px" onClick="exportList()">
	  </div><br/>
	  <div style="padding-left:30px;position:relative;z-index:2">
		<table id="article_list"></table>
		<div id="article_pagered"></div>
	  </div>
	</div>
</div><br/><br/>
<div id="footer"> 亞洲指標數位行銷股份有限公司版權所有 © 2012 Indexasia Digital Consulting co.,Inc. All Rights Reserved </div>
</div>
</body>
</html>
<script type="text/javascript">
	jQuery("#article_list").jqGrid({      
		url:"./server/articleTable_paging.jsp?datatype=plurkKeywordCrawlList&q=2", 
		datatype: "json",
	//datatype: "local",
		height: 260,
	//	colNames:['No','頁面名稱','頁面帳號','類別','資料設定起始','資料記錄起始'], //欄位名稱
		  colNames:['ID','No','分類','關鍵字','資料設定起始'], //欄位名稱
   		colModel:[
			{name:'ID',index:'ID', width:20, sorttype:"int", editable: false, hidden:true},
			{name:'No',index:'No', width:60, sorttype:"int", editable: false,align:"center",sortable:false},
			{name:'category',index:'category', width:180,sorttype:"text", editable: false},
			{name:'keyword',index:'keyword', width:380,sorttype:"text", editable: false},
			{name:'startFrom',index:'startFrom', width:150,sorttype:"int", editable: false,align:"center",},
		//	{name:'update_time',index:'update_time', width:200,sorttype:"int", editable: false,align:"center",},
			],
		rowNum:20,
   		rowList:[20,30,50],
   		pager: '#article_pagered',
		//autowidth:true,
		gridview:true,
		viewrecords:true,
	onSelectRow: function(id){
		
	},
	editurl: "./server/deleteData.jsp",
});

jQuery("#article_list").jqGrid('navGrid','#article_pagered',  { edit: false, add: false, del: true, search: false, refresh: false }, //options 
{height:400,reloadAfterSubmit:false,  closeAfterEdit: true,
	serializeEditData: function (postdata) {
    
 }}, // edit options 
{height:400,reloadAfterSubmit:true, closeAfterAdd: true, 
	serializeEditData: function (postdata) {
 }
	
	}, // add options 
{reloadAfterSubmit:true,serializeDelData: function (postdata) {
      var rowdata = jQuery('#article_list').getRowData(postdata.id);
      return {oper: postdata.oper, db_ID: rowdata.ID,dbname:'plurk_keyword_crawl_list'};
 }}, // del options 
{} // search options 
);
</script>
