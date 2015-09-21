package com.statusmanager.util;

import com.google.android.gms.location.LocationRequest;
import com.statusmanager.model.UserModel;



public class PubContant {
	public static double ATHOME_LAT=37.0;
	public static double ATHOME_LON=117.0;
	public static double ATWORK_LAT=20.0;
	public static double ATWORK_LON=130.0;
	public static String googleAccountName="testcapcal@gmail.com";
	public static String googleAccountPassword="testcapcal1234";
	public static String googleHomeAccountName="linhui900520@gmail.com";
	public static String googleHomeAccountPassword="lh900520@";
	public static String WALLPAPERATHOME="wallpaperbackground_athome";
	public static String WALLPAPERATWORK="wallpaperbackground_atwork";
	public static String WALLPAPERONTHEGO="wallpaperbackground_onthego";
	//����������������������������������������������n
	public static String WEBSERVERURL="172.31.135.188";
	//Movie������IP��������������?
	public static final String WEBSERVERMOVIE="http://"+WEBSERVERURL+":8080/Assistant/moviegetxml";
	//���������������Restrant������ip��������
	public static final String WEBSERVERRESTRANT="http://"+WEBSERVERURL+":8080/Assistant/restaurantxml";
	public static final String WEBSERVERLOCATIONUPDATE="http://"+WEBSERVERURL+":8080/Assistant/LocationServlet";
	public static final String WEBSERVERISMEETINGTIME="http://"+WEBSERVERURL+":8080/Assistant/isMeetingTime";
	public static final String WEBSERVERKEYWORD="http://"+WEBSERVERURL+":8080/Assistant/KeyWordServlet";
	public static final String WEBSERVERUSER="http://"+WEBSERVERURL+":8080/Assistant/UserServlet";
	public static final String WEBSERVERUSERLOCATION="http://"+WEBSERVERURL+":8080/Assistant/UserLocationServlet";
	//������������������������������������LocationType;
	public static final int LocationAtHome=0;
	public static final int LocationAtWork=1;
	public static final Double Lat_Lon_Distance=0.05;
	
	public static final String SERVERURL="http://172.31.135.188/";
	public static final String SOAPNAMESPACE="http://tempuri.org/";

	
	//���������������������������������������������������������������������������
	public static final int ID_ONLINEMAP = 1;
	public static final int ID_OFFLINEMAP = 2;
	public static final int ID_SATLITEMAP = 3;
	public static final int ID_3DMAP = 4;
	public static final int ID_2DMAP =5;
	public static final int ID_QUANJINGMAP=6;
	 
	public static final int FollowStategy_Default=0;
	public static final int FollowStategy_Follow=1;
	public static final int FollowStategy_Compass=2;
	public static final int START_VOICE_RECOGNITION_REQUEST_CODE = 1;
	public static final int STOP_VOICE_RECOGNITION_REQUEST_CODE = 2;
	public static final int TopRightJoin=1;
	public static final int TopRightDirection=2;
	public static final int TopRightFriend=3;
	public static final int TopRightNearby=4;
	
	public static final int TopRightPopwindow=9999;

	public static  int Current_Status=1;
	public static final int Status_Last=4;
	public static final int Status_Default=1;
	public static final int Status_At_Work=1;
	public static final int Status_At_Home=2;
	public static final int Status_At_On_The_Go=3;
	public static final String interSplit=",";
	public static UserModel CurrentUser=new UserModel();

	public static final LocationRequest REQUEST = LocationRequest.create()
			.setInterval(5000) // 5 seconds
			.setFastestInterval(1000) // 16ms = 60fps
            .setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
	
	
	public final static String hostString = "https://maps.googleapis.com/maps/api/place/search/json?";
	public final static String testString = "https://maps.googleapis.com/maps/api/place/search/json?location=48.859294,2.347589&radius=5000&types=food|cafe&sensor=false&keyword=vegetarian&key=AIzaSyDAVl47wSoahQOM76i6yFiZ7z5KmsUiGi0";
	
	public final static String apiKey = "AIzaSyDAVl47wSoahQOM76i6yFiZ7z5KmsUiGi0";
} 
