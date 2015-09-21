package com.irsa.service;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesClient.ConnectionCallbacks;
import com.google.android.gms.common.GooglePlayServicesClient.OnConnectionFailedListener;
import com.google.android.gms.location.LocationClient;
import com.google.android.gms.location.LocationListener;
import com.irsa.AtWorkActivity.GoogleCalendarTask;
import com.irsa.AtWorkActivity.RestrantAppTask;
import com.statusmanager.util.PubContant;
import com.statusmanager.util.UtilFunction;



import android.app.Service;
import android.content.Intent;
import android.location.Location;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.util.Log;

public class MyService extends Service implements LocationListener ,OnConnectionFailedListener, ConnectionCallbacks{
	public static final String ACTION_MYSERVICE="com.broad";
	boolean isRun = true;
	private Handler AtWorkHandler = new Handler();
	private LocationClient mLocationClient;
	boolean changeWallPaper=false;

	@Override
	public IBinder onBind(Intent intent) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void onCreate() {
		super.onCreate();
		setUpLocationClientIfNeeded();
		mLocationClient.connect();
		
	}
	private void setUpLocationClientIfNeeded() {
		if (mLocationClient == null) {
			mLocationClient = new LocationClient(getApplicationContext(), this, // ConnectionCallbacks
					this); // OnConnectionFailedListener
		}
	}
	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		
		isRun = true;
		
		return super.onStartCommand(intent, flags, startId);
	}

	@Override
	public void onDestroy() {
		isRun = false;
		super.onDestroy();
	}

	@Override
	public void onLocationChanged(Location arg0) {
		// TODO Auto-generated method stub
		
			updateLocation(arg0);
	}
	Runnable runnable = new Runnable() {
		@Override
		public void run() {
			// TODO Auto-generated method stub
			// 要做的事情
			// 获取系统时间，如果是中午11点到下午两点，则显示出饭店
			if(PubContant.Current_Status==PubContant.Status_At_Home&&changeWallPaper){
				changeWallPaper=false;
				UtilFunction.putWallpaper(getBaseContext(), PubContant.WALLPAPERATHOME);
				}
			if(PubContant.Current_Status==PubContant.Status_At_Work&&changeWallPaper){
				changeWallPaper=false;
				UtilFunction.putWallpaper(getBaseContext(), PubContant.WALLPAPERATWORK);
			}
			if(PubContant.Current_Status==PubContant.Status_At_On_The_Go&&changeWallPaper){
				changeWallPaper=false;
				UtilFunction.putWallpaper(getBaseContext(), PubContant.WALLPAPERONTHEGO);
			}
			
		}
	};
	private void updateLocation(Location location) {
		
		String latLng;
		if (location != null) {
			double lat = location.getLatitude();
			double lng = location.getLongitude();
			// 首先获取家里和工作地点的坐标
			if (Math.abs(lat - PubContant.ATWORK_LAT) < PubContant.Lat_Lon_Distance
					&& Math.abs(lng - PubContant.ATWORK_LON) < PubContant.Lat_Lon_Distance) {
				if(PubContant.Current_Status!=PubContant.Status_At_Work)
					changeWallPaper=true;
				Intent it = new Intent(ACTION_MYSERVICE);
				it.putExtra("msgFromServ",PubContant.Status_At_Work);
				PubContant.Current_Status=PubContant.Status_At_Work;
				MyService.this.sendBroadcast(it);
				AtWorkHandler.post(runnable);
//				UtilFunction.putWallpaper(getBaseContext(), PubContant.WALLPAPERATWORK);
				return;
			} else {
				if (Math.abs(lat - PubContant.ATHOME_LAT) < PubContant.Lat_Lon_Distance
						&& Math.abs(lng - PubContant.ATHOME_LON) < PubContant.Lat_Lon_Distance
						) {
					if(PubContant.Current_Status!=PubContant.Status_At_Home)
						changeWallPaper=true;
					Intent it = new Intent(ACTION_MYSERVICE);
					it.putExtra("msgFromServ",PubContant.Status_At_Home);
					PubContant.Current_Status=PubContant.Status_At_Home;
					MyService.this.sendBroadcast(it);
					AtWorkHandler.post(runnable);
//					UtilFunction.putWallpaper(getBaseContext(), PubContant.WALLPAPERATHOME);
					return;
				} else {
					if(PubContant.Current_Status!=PubContant.Status_At_On_The_Go)
						changeWallPaper=true;
					Intent it = new Intent(ACTION_MYSERVICE);
					it.putExtra("msgFromServ",PubContant.Status_At_On_The_Go);
					PubContant.Current_Status=PubContant.Status_At_On_The_Go;
					MyService.this.sendBroadcast(it);
					AtWorkHandler.post(runnable);
//					UtilFunction
//					.putWallpaper(getBaseContext(), PubContant.WALLPAPERONTHEGO);
				}
			}

		

		} else {
			latLng = "Can't access your location";
		}
	}

	@Override
	public void onConnected(Bundle arg0) {
		// TODO Auto-generated method stub
		mLocationClient.requestLocationUpdates(PubContant.REQUEST, this); // LocationListener
	}

	@Override
	public void onDisconnected() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onConnectionFailed(ConnectionResult arg0) {
		// TODO Auto-generated method stub
		
	}
}
