package tw.org.iii.ideas.log;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;

public class LogGenerator {
	public static SimpleDateFormat dateSDF = new SimpleDateFormat("yyyy-MM-dd");
	public static void LogWithTime(String logfilePath, String logString) throws IOException{
		Calendar now = Calendar.getInstance();
		String file = logfilePath+"log_"+dateSDF.format(now.getTime())+".txt";
		BufferedWriter bw = null;
		try {
			if(file.matches(".*/.*")){
				createFolder(file.substring(0, file.lastIndexOf("/")));
			}
			
			String TIME_FORMAT = "yyyy-MM-dd HH:mm:ss";
			SimpleDateFormat sdf = new SimpleDateFormat(TIME_FORMAT);
			logString = logString+"  "+sdf.format(now.getTime());
			
			bw = new BufferedWriter(new FileWriter(file, true));
			bw.write(logString);
			bw.newLine();
			bw.newLine();
			bw.flush();
		} catch (IOException ioe) {
			ioe.printStackTrace();
		} finally { // always close the file
			if (bw != null)
				try {
					bw.close();
				} catch (IOException ioe2) {
					// just ignore it
				}
		} // end try/catch/finally
	}
	
	public static void LogWithoutTime(String logfilePath, String logString) throws IOException{
		Calendar now = Calendar.getInstance();
		String file =  logfilePath+"log_"+dateSDF.format(now.getTime())+".txt";
		BufferedWriter bw = null;
		try {
			if(file.matches(".*/.*")){
				createFolder(file.substring(0, file.lastIndexOf("/")));
			}
			
			bw = new BufferedWriter(new FileWriter(file, true));
			bw.write(logString);
			bw.newLine();
			bw.newLine();
			bw.flush();
		} catch (IOException ioe) {
			ioe.printStackTrace();
		} finally { // always close the file
			if (bw != null)
				try {
					bw.close();
				} catch (IOException ioe2) {
					// just ignore it
				}
		} // end try/catch/finally
	}
	
	public static void createFolder(String directory){
	//	System.out.println(directory);
		File theDir = new File(directory);
		String[] subFolderArr = directory.split("/");
		//System.out.println("create="+directory);
		boolean success = false;
		String thePath="";
		if (!theDir.exists()){
			for(int i=1; i<subFolderArr.length; i++){
				if(i ==1){
					thePath = subFolderArr[0]+"/"+subFolderArr[1];
				//	System.out.println("i="+thePath);
					success = (new File(thePath)).mkdir();
				}
				else{
					thePath =thePath+"/"+ subFolderArr[i];
					success = (new File(thePath)).mkdir();
				//	System.out.println("i="+thePath);
				}
			}
		}
	}

}
