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

		var board_select_obj = $("#board_select");
		board_select_obj.multiselect({noneSelectedText:"請選擇",selectedText:"已勾選 # 個選項",checkAllText:"全選",uncheckAllText:"取消"} );//PTT 版塊

		<% for(int i=0; i<itemJSONArr.length(); i++){
			JSONObject itemJSON =  (JSONObject)itemJSONArr.get(i);
		%>
		board_select_obj.append($('<option></option>').attr('value',"<%=itemJSON.getString("board")%>").text("<%=itemJSON.getString("board")%>"));
		<%}%>
		board_select_obj.multiselect('refresh');
		
		
		var scntDiv = $('#keywordTextInputArea');
		var keywordInputCount = $('#keywordTextInputArea p').size() + 1;
		//keywordInput add button
		 $("#addKeywordInputBtn").click(function(){
			$('<p><label for="p_scnts"><input type="text" id="p_scnt" size="90" name="p_scnt_' + keywordInputCount +'" value="" placeholder="Input Value" /></label> <input type="button" id="remScnt" value="移除"/></p>').appendTo(scntDiv);
			keywordInputCount++;
			return false;
        });
		
		$('#remScnt').live('click', function() { 
			if( keywordInputCount > 2 ) {
					$(this).parents('p').remove();
					keywordInputCount--;
			}
			return false;
        });
	});
	
	function addNewKeyword(){
		var oper;
		var db_ID = $("#db_id_hidden").val();
		if(db_ID==""){
			oper = "add";
		}else{
			oper = "edit";
		}
		
		var selected_board ="";
		var board_multipleValues = $("#board_select").val() || [];
		for(var i=0; i< board_multipleValues.length; i++){
			selected_board += board_multipleValues[i]+",";
		}
		if(selected_board.length >0){
			selected_board = selected_board.substring(0,selected_board.length-1);
		}
		
		var keywordSets ="";
		$("#keywordTextInputArea>p>label>input").each(function(){
			keywordSets += $(this).val()+"Ω";
		});
		keywordSets = keywordSets.substring(0,keywordSets.length-1);
		keywordSets = encodeURIComponent(keywordSets);
		
		var path = encodeURIComponent($("#export_path").val());
		
		$.post('./server/modifyNewKeyword.jsp', {'source_type':"bbs",'oper':oper,'db_ID':db_ID,'board':selected_board,
		'keywordSets':keywordSets,'export_path':path},
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
		var board_select = $("#board_select");
		board_select.find("option:selected").attr('selected',false);
		board_select.multiselect('refresh');

		$("#p_scnt").val("");
		var keywordInputCount = $('#keywordTextInputArea p').size();
		//console.log("keywordInputCount="+keywordInputCount);
		if( keywordInputCount > 1 ) {
		//	console.log("here");
			for(var i = keywordInputCount; i>1; i--){
				$("#keywordTextInputArea>p:last-child").remove();
				keywordInputCount--;
			}
		}
		
		
		$("#export_path").val("");
		$("#db_id_hidden").val("");
		$("#addBtn").val('新增');
		$("#clearBtn").hide();
	};
	
	function exportList(){
		$.post('./server/exportList.jsp', {'query_type':"bbs_keyword_export"},
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
		<h2>固定報表：PTT關鍵字搜尋</h2>
		<input type="button" value="匯出" class="btnposition" style="margin-top:-20px" onClick="exportList()"/><br/>
		<div style="padding-left:30px;position:relative;z-index:2">
			<table id="article_list"></table>
			<div id="article_pagered"></div>
	    </div><br/>
		<ul class="formframe">
		<div id="ptt">
		<li>週期：<br/>一日三次&nbsp;&nbsp;匯出時間:每日07:00、15:00、23:00</li>
		<li>請選擇PTT版塊(多選)：<select name="board_select" id="board_select" multiple="multiple">
		
		</select>
		</li>
		<li>請設定PTT關鍵字(可使用AND、OR、NOT)：<br/>
		<div id="keywordTextInputArea">
		<!--<input type="text" id="keyword" name="keyword" size="52" style="position:relative;z-index:5"/>-->
		  <p>
        <label for="p_scnts"><input type="text" id="p_scnt" size="90" name="p_scnt" value="" placeholder="Input Value" /></label><input type="button" id="addKeywordInputBtn" value="新增一組"/>
			</p>
		</div></li>
		<li>請輸入路徑：
		<input type="text" id="export_path" name="export_path" size="90" /></li>
		<input id="db_id_hidden" name="db_id_hidden" value="" type="hidden" />
		</div>
		</ul>
	  <input type="button" id="addBtn" value="新增" class="btnposition" onClick="addNewKeyword()" />
	  <input id="clearBtn" type="button" value="清空" class="btnposition" onClick="refreshField()" /><br/><br/><br/>
	  
	</div>
</div><br/><br/>
<div id="footer"> 亞洲指標數位行銷股份有限公司版權所有 © 2012 Indexasia Digital Consulting co.,Inc. All Rights Reserved </div>
</div>
</body>
</html>
<script type="text/javascript">
//for ie not support array indexOf
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
		url:"./server/articleTable_paging.jsp?datatype=bbsKeywordExportList&q=2", 
		datatype: "json",
	//datatype: "local",
		height: 260,
		colNames:['ID','No','版塊名稱','路徑'], //欄位名稱
   		colModel:[
			{name:'ID',index:'ID', width:20, sorttype:"int", editable: false, hidden:true},
			{name:'No',index:'No', width:20, sorttype:"int", editable: false,align:"center",sortable:false},
			{name:'board',index:'board', width:370,sorttype:"text", editable: true,editoptions:{size:50}},
			{name:'export_path',index:'export_path', width:365,sorttype:"int", editable: true},
			],
		rowNum:10,
   		rowList:[10,30,50],
   		pager: '#article_pagered',
		//autowidth:true,
		gridview:true,
		viewrecords:true,
	onSelectRow: function(id){
		refreshField();
	
		var rowdata = jQuery('#article_list').getRowData(id);	
		var board_arr = rowdata.board.split(",");
		var board_select = $("#board_select");
		board_select.empty();//清空
		board_select.multiselect('refresh');

		<% for(int i=0; i<itemJSONArr.length(); i++){
			JSONObject itemJSON =  (JSONObject)itemJSONArr.get(i);%>
			if( board_arr.indexOf('<%=itemJSON.getString("board")%>') != -1){
				board_select.append($('<option></option>').attr('value', "<%=itemJSON.getString("board")%>").attr("selected", true).text("<%=itemJSON.getString("board")%>"));
			}else{
				board_select.append($('<option></option>').attr('value', "<%=itemJSON.getString("board")%>").text("<%=itemJSON.getString("board")%>"));
			}
		<%}%>	
		board_select.multiselect('refresh');

		var scntDiv = $('#keywordTextInputArea');
		var keywordInputCount = $('#keywordTextInputArea p').size() + 1;
	//	console.log("clicked keywordInputCount="+keywordInputCount);
		//reload keyword sets

		$.post('./server/getData.jsp', {'query_type':"bbs_keyword_detail",'export_id':rowdata.ID},
			function(JSONArr) {
				if(JSONArr.length>0){
					var jsonObject = JSONArr[0];

					$("#p_scnt").val(jsonObject.keyword);
					//console.log("jsonObject.keyword="+theKeyword);
					for(var i=1; i<JSONArr.length; i++){
						jsonObject = JSONArr[i];
						//console.log("jsonObject.keyword="+theKeyword);
						$('<p><label for="p_scnts"><input type="text" id="p_scnt_' + keywordInputCount +'" size="90" name="p_scnt_' + keywordInputCount +'" value="" placeholder="Input Value" /></label> <input type="button" id="remScnt" value="移除"/></p>').appendTo(scntDiv);
						$("#p_scnt_"+ keywordInputCount).val(jsonObject.keyword);
						
						keywordInputCount++;
					}
					
					$('#remScnt').live('click', function() { 
						if( keywordInputCount > 2 ) {
								$(this).parents('p').remove();
								keywordInputCount--;
						}
						return false;
					});
				}
			}
		);
		
		$("#export_path").val(rowdata.export_path);
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
	  $.post('./server/deleteData.jsp', {oper: postdata.oper,'db_ID':rowdata.ID,dbname:'bbs_keyword_export_detail'},
			function(result) {}
		);
      return {oper: postdata.oper, db_ID: rowdata.ID,dbname:'bbs_keyword_export_list'};
 }}, // del options 
{} // search options 
);
</script>
