 
  function trim(words) 
  {
    return words.replace(/^\s+|\s+$/g, "");
  }; 
  
  function endsWith(haystack,needle,isCaseSensitive){  
	  if(isCaseSensitive){  
	   haystack=haystack.toUpperCase();  
	   needle=needle.toUpperCase();  
	  }  
	  return haystack.substr(-1*needle.length)==needle?true:false;  
 }; 
   
   //cancel the download link - for specific screen capture downloading
   function cancelLink(){
		document.getElementById('downloadArea').innerHTML = "";
   }
   	function checkSessionAlive(){
		$.post('checkSessionAlive.jsp', {},function(result) {
			result = trim(result);
			if(result=="false"){
			//	alert("請重新登入");
				parent.document.location.href = "login.html";
			}
		})
	};
	function logout(){
		$.post('clear_login_session.jsp', {},function(result) {parent.document.location.href = "login.html";})
	};