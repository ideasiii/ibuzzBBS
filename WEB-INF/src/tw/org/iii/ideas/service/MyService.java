package tw.org.iii.ideas.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class MyService {
	private Connection conn;
	private Connection FBconn;
	private String analysisDB_ip="124.9.6.28";  
	private String analysisDB_dbname = "ibuzz";
	private String analysisDB_username = "root";
	private String analysisDB_pw = "blogserv2010";
	private String webpage_title = "blogserv2010";
	private String log_path = "";
	
	private String FBDB_ip="124.9.6.28";  
	private String FBDB_dbname = "ibuzz";
	private String FBDB_username = "root";
	private String FBDB_pw = "blogserv2010";
	
	public MyService(){
		File dbinfoFile = new File("ibuzz_dbinfo.properties");
		try {
			System.out.println("ibuzz path="+dbinfoFile.getAbsolutePath());
			if (dbinfoFile.exists()) {
				FileInputStream fileStream;
			//	System.out.println("path="+dbinfoFile.getAbsolutePath());
					fileStream = new FileInputStream(dbinfoFile);
				
				Properties properties = new Properties();
				properties.load(fileStream);
	
				analysisDB_ip = properties.getProperty("analysisDB_ip");
				analysisDB_dbname = properties.getProperty("analysisDB_dbname");  // infoviz_crawl_analysis
				analysisDB_username = properties.getProperty("analysisDB_username");
				analysisDB_pw = properties.getProperty("analysisDB_pw");
				
				FBDB_ip = properties.getProperty("FBDB_ip");
				FBDB_dbname = properties.getProperty("FBDB_dbname");  // infoviz_crawl_analysis
				FBDB_username = properties.getProperty("FBDB_username");
				FBDB_pw = properties.getProperty("FBDB_pw");
				
				webpage_title = properties.getProperty("webpage_title");
				log_path=properties.getProperty("log_path");
			}
			System.out.println(analysisDB_ip+"&"+analysisDB_dbname+"&"+
					analysisDB_username+"&"+analysisDB_pw);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public String getWebpage_title() {
		return webpage_title;
	}
	
	public String getLog_path() {
		return log_path;
	}

	public Connection getDBConn() throws InstantiationException, IllegalAccessException, ClassNotFoundException, SQLException{
		connectionDB();
		return conn;
	}
	
	private synchronized void connectionDB() throws InstantiationException,
	IllegalAccessException, ClassNotFoundException, SQLException {
		if (conn == null || conn.isClosed()) {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			String connectionloc = "jdbc:mysql://"+analysisDB_ip+":3306/" + analysisDB_dbname
					+ "?user=" + analysisDB_username + "&password=" + analysisDB_pw
					+ "&useUnicode=true&characterEncoding=utf-8";
		//	System.out.println("conntect db="+connectionloc);
			conn = DriverManager.getConnection(connectionloc);
		}
	}
	
	public Connection getFDBConn() throws InstantiationException, IllegalAccessException, ClassNotFoundException, SQLException{
		connectionFBDB();
		return FBconn;
	}
	
	private synchronized void connectionFBDB() throws InstantiationException,
	IllegalAccessException, ClassNotFoundException, SQLException {
		if (FBconn == null || FBconn.isClosed()) {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			String connectionloc = "jdbc:mysql://"+FBDB_ip+":3306/" + FBDB_dbname
					+ "?user=" + FBDB_username + "&password=" + FBDB_pw
					+ "&useUnicode=true&characterEncoding=utf-8";
		//	System.out.println("conntect db="+connectionloc);
			FBconn = DriverManager.getConnection(connectionloc);
		}
	}
	
	public void test(){
		String keyword="";
		String[] keywords = keyword.split("AND");  
		  for(int i=0;i<keywords.length;i++){
		      String Keyword_single=keywords[i].toString().replace(" ", "");
		      if(i!=keywords.length-1){
		          keyword = keyword + Keyword_single + " AND ";
		      }else{
		    	  keyword = keyword + Keyword_single ;
		      }
		  }
		  boolean isexist=false;
	}
}
