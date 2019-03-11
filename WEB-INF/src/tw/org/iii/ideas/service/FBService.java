package tw.org.iii.ideas.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class FBService {
	private Connection conn;
	private String FBDB_ip="";  
	private String FBDB_dbname = "";
	private String FBDB_username = "";
	private String FBDB_pw = "";
	
	public FBService(){
		File dbinfoFile = new File("ibuzz_dbinfo.properties");
		try {
			System.out.println("ibuzz path="+dbinfoFile.getAbsolutePath());
			if (dbinfoFile.exists()) {
				FileInputStream fileStream;
			//	System.out.println("path="+dbinfoFile.getAbsolutePath());
					fileStream = new FileInputStream(dbinfoFile);
				
				Properties properties = new Properties();
				properties.load(fileStream);
	
				FBDB_ip = properties.getProperty("FBDB_ip");
				FBDB_dbname = properties.getProperty("FBDB_dbname");  // infoviz_crawl_analysis
				FBDB_username = properties.getProperty("FBDB_username");
				FBDB_pw = properties.getProperty("FBDB_pw");
				
			}
			System.out.println(FBDB_ip+"&"+FBDB_dbname+"&"+
					FBDB_username+"&"+FBDB_pw);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public Connection getDBConn() throws InstantiationException, IllegalAccessException, ClassNotFoundException, SQLException{
		connectionDB();
		return conn;
	}
	
	private synchronized void connectionDB() throws InstantiationException,
	IllegalAccessException, ClassNotFoundException, SQLException {
		if (conn == null || conn.isClosed()) {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			String connectionloc = "jdbc:mysql://"+FBDB_ip+":3306/" + FBDB_dbname
					+ "?user=" + FBDB_username + "&password=" + FBDB_pw;
		//	System.out.println("conntect db="+connectionloc);
			conn = DriverManager.getConnection(connectionloc);
		}
	}
}
