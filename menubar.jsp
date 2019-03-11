<div id="header"><img src="images/logo.gif" width="260" height="28" /> <input type="button" style="float:right" value="登出" onClick="logout()"> </div>
<div id="menu" style="position:relative;z-index:999">
	<ul id="nav">
			<li ><a href="#">首頁</a></li>
			<li><a href="#">設定版塊來源</a>
				<ul>
					<li><a href="source_add_bbs.jsp">PTT</a></li>
			  <li><a href="source_add_fb.jsp">Facebook</a></li>
			</ul>
		  </li>
			<li><a href="#">設定關鍵字</a>
				<ul>
					<li><a href="keyword_add_fb.jsp">Facebook關鍵字</a></li>
					<!--<li><a href="keyword_add_plurk.jsp">Plurk關鍵字</a></li>-->
				</ul>
			</li>
			<li><a href="#">固定報表</a>
				<ul>
				<li><a href="export_bbs_board.jsp">PTT電子報</a></li>
				<li><a href="export_fb_page.jsp">FB官方粉絲頁監測報表</a></li>
				<li><a href="export_fb_keyword.jsp?export_type=2">FB廣大搜尋報表</a></li>
				<li><a href="export_fb_keyword.jsp?export_type=6">FB廣大搜尋群組報表</a></li>
				<li><a href="export_fb_keyword.jsp?export_type=3">FB日報表</a></li>
				<li><a href="export_fb_rank.jsp">FB排行榜</a></li>
				<li><a href="export_fb_keyword.jsp?export_type=4">FB關鍵字搜尋</a></li>
				<li><a href="export_bbs_keyword.jsp">PTT關鍵字搜尋</a></li>
				<!--<li><a href="export_plurk_keyword.jsp">Plurk關鍵字搜尋</a></li>-->
			 </ul></li>		

			<li><a href="#">單次報表</a>
				<ul>
				<li><a href="export_fb_page_single.jsp">FB官方粉絲頁監測報表</a></li>
				<li><a href="export_fb_keyword_single.jsp?export_type=2">FB廣大搜尋報表</a></li>
					<li><a href="export_fb_keyword_single.jsp?export_type=3">FB日報表</a></li>
					<li><a href="export_fb_keyword_single.jsp?export_type=5">FB話題列表</a></li>
					<li><a href="export_fb_keyword_single.jsp?export_type=7">FB群組話題列表</a></li>
					<li><a href="export_fb_user_online.jsp">FB回應使用者清單</a></li>
			  </ul>
		   </li>
		</ul>
</div>
<div style="clear:left"></div>