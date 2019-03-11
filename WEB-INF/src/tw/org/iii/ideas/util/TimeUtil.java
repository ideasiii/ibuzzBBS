package tw.org.iii.ideas.util;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class TimeUtil {
	private static SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	private static SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	
	/**
	 * ��銝�蝳格��亦��交� (銝���洵銝�予�箸��)
	 * @param String now (ex: 2012-10-05)
	 * @return String date (ex: 2012-09-23)
	 * @throws Exception
	 */
	public String getLastSunday(String date) throws Exception{		
		Date dStart = dateFormat.parse(date);
		Calendar cTmp = Calendar.getInstance();
		cTmp.setTime(dStart);
		
		// �����嚗��嚗���.......����(1-7)
		cTmp.set(Calendar.DAY_OF_WEEK, 1);
		int day = cTmp.get(Calendar.DAY_OF_YEAR);
		cTmp.set(Calendar.DAY_OF_YEAR, day - 7);
		
		return dateFormat.format(cTmp.getTime());
	}
	
	/**
	 * ��銝�蝳格��剔��交� (銝���洵銝�予�箸��)
	 * @param String now (ex: 2012-10-05)
	 * @return String date (ex: 2012-09-29)
	 * @throws Exception
	 */
	public String getLastSaturday(String date) throws Exception{		
		Date dStart = dateFormat.parse(date);
		Calendar cTmp = Calendar.getInstance();
		cTmp.setTime(dStart);
		
		// �����嚗��嚗���.......����(1-7)
		cTmp.set(Calendar.DAY_OF_WEEK, 7);
		int day = cTmp.get(Calendar.DAY_OF_YEAR);
		cTmp.set(Calendar.DAY_OF_YEAR, day - 7);
		
		return dateFormat.format(cTmp.getTime());
	}
	
	/**
	 * ��撟曉����洵銝�予�交�
	 * @param String date (ex: 2012-10-05)
	 * @param int offset_mon (ex: -1  銝����)
	 * @return String (ex: 2012-09-01)
	 * @throws Exception
	 */
	public String getMonthFirstDay(String date, int offset_mon) throws Exception{
		Date dStart = dateFormat.parse(date);
		Calendar cTmp = Calendar.getInstance();
		cTmp.setTime(dStart);
		
		cTmp.add(Calendar.MONTH, offset_mon);

		cTmp.set(Calendar.DATE, cTmp.getActualMinimum(Calendar.DATE));
		
		return dateFormat.format(cTmp.getTime());
    }
	
	/**
	 * ��撟曉�����敺�憭拇��
	 * @param String date (ex: 2012-10-05)
	 * @param int offset_mon (ex: -1  銝����)
	 * @return String (ex: 2012-09-30)
	 * @throws Exception
	 */
	public String getMonthLastDay(String date, int offset_mon) throws Exception{
		Date dStart = dateFormat.parse(date);
		Calendar cTmp = Calendar.getInstance();
		cTmp.setTime(dStart);
		
		cTmp.add(Calendar.MONTH, offset_mon);

		cTmp.set(Calendar.DATE, cTmp.getActualMaximum(Calendar.DATE));
		
		return dateFormat.format(cTmp.getTime());
    }
	
	public static void main(String[] args) throws Exception{
		TimeUtil time = new TimeUtil();
		System.out.println(time.getLastSunday("2012-11-18"));
		System.out.println(time.getMonthFirstDay("2012-11-18", -1));
	}
}
