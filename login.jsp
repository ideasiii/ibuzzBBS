<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@page import="java.util.UUID"%>
    
<%
	final String strHostUrl = request.getRequestURL().toString();
	if (response.containsHeader("SET-COOKIE")) {
		String sessionid = request.getSession().getId();
		response.setHeader("SET-COOKIE", "JSESSIONID=" + sessionid + ";secure;HttpOnly");
	}

	String uuid = UUID.randomUUID().toString().replaceAll("-", "");
	request.getSession().setAttribute("randTxt", uuid);
%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>IndexAsia亞洲指標</title>
<!--<script src="jquery-ui-1.7.2/js/jquery-1.3.2.min.js" type="text/javascript"></script>-->
<script src="jquery-ui-1.7.2/js/jquery.min.js" type="text/javascript"></script>
<script src="jquery-ui-1.7.2/js/jquery-ui-1.12.1.min.js" type="text/javascript"></script>
<script type="text/javascript" src="util.js"></script>
<link href="css/base-admin.css" rel="stylesheet">
<link href="css/bootstrap/css/bootstrap.css" rel="stylesheet">
<style type="text/css">
      body {
        padding-top: 40px;
        padding-bottom: 40px;
        background-color: #f5f5f5;
      }

      .form-signin {
        max-width: 300px;
        padding: 19px 29px 29px;
        margin: 0 auto 20px;
        background-color: #fff;
        border: 1px solid #e5e5e5;
        -webkit-border-radius: 5px;
           -moz-border-radius: 5px;
                border-radius: 5px;
        -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.05);
           -moz-box-shadow: 0 1px 2px rgba(0,0,0,.05);
                box-shadow: 0 1px 2px rgba(0,0,0,.05);
      }
      .form-signin .form-signin-heading,
      .form-signin .checkbox {
        margin-bottom: 10px;
      }
      .form-signin input[type="text"],
      .form-signin input[type="password"] {
        font-size: 16px;
        height: auto;
        margin-bottom: 15px;
        padding: 7px 9px;
      }

    </style>
<script type="text/javascript">
var uuid = uuid();
function uuid() {
	function s4() {
		return Math.floor((1+Math.random())*0x10000).toString(16).substring(1);
	}
	return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() +s4() +s4();
}
function xmlhttpPost_loginCheck(){
		var account = document.getElementById('account_txtField').value;
		var pw = document.getElementById('pw_txtField').value;
		if(account=="" || pw ==""){
			document.getElementById('error_msg_field').innerHTML= "您輸入的帳號或密碼錯誤";
		}else{
			$.post('login_check.jsp', {'account':account,'pw':pw,'uuid':uuid},
					function(result) {
						if(escape(result)!="%0D%0A"){
							result = trim(result);
							if(result == "true"){//帳號密碼正確
								document.location.href = "source_add_bbs.jsp";
							}else{
								document.getElementById('error_msg_field').innerHTML= "您輸入的帳號或密碼錯誤";
							}
						}
					}
			);
		}
}; 

function init() {	
	//restoreFilter();
	$(document).keypress(function(e) {
		 if(e.keyCode == 13) {
				xmlhttpPost_loginCheck();
				return false;
		   }
	});
};
$(document).ready(init);
</script>
</head>

<body>
<!--<div id="sysname" align="center"><img src="images/nsb_ser.png" width="226" height="70" /></div>
<div id="loginarea"><table width="225" border="0" align="center" cellpadding="3">
	<tr>
		<td width="215" align="center"><label>
		  <label id="error_msg_field"></label>
		</label></td>
  </tr>
  <tr>
    <td width="215" align="right"><label>
      帳號：
      <input type="text" name="account_txtField" id="account_txtField" class="textfield"/>
    </label></td>
  </tr>
  <tr>
    <td width="215"  align="right">密碼：      <input type='password' name="pw_txtField" id="pw_txtField"  class="textfield"/></td>
  </tr>
  <tr>
    <td align="right"><label>
      <input type="submit" name="button" id="button" value="Submit" class="btn" onclick="xmlhttpPost_loginCheck();"/>
    </label></td>
  </tr>
</table>
</div>-->

<div class="container">

  <form class="form-signin" autocomplete="off">
	<div align="center"><h3>IndexAsia</h3></div>
	<input type="hidden" name="randSession" value="<%=request.getSession().getAttribute("randTxt")%>" />
	<input type="text" id="account_txtField" class="input-block-level" placeholder="Account">
	<input type="password" id="pw_txtField" class="input-block-level" placeholder="Password">
	<button class="btn btn-large btn-primary" type="button" onclick="xmlhttpPost_loginCheck();">Sign in</button>
	 <label id="error_msg_field"></label>
  </form>

</div> 
</body>
</html>
