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

String dbname = "category";
fieldVector.add("category");
conditionFieldVector.add("type");
conditionFieldValueVector.add("1");
JSONArray itemJSONArr = srv.getSettings(dbname,fieldVector,conditionFieldVector,conditionFieldValueVector,0,0,"CONVERT(category using big5)","asc");
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
</style>
<script type="text/javascript">
   //http://www.ezzylearning.com/tutorial.aspx?tid=6942119
  $(function() {
		$("#menu>#nav>li:nth-child(2)").addClass("current");
		$("#clearBtn").hide();
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
		$("#startDate").val(today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate());
		$("#startDate").datepicker(pickerOpts);
		//$("#startDate").datepicker(pickerOpts,today.getFullYear()+"-"+today.getMonth()+"-"+today.getDate());
		//console.log(today.getFullYear()+"-"+today.getMonth()+"-"+today.getDate());
		
		
	});
	function addNewBoard(){
		var oper;
		var db_ID = $("#page_id").val();
		if(db_ID==""){
			oper = "add";
		}else{
			oper = "edit";
		}
		$.post('./server/getData_FB.jsp', {'query_type':"check_fb_crawl_list",'account':$("#account").val()},
			function(JSONArr) {
				if(JSONArr.length>0 && oper =='add'){ //board is already exist in crawl list
					alert("此版塊已在擷取清單中");
				}else{
					var page_name = encodeURIComponent($("#name").val().replace(/\'/g , ""));
					$.post('./server/addNewFB.jsp', {'source_type':"fb",'oper':oper,'account':$("#account").val(),'name':page_name,'type':$("#type").val(),'date':$("#startDate").val(),'category':encodeURIComponent($("#category").val()),'back_day':encodeURIComponent($("#backday").val())},
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
								
							}else{
								alert("更新失敗:"+result);
							}
						}
					);
				}
			}
		);
	};
	function editNewCategory(oper){
		var category = encodeURIComponent($("#addcategory").val().replace(/\'/g , ""));
		var oper_string = "";
		if(oper=="add"){
		    oper_string = "新增";
		}else{
		    oper_string = "刪除";
		}
		if(confirm("確定" + oper_string + "分類「" + $("#addcategory").val() + "」?")){
		
		$.post('./server/getData_category.jsp', {'category':category,'type':'1'},
			function(JSONArr) {
				if(JSONArr.length>0&&oper=="add"){ //board is already exist in crawl list
					alert("此分類已在清單中");
				}else{
					$.post('./server/addNewCategory.jsp', {'oper':oper,'category':category,'type':'1'},
						function(result) {
							result = trim(result);
							if(result=="done"){
								alert("更新完成");
								location.reload();
							}else{
								alert("更新失敗:"+result);
							}
						}
					);
				}
			}
		);
	}
	};
	
	/*20130128*/
	function search(){
		var searchKeyword = $("#search_field").val();
		var grid = jQuery("#article_list");
		grid.jqGrid('setGridParam',{postData:{query:"fbCrawlList_Search",searchKeyword:searchKeyword}});
		grid.trigger("reloadGrid",[{page:1}]);
	};
	
	function reload(){
		var grid = jQuery("#article_list");
		grid.jqGrid('setGridParam',{postData:{query:"",searchKeyword:""}});
		grid.trigger("reloadGrid",[{page:1}]);
	};
	
	function exportList(){
		$.post('./server/exportList_FB.jsp', {'query_type':"fb_crawl_list"},
			function(file_path) {
			//	alert(file_path);
				document.location.href = file_path;
			}
		);
	};
	
	function exportErrorList(){
		alert('test');
		$.post('./server/exportList_FB.jsp', {'query_type':"fb_crawl_list_error"},
			function(file_path) {
			//	alert(file_path);
				document.location.href = file_path;
			}
		);
	};
  function refreshField(){
  	$("#addBtn").val('新增');
		$("#page_id").val("");
		$("#clearBtn").hide();
		$("#account").val("");
		$("#type").val("");
		$("#name").val("");
		$("#category").val("");
		today = new Date();
		$("#startDate").val(today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate());// set default
		$("#account").attr('disabled', '');
		$("#type").attr('disabled', '');};
  
</script>
</head>

<body>
	
<div id="wrapper" class="clear">
	<jsp:include page="menubar.jsp" />
    <div id="main">
	<div>
		<!--<table id="article_list"></table>
		<div id="article_pagered"></div>-->
		<h2>設定版塊來源:FB</h2>
		<ul class="formframe">
		<div id="ptt">
		<li>分類：
		<select id="category" name="category"></>
		<% for(int i=0; i<itemJSONArr.length(); i++){
			JSONObject itemJSON =  (JSONObject)itemJSONArr.get(i);
		%>
		  <option value="<%=itemJSON.getString("category")%>"><%=itemJSON.getString("category")%></option>
		<%}%>
	</select><input type="text" id="addcategory" name="addcategory" size="5"></input><input type="button" value="新增分類" onclick="editNewCategory('add');"><input type="button" value="刪除分類" onclick="editNewCategory('delete');"></input>
		</li>
		<li>頁面名稱：
		<input type="text" id="name" name="name" size="50" />
		</li>
		<li>頁面帳號：
		<input type="text" id="account" name="account" size="50" />
		</li>
		<li>類別：
		<select id="type" name="type">
		  <option value="2">個人公開</option>
		  <option value="3">公開社團</option>
		  <option value="1">粉絲頁</option>
		  <option value="4">公開活動</option>
	  </select>
		</li>
		<li>資料起始日期：
		<input type="text" id="startDate" name="startDate" size="30" style="position:relative;z-index:5" disabled />&nbsp;(最多90天)
		※回溯更新預設為3天</li>
		<li>例行回溯天數：
			<select id="backday" name="backday">
		  <option value="5" checked>5天</option>
		  <option value="15">15天</option>
	    </select>
		</li>
	<!--	<label>例行回溯天數</label>
		<select id="update_pastday" name="update_pastday">
			<option value="4" selected>4天</option>
			<option value="0">0天</option>
		</select>
		<br/><br/>-->
		<input type="hidden" name="page_id" id="page_id" value=""/>
		</div>
		</ul>
	  <input id="addBtn" type="button" value="新增" class="btnposition" onClick="addNewBoard()">
	  <input id="clearBtn" type="button" value="清空" class="btnposition" onClick="refreshField()"><br/><br/><br/>
	  <!--<hr style="height: '2'; text-align: 'left'; color: '#FF0000'; width: '70%'">-->
	  <div style="padding-left:30px">關鍵字：<input type="text" id="search_field" name="search_field" size="30" />
	  <input type="button" value="搜尋" onClick="search()">
	  <input type="button" value="全部" onClick="reload()"> 
	  <input type="button" value="匯出全部" class="btnposition" style="margin-top:0px" onClick="exportList()">
	  <input type="button" value="匯出異常" class="btnposition" style="margin-top:0px" onClick="exportErrorList()">
	  </div>
	  <div style="padding-left:30px;position:relative;z-index:2">
		<table id="article_list"></table>
		<div id="article_pagered"></div>
	  </div>
	</div>
</div><br/><br/>
<div id="footer"> 亞洲指標數位行銷股份有限公司版權所有 © 2012 Indexasia Digital Consulting co.,Inc. All Rights Reserved </div>

</body>
</html>
<script type="text/javascript">
	jQuery("#article_list").jqGrid({      
		url:"./server/fblistTable_paging.jsp?datatype=fbCrawlList", 
		datatype: "json",
	//datatype: "local",
		height: 530,
		width:800,
	//	colNames:['No','頁面名稱','頁面帳號','類別','資料設定起始','資料記錄起始'], //欄位名稱
		  colNames:['No','分類','頁面名稱','頁面帳號','類別','資料設定起始','例行回溯天數','page_id'], //欄位名稱
   		colModel:[
			{name:'No',index:'No', width:50, sorttype:"int", editable: false,align:"center",sortable:false,sortable:false},
			{name:'page_category',index:'page_category', width:90,sorttype:"text", editable: false},
			{name:'page_name',index:'page_name', width:230,sorttype:"text", editable: false},
			{name:'page_account',index:'page_account', width:90,sorttype:"text", editable: false,sortable:false},
			{name:'page_type',index:'page_type', width:60,sorttype:"int", editable: false,align:"center",},
			{name:'startFrom',index:'startFrom', width:80,sorttype:"int", editable: false,align:"center",sortable:false},
			{name:'back_day',index:'back_day', width:90,sorttype:"int", editable: false,align:"center",sortable:false},
			{name:'page_id',index:'page_id', width:20, sorttype:"int", editable: false, hidden:true},
		//	{name:'update_time',index:'update_time', width:200,sorttype:"int", editable: false,align:"center",},
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
	  $("#name").val(rowdata.page_name);
		$("#account").val(rowdata.page_account);
		$("#startDate").val(rowdata.startFrom);
		$("#category").val(rowdata.page_category);
		$("#page_id").val(rowdata.page_id);
		$("#addBtn").val('修改');
		$("#clearBtn").show();
		$("#account").attr('disabled', 'disabled');
		if(rowdata.page_type=='粉絲頁'){
		   $("#type").val('1');
		   $("#type").attr('disabled', 'disabled');
		}	
		if(rowdata.page_type=='個人公開'){
		   $("#type").val('2');
		   $("#type").attr('disabled', 'disabled');
		}	
		if(rowdata.page_type=='公開社團'){
		   $("#type").val('3');
		  $("#type").attr('disabled', 'disabled');
		}	
		if(rowdata.page_type=='公開活動'){
		   $("#type").val('4');
		  $("#type").attr('disabled', 'disabled');
		}	
	},
	editurl: "./server/deleteData_FB.jsp",
});

jQuery("#article_list").jqGrid('navGrid','#article_pagered',  { edit: false, add: false, del: true, search: false, refresh: false }, //options 
{}, // edit options 
{}, // add options 
{reloadAfterSubmit:true,
 serializeDelData: function (postdata) {
    var rowdata = jQuery('#article_list').getRowData(postdata.id);
    return {oper: postdata.oper, page_account: rowdata.page_account,dbname:'fb_crawl_list'};
    refreshField();
 },
 afterSubmit: function ( response, postdata) {
    alert(response.responseText.replace(/^\s+|\s+$/g, ""));
    return [true,""]
 }
}, // del options 
{} // search options 
);
</script>
