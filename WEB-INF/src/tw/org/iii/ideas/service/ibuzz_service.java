package tw.org.iii.ideas.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Vector;
import java.util.Calendar;
import java.text.SimpleDateFormat;

import org.json.JSONArray;
import org.json.JSONObject;

import tw.org.iii.ideas.log.LogGenerator;

public class ibuzz_service extends MyService{
	private SimpleDateFormat filename_time_format = new SimpleDateFormat("yyyy-MM-dd_HHmmss");
	private SimpleDateFormat full_time_format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	
	public JSONObject checkLoginAccount(String account, String pw,String remoteAddr){
		JSONObject loginObject = new JSONObject();
		try {
			Connection analysis_conn = getDBConn();
			
			Calendar current = Calendar.getInstance();
			//login record
			Statement statement = analysis_conn.createStatement();
			String dataSql ="";
		    dataSql = "INSERT INTO "
					+ "login_log ("
					+ "account, password, login_time, ip) VALUES ("
					+ "'" + account + "','" + pw+ "', '"+full_time_format.format(current.getTime())+"'," +
							"'"+remoteAddr+"' )";
		    
			statement.executeUpdate(dataSql);
			
			String sql = "SELECT * from login_account where account='"+account+"'";
		//	System.out.println("checkLoginAccount="+sql);
			 PreparedStatement ps = analysis_conn.prepareStatement(sql);
			 ResultSet dataRS;
			 dataRS = ps.executeQuery();
			 String realPW="";
			 if(dataRS.next()) {
				 realPW = dataRS.getString("password");
			 }
			 if(pw.equals(realPW)){
				 loginObject.put("isLogin", true);
			 }else{
				 loginObject.put("isLogin", false);
			 }
			 if(dataRS != null){
				dataRS.close();
				dataRS = null;
			 }
			 ps.close();
			 ps=null;
			 statement.close();
			 statement = null;
			 analysis_conn.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	//	System.out.println("isLogin="+projectID);
		return loginObject;
	}
	
	public int getSettingsCount(String dbname, Vector<String> conditionFieldVector,Vector<String> conditionFieldValue){
		int count = 0;
		try {
			Connection conn = getDBConn();
			
			String conditionQuery="";
			if(conditionFieldVector !=null && conditionFieldVector.size()>0 && (conditionFieldVector.size() ==conditionFieldValue.size())){
				conditionQuery = " where ";
				
				for(int i=0; i<conditionFieldVector.size(); i++){
					conditionQuery += conditionFieldVector.get(i)+"='"+conditionFieldValue.get(i)+"' and ";
				}
				conditionQuery = conditionQuery.substring(0, conditionQuery.length()-4);
			}
			
			String sql ="";
			sql = "SELECT count(*) count from "+dbname+conditionQuery;
			
			System.out.println("getSettingsCount="+sql);
			 LogGenerator.LogWithTime(getLog_path(), "getSettings="+sql);
			 PreparedStatement ps = conn.prepareStatement(sql);
			 ResultSet dataRS;
			 dataRS = ps.executeQuery();
			 while(dataRS.next()) {
				 count = dataRS.getInt("count");
			 }
			 if(dataRS != null){
				dataRS.close();
				dataRS = null;
			 }
			 ps.close();
			 ps=null;
			 conn.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		return count;
	}
	
	public JSONArray getSettings(String dbname, Vector<String> fieldVector,
			Vector<String> conditionFieldVector,Vector<String> conditionFieldValue, int start, int limit,
			String sortField, String sortType){
		JSONArray resultJsonArr = new JSONArray();
		try {
			Connection conn = getDBConn();
			
			String conditionQuery="";
			if(conditionFieldVector !=null && conditionFieldVector.size()>0 && (conditionFieldVector.size() ==conditionFieldValue.size())){
				conditionQuery = " where ";
				
				for(int i=0; i<conditionFieldVector.size(); i++){
					conditionQuery += conditionFieldVector.get(i)+"='"+conditionFieldValue.get(i)+"' and ";
				}
				conditionQuery = conditionQuery.substring(0, conditionQuery.length()-4);
			}
			
			String getFieldStr = "";
			for(int i=0 ; i<fieldVector.size(); i++){
				getFieldStr += fieldVector.get(i)+",";
			}
			if(getFieldStr.length()>0){
				getFieldStr = getFieldStr.substring(0,getFieldStr.length()-1);
			}
			String sortStr = "";
			if(!sortField.equals("")){
				sortStr = " order by "+sortField+" "+sortType;
			}
			
			String sql ="";
			if(limit==0){
				sql = "SELECT "+getFieldStr+" from "+dbname+conditionQuery+sortStr;
			}else{
				sql = "SELECT "+getFieldStr+" from "+dbname+conditionQuery+sortStr+" limit "+start+","+limit;
			}
			
			System.out.println("getSettings="+sql);
			 LogGenerator.LogWithTime(getLog_path(), "getSettings="+sql);
			 PreparedStatement ps = conn.prepareStatement(sql);
			 ResultSet dataRS;
			 dataRS = ps.executeQuery();
			 while(dataRS.next()) {
				 JSONObject cellJSONObject = new JSONObject();
				 for(int i=0; i<fieldVector.size();i++){
					 //getData(fieldVector.get(i),dataRS,newItem);
					 String result = dataRS.getString(fieldVector.get(i))==null?"":dataRS.getString(fieldVector.get(i));//�亥府甈��∪�嚗�蝯衣征摮葡
					 cellJSONObject.put(fieldVector.get(i), result);
				 }
				 resultJsonArr.put(cellJSONObject);
			 }
			 if(dataRS != null){
				dataRS.close();
				dataRS = null;
			 }
			 ps.close();
			 ps=null;
			 conn.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		return resultJsonArr;
	}
	
	public JSONArray getSettingsWithLeftJoin(String dbnameLeft, String dbnameRight,
			String leftKey, String rightKey ,Vector<String> fieldVector,
			Vector<String> conditionFieldVector,Vector<String> conditionFieldValue, int start, int limit,
			String sortField, String sortType){
		JSONArray resultJsonArr = new JSONArray();
		try {
			Connection conn = getDBConn();
			
			String conditionQuery="";
			if(conditionFieldVector !=null && conditionFieldVector.size()>0 && (conditionFieldVector.size() ==conditionFieldValue.size())){
				conditionQuery = " where ";
				
				for(int i=0; i<conditionFieldVector.size(); i++){
					conditionQuery += conditionFieldVector.get(i)+"='"+conditionFieldValue.get(i)+"' and ";
				}
				conditionQuery = conditionQuery.substring(0, conditionQuery.length()-4);
			}
			
			String getFieldStr = "";
			for(int i=0 ; i<fieldVector.size(); i++){
				getFieldStr += fieldVector.get(i)+",";
			}
			if(getFieldStr.length()>0){
				getFieldStr = getFieldStr.substring(0,getFieldStr.length()-1);
			}
			String sortStr = "";
			if(!sortField.equals("")){
				sortStr = " order by "+sortField+" "+sortType;
			}
			
			String sql ="";
			if(limit==0){
				sql = "SELECT "+getFieldStr+" from "+dbnameLeft+" a left join "+dbnameRight+
						" b on a."+leftKey+" = b."+rightKey+conditionQuery+sortStr;
			}else{
				sql = "SELECT "+getFieldStr+" from "+dbnameLeft+" a left join "+dbnameRight+
						" b on a."+leftKey+" = b."+rightKey+conditionQuery+sortStr+" limit "+start+","+limit;
			}
			
			System.out.println("getSettingsWithLeftJoin="+sql);
			 LogGenerator.LogWithTime(getLog_path(), "getSettingsWithLeftJoin="+sql);
			 PreparedStatement ps = conn.prepareStatement(sql);
			 ResultSet dataRS;
			 dataRS = ps.executeQuery();
			 while(dataRS.next()) {
				 JSONObject cellJSONObject = new JSONObject();
				 for(int i=0; i<fieldVector.size();i++){
					 //getData(fieldVector.get(i),dataRS,newItem);
					 String result = dataRS.getString(fieldVector.get(i))==null?"":dataRS.getString(fieldVector.get(i));//�亥府甈��∪�嚗�蝯衣征摮葡
					 cellJSONObject.put(fieldVector.get(i), result);
				 }
				 resultJsonArr.put(cellJSONObject);
			 }
			 if(dataRS != null){
				dataRS.close();
				dataRS = null;
			 }
			 ps.close();
			 ps=null;
			 conn.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		return resultJsonArr;
	}
	
	/**
	 * @param dbname
	 * @param fieldVector
	 * @param fieldValueVector
	 */
	public void addSettings(String dbname,Vector<String> fieldVector, Vector<String> fieldValueVector){
		try{
			String dataSql="";
			String queryField="";
			String queryValue="";
			if(fieldVector.size()>0 && (fieldVector.size() == fieldValueVector.size())){
				for(int i=0; i<fieldVector.size(); i++){
					queryField += fieldVector.get(i)+",";
				}
				queryField = queryField.substring(0, queryField.length()-1);
				
				for(int i=0; i<fieldValueVector.size(); i++){
					queryValue += "'"+fieldValueVector.get(i)+"',";
				}
				queryValue = queryValue.substring(0, queryValue.length()-1);
				Connection conn = getDBConn();
				Statement statement = conn.createStatement();
				dataSql = "INSERT INTO "+
						dbname+ " ("+queryField+") VALUES ("+queryValue+" )";
				System.out.println("addSettings="+dataSql);
				 LogGenerator.LogWithTime(getLog_path(), "addSettings="+dataSql);
				statement.executeUpdate(dataSql);
			}else{
				 LogGenerator.LogWithTime(getLog_path(), "addSettings failed: fieldVector(size)="+fieldVector.size()+
							"fieldValueVector(size)="+fieldValueVector.size());
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	/**
	 * 
	 * @param dbname
	 * @param fieldVector
	 * @param fieldValueVector
	 */
	public void deleteSettings(String dbname,Vector<String> fieldVector, Vector<String> fieldValueVector){
		try{
			String dataSql = "";
			if(fieldVector.size()>0 && (fieldVector.size() == fieldValueVector.size())){
				String query = "";
				for(int i=0; i<fieldVector.size(); i++){
					query += fieldVector.get(i)+"='"+fieldValueVector.get(i)+"' and ";
				}
				query = query.substring(0, query.length()-4);
				Connection conn = getDBConn();
				Statement statement = conn.createStatement();
				dataSql = "DELETE FROM "+dbname+" where "+query;
				//System.out.println("deleteSettings="+dataSql);
				 LogGenerator.LogWithTime(getLog_path(), "deleteSettings="+dataSql);
				statement.executeUpdate(dataSql);
				
				conn.close();
			}else{
				LogGenerator.LogWithTime(getLog_path(), "deleteSettings failed: fieldVector(size)="+fieldVector.size()+
						"fieldValueVector(size)="+fieldValueVector.size());
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void editSettings(String dbname,Vector<String> fieldVector, Vector<String> fieldValueVector,
		Vector<String> conditionFieldVector,Vector<String> conditionValueVector){
		try{
			if(fieldVector.size()>0 &&(fieldVector.size() == fieldValueVector.size()) && conditionFieldVector.size()>0
					&& (conditionFieldVector.size()==conditionValueVector.size())){
				String updateQuery = "";
				for(int i=0; i<fieldVector.size(); i++){
					updateQuery += fieldVector.get(i)+" = '"+fieldValueVector.get(i)+"',";
				}
				updateQuery = updateQuery.substring(0, updateQuery.length()-1);
				
				String conditionQuery = "";
				for(int i=0; i<conditionFieldVector.size(); i++){
					conditionQuery += conditionFieldVector.get(i)+"='"+conditionValueVector.get(i)+"' and ";
				}
				conditionQuery = conditionQuery.substring(0,conditionQuery.length()-4);
				
				Connection conn = getDBConn();
				Statement statement = conn.createStatement();
				String dataSql = "UPDATE "+dbname+" SET "+updateQuery+" where "+conditionQuery;
				System.out.println("EditSettings="+dataSql);
				LogGenerator.LogWithTime(getLog_path(), "EditSettings="+dataSql);
				statement.executeUpdate(dataSql);
			}else{
				LogGenerator.LogWithTime(getLog_path(), "EditSettings failed: fieldVector(size)="+fieldVector.size()+
						"fieldValueVector(size)="+fieldValueVector.size());
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	/**
	 * @param dbname
	 * @param fieldVector
	 * @param fieldValueVector
	 */
	public void addFBSettings(String dbname,Vector<String> fieldVector, Vector<String> fieldValueVector){
		try{
			String dataSql="";
			String queryField="";
			String queryValue="";    
			if(fieldVector.size()>0 && (fieldVector.size() == fieldValueVector.size())){
				for(int i=0; i<fieldVector.size(); i++){
					queryField += fieldVector.get(i)+",";
				}
				queryField = queryField.substring(0, queryField.length()-1);
				
				for(int i=0; i<fieldValueVector.size(); i++){
					queryValue += "'"+fieldValueVector.get(i)+"',";
				}
				queryValue = queryValue.substring(0, queryValue.length()-1);
				Connection conn = getFDBConn();
				Statement statement = conn.createStatement();
				dataSql = "INSERT INTO "+
						dbname+ " ("+queryField+") VALUES ("+queryValue+" )";
				System.out.println("addSettings="+dataSql);
				 LogGenerator.LogWithTime(getLog_path(), "addSettings="+dataSql);
				statement.executeUpdate(dataSql);
			}else{
				 LogGenerator.LogWithTime(getLog_path(), "addSettings failed: fieldVector(size)="+fieldVector.size()+
							"fieldValueVector(size)="+fieldValueVector.size());
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	public void editFBSettings(String dbname,Vector<String> fieldVector, Vector<String> fieldValueVector,
			Vector<String> conditionFieldVector,Vector<String> conditionValueVector){
			try{
				if(fieldVector.size()>0 &&(fieldVector.size() == fieldValueVector.size()) && conditionFieldVector.size()>0
						&& (conditionFieldVector.size()==conditionValueVector.size())){
					String updateQuery = "";
					for(int i=0; i<fieldVector.size(); i++){
						updateQuery += fieldVector.get(i)+" = '"+fieldValueVector.get(i)+"',";
					}
					updateQuery = updateQuery.substring(0, updateQuery.length()-1);
					
					String conditionQuery = "";
					for(int i=0; i<conditionFieldVector.size(); i++){
						conditionQuery += conditionFieldVector.get(i)+"='"+conditionValueVector.get(i)+"' and ";
					}
					conditionQuery = conditionQuery.substring(0,conditionQuery.length()-4);
					
					Connection conn = getFDBConn();
					Statement statement = conn.createStatement();
					String dataSql = "UPDATE "+dbname+" SET "+updateQuery+" where "+conditionQuery;
					System.out.println("EditSettings="+dataSql);
					LogGenerator.LogWithTime(getLog_path(), "EditSettings="+dataSql);
					statement.executeUpdate(dataSql);
				}else{
					LogGenerator.LogWithTime(getLog_path(), "EditSettings failed: fieldVector(size)="+fieldVector.size()+
							"fieldValueVector(size)="+fieldValueVector.size());
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		}
	public JSONArray getFBSettings(String dbname, Vector<String> fieldVector,
			Vector<String> conditionFieldVector,Vector<String> conditionFieldValue, int start, int limit,
			String sortField, String sortType){
		JSONArray resultJsonArr = new JSONArray();
		try {
			Connection conn = getFDBConn();
			
			String conditionQuery="";
			if(conditionFieldVector !=null && conditionFieldVector.size()>0 && (conditionFieldVector.size() ==conditionFieldValue.size())){
				conditionQuery = " where ";
				
				for(int i=0; i<conditionFieldVector.size(); i++){
					conditionQuery += conditionFieldVector.get(i)+"='"+conditionFieldValue.get(i)+"' and ";
				}
				conditionQuery = conditionQuery.substring(0, conditionQuery.length()-4);
			}
			
			String getFieldStr = "";
			for(int i=0 ; i<fieldVector.size(); i++){
				getFieldStr += fieldVector.get(i)+",";
			}
			if(getFieldStr.length()>0){
				getFieldStr = getFieldStr.substring(0,getFieldStr.length()-1);
			}
			String sortStr = "";
			if(!sortField.equals("")){
				sortStr = " order by "+sortField+" "+sortType;
			}
			
			String sql ="";
			if(limit==0){
				sql = "SELECT "+getFieldStr+" from "+dbname+conditionQuery+sortStr;
			}else{
				sql = "SELECT "+getFieldStr+" from "+dbname+conditionQuery+sortStr+" limit "+start+","+limit;
			}
			
			System.out.println("getSettings="+sql);
			 LogGenerator.LogWithTime(getLog_path(), "getSettings="+sql);
			 PreparedStatement ps = conn.prepareStatement(sql);
			 ResultSet dataRS;
			 dataRS = ps.executeQuery();
			 while(dataRS.next()) {
				 JSONObject cellJSONObject = new JSONObject();
				 for(int i=0; i<fieldVector.size();i++){
					 //getData(fieldVector.get(i),dataRS,newItem);
					 String result = dataRS.getString(fieldVector.get(i))==null?"":dataRS.getString(fieldVector.get(i));//�亥府甈��∪�嚗�蝯衣征摮葡
					 cellJSONObject.put(fieldVector.get(i), result);
				 }
				 resultJsonArr.put(cellJSONObject);
			 }
			 if(dataRS != null){
				dataRS.close();
				dataRS = null;
			 }
			 ps.close();
			 ps=null;
			 conn.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		return resultJsonArr;
	}
	
	
}
