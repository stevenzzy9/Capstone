package com.irsa;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.ContentResolver;
import android.content.Intent;
import android.database.Cursor;
import android.location.Location;
import android.media.AudioManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.RemoteException;
import android.provider.Contacts;
import android.telephony.PhoneStateListener;
import android.telephony.SmsManager;
import android.telephony.TelephonyManager;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MenuItem.OnMenuItemClickListener;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.android.internal.telephony.ITelephony;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesClient.ConnectionCallbacks;
import com.google.android.gms.common.GooglePlayServicesClient.OnConnectionFailedListener;
import com.google.android.gms.location.LocationClient;
import com.google.android.gms.location.LocationListener;
import com.google.gdata.client.calendar.CalendarService;
import com.statusmanager.listview.ActionAdapter;
import com.statusmanager.listview.ActionItem;
import com.statusmanager.model.GoogleCalendarModel;
import com.statusmanager.model.KeyWord;
import com.statusmanager.model.RestrantModel;
import com.statusmanager.util.EventFeedDemo;
import com.statusmanager.util.JavaXmlDomReader;
import com.statusmanager.util.PubContant;
import com.statusmanager.util.UtilFunction;

public class AtWorkActivity extends Activity implements ConnectionCallbacks,
		OnConnectionFailedListener, LocationListener {

	private int currentStatus = PubContant.Status_Default;
	private AudioManager mAudioManager = null;
	private LocationClient mLocationClient;
	private List<ActionItem> actionData;
	private ActionAdapter actionAdapter;
	private ProgressDialog progressDialog;
	private TextView currentLocation;
	private LinearLayout linearLayout = null;
	private Handler AtWorkHandler = new Handler();
	private ListView actionlistSwipeListView;
	private Button setlocation;
	private boolean isDone = false;
	private Button email;
	private TextView TopText;
	private ITelephony iTelephony;
	private TelephonyManager manager;
	

	private ContentResolver content = null;
	private Cursor cursor = null;
	private ArrayList<String> nameList = null;
	private ArrayList<String> numberList = null;
	private TelephonyManager telephonyManager = null;
	private SmsManager smsManager = null;

	private String incomingNumber = null;
	private boolean isMonitoring = false;

	public void startService() {

		/*
		 * ���������������������������������������������������������������nameList,numberList���������ArrayList������
		 * ���������������������������������������������������������
		 */
		content = getContentResolver(); // ������������ContentResolver������������������new���������
		cursor = content.query(Contacts.People.CONTENT_URI, null, null, null,
				null);
		nameList = new ArrayList<String>(cursor.getCount());
		numberList = new ArrayList<String>(cursor.getCount());

		for (int i = 0; i < cursor.getCount(); i++) {
			cursor.moveToPosition(i);
			nameList.add(cursor.getString(cursor
					.getColumnIndex(Contacts.People.NAME)));
			numberList.add(cursor.getString(cursor
					.getColumnIndex(Contacts.People.NUMBER)));
		}

		/*
		 * ���������������������������������Listener ������������������������������������������������������������������������������������������������
		 * ���������������������������������������������������������������������������������������������
		 */
		PhoneStateListener phoneListener = new PhoneStateListener() {
			@Override
			public void onCallStateChanged(int state, String incoming) {
				if (state == TelephonyManager.CALL_STATE_RINGING) {
					if (isMeeting) {
						try {
							iTelephony.endCall();
						} catch (RemoteException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						incomingNumber = incoming;
						sendSMS();
					}
				}
			}
		};

		telephonyManager = (TelephonyManager) getSystemService(TELEPHONY_SERVICE);
		telephonyManager.listen(phoneListener,
				PhoneStateListener.LISTEN_CALL_STATE);
		smsManager = SmsManager.getDefault();
	}

	public void sendSMS() {
		/*
		 * ������������������������������������������ SmsManager smsManager = SmsManager.getDefault();
		 * String smsText = "������������"; String number = "������������";
		 * smsManager.sendTextMessage(incomingNumber, null, smsText, null,
		 * null);
		 */
		if (!numberList.contains(incomingNumber))
			;
		{
			Toast.makeText(getBaseContext(), incomingNumber, Toast.LENGTH_LONG);
			String smsText = "Sorry I am at meeting, I will get back to you later.";
			smsManager.sendTextMessage(incomingNumber, null, smsText, null,
					null);
		}
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.atwork);
		startService();
		isDone = false;
		linearLayout = (LinearLayout) findViewById(R.id.content_frame);
		TopText = (TextView) findViewById(R.id.topText);

		
		phoner();
		mAudioManager = (AudioManager) getSystemService(getBaseContext().AUDIO_SERVICE);
		// currentLocation = (TextView) findViewById(R.id.currentLocation);
		actionData = new ArrayList<ActionItem>();

		actionAdapter = new ActionAdapter(this, actionData);

		actionlistSwipeListView = (ListView) findViewById(R.id.actionlistswipelistview);

		actionlistSwipeListView.setAdapter(actionAdapter);

		setlocation = (Button) findViewById(R.id.setlocation);
		email = (Button) findViewById(R.id.email);
		email.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Intent myIntent = new Intent();
				myIntent.putExtra("from", PubContant.Status_At_Work);
				myIntent.setClass(AtWorkActivity.this, EmailActivity.class);
				startActivity(myIntent);

			}
		});
		setlocation.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				startActivity(new Intent(AtWorkActivity.this,
						UpdateMultiMapDemoActivity.class));
			}
		});
		// ���������������������
		mAudioManager.setStreamVolume(AudioManager.STREAM_RING, 50,
				AudioManager.FLAG_SHOW_UI);
		mAudioManager.setStreamVolume(AudioManager.STREAM_SYSTEM, 50,
				AudioManager.FLAG_SHOW_UI);
		mAudioManager.setStreamVolume(AudioManager.STREAM_ALARM, 50,
				AudioManager.FLAG_SHOW_UI);

		progressDialog = new ProgressDialog(this);
		progressDialog.setMessage(getString(R.string.loading));
		progressDialog.setCancelable(false);
		progressDialog.show();
	
		AtWorkHandler.post(runnable);
		mAudioManager.setRingerMode(AudioManager.RINGER_MODE_VIBRATE);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// TODO Auto-generated method stub
		/*
		menu.add("Location").setOnMenuItemClickListener(
				new OnMenuItemClickListener() {

					@Override
					public boolean onMenuItemClick(MenuItem item) {
						// TODO Auto-generated method stub
						startActivity(new Intent(AtWorkActivity.this,
								MultiMapDemoActivity.class));
						return false;
					}
				});*/
		
		menu.add("Personal Information").setOnMenuItemClickListener(
				new OnMenuItemClickListener() {

					@Override
					public boolean onMenuItemClick(MenuItem item) {
						// TODO Auto-generated method stub
						startActivity(new Intent(AtWorkActivity.this,
								Account.class));
						return false;
					}
				});
		return super.onCreateOptionsMenu(menu);

	}

	Runnable runnable = new Runnable() {
		@Override
		public void run() {
			// TODO Auto-generated method stub
			// ���������������
			// ������������������������������������11���������������������������������������

			
			new RestrantAppTask().execute();

			new GoogleCalendarTask().execute();
			AtWorkHandler.postDelayed(this, 5000);
		}
	};

	public void startGetCalendar() {
		new Thread(new Runnable() {
			@Override
			public void run() {
				// while (true) {

				DocumentBuilderFactory factory = DocumentBuilderFactory
						.newInstance();
				DocumentBuilder builder;
				try {

					builder = factory.newDocumentBuilder();
					Document doc = builder.parse(PubContant.WEBSERVERKEYWORD);
					JavaXmlDomReader jxdr = new JavaXmlDomReader();
					ArrayList<KeyWord> KeyWordList = jxdr
							.getKeyWordList(getBaseContext());
					EventFeedDemo eventFeed = new EventFeedDemo();
					CalendarService myService = new CalendarService(
							"exampleCo-exampleApp-1");
					try {
						ArrayList<GoogleCalendarModel> queryResult = EventFeedDemo
								.dateRangeQuery(PubContant.googleAccountName,
										PubContant.googleAccountPassword,
										myService);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}

				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			// }
		}).start();

	}

	@Override
	public void onLocationChanged(Location arg0) {
		// TODO Auto-generated method stub
		if (!isDone)
			updateLocation(arg0);
	}

	@Override
	public void onConnectionFailed(ConnectionResult arg0) {
		// TODO Auto-generated method stub

	}

	private void setUpLocationClientIfNeeded() {
		if (mLocationClient == null) {
			mLocationClient = new LocationClient(getApplicationContext(), this, // ConnectionCallbacks
					this); // OnConnectionFailedListener
		}
	}

	@Override
	protected void onPause() {
		// TODO Auto-generated method stub
		super.onPause();
//		if (mLocationClient != null) {
//			mLocationClient.disconnect();
//		}
		setUpLocationClientIfNeeded();
		mLocationClient.connect();
	}

	@Override
	protected void onResume() {
		// TODO Auto-generated method stub

		super.onResume();
		setUpLocationClientIfNeeded();
		mLocationClient.connect();
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

	public boolean isNeedMute(ArrayList<GoogleCalendarModel> googleCalendar,
			ArrayList<KeyWord> keywordList) {
		boolean isNeedMute = false;
		for (int i = 0; i < googleCalendar.size(); i++) {
			for (int j = 0; j < keywordList.size(); j++) {
				if (googleCalendar.get(i).getEventDesription().indexOf(keywordList.get(j).getKeyWord()) > -1) {
					isNeedMute = true;
				}
			}
		}
		return isNeedMute;
	}

	private boolean isMeeting = false;

	private void updateLocation(Location location) {
		linearLayout.setBackgroundDrawable(getResources().getDrawable(
				R.drawable.backgoundwhite));
		String latLng;
		if (location != null) {
			double lat = location.getLatitude();
			double lng = location.getLongitude();

			// ������������������������������������������
			if (Math.abs(lat - PubContant.ATHOME_LAT) < PubContant.Lat_Lon_Distance
					&& Math.abs(lng - PubContant.ATHOME_LON) < PubContant.Lat_Lon_Distance
) {
		
				startActivity(new Intent(AtWorkActivity.this,
						AtHomeActivity.class));
				finish();
				isDone = true;
				return;
			} else {
				if (Math.abs(lat - PubContant.ATWORK_LAT) < PubContant.Lat_Lon_Distance
						&& Math.abs(lng - PubContant.ATWORK_LON) < PubContant.Lat_Lon_Distance
						) {
					return;

				} else {
					startActivity(new Intent(AtWorkActivity.this,
							OnTheGoActivity.class));
					isDone = true;
					finish();
				}
			}

		} else {
			latLng = "Can't access your location";
		}
	}

	public class GoogleCalendarTask extends AsyncTask<Void, Void, Boolean> {

		@Override
		protected Boolean doInBackground(Void... params) {
			// TODO Auto-generated method stub
			JavaXmlDomReader jxdr = new JavaXmlDomReader();
			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();
			DocumentBuilder builder;
			try {

				builder = factory.newDocumentBuilder();
				Document doc = builder.parse(PubContant.WEBSERVERKEYWORD);

				ArrayList<KeyWord> KeyWordList = jxdr
						.getKeyWordList(getBaseContext());
				EventFeedDemo eventFeed = new EventFeedDemo();
				CalendarService myService = new CalendarService(
						"exampleCo-exampleApp-1");
				ArrayList<GoogleCalendarModel> queryResult = new ArrayList<GoogleCalendarModel>();
				try {

					queryResult = EventFeedDemo.dateRangeQuery(
							PubContant.CurrentUser.getGoogleusername(),
							PubContant.CurrentUser.getGoogleuserpassword(),
							myService);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				if (isNeedMute(queryResult, KeyWordList)) {
					isMeeting = true;
				} else {
					isMeeting = false;
				}

			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return isMeeting;
		}

		protected void onPostExecute(Boolean result) {

			if (!result) {
				TopText.setText("At Work");
			} else {
				TopText.setText("At Work -In Meeting");
				// ���������������������
				mAudioManager.setRingerMode(AudioManager.RINGER_MODE_VIBRATE);

			}
		}

	}

	public class RestrantAppTask extends
			AsyncTask<Void, Void, List<ActionItem>> {

		protected List<ActionItem> doInBackground(Void... args) {

			List<ActionItem> data = new ArrayList<ActionItem>();

				JavaXmlDomReader jxdr = new JavaXmlDomReader();
				ArrayList<RestrantModel> RestrantList = jxdr
						.getRestrantList(getBaseContext());
				for (int index = 0; index < RestrantList.size(); index++) {
					try {
						RestrantModel content = RestrantList.get(index);

						if (content.getRestrantID() != 0) {
							ActionItem item = new ActionItem();
							item.setActionname(content.getRestrantName());
							item.setActionTime(content.getLocationDescription());
							item.setActionType(content.getRestrantType());
							item.setActionTypeIcon((getBaseContext())
									.getResources()
									.getDrawable(
											UtilFunction.ActionTypeIconID(content
													.getRestrantImageUrl())));
							item.setActionLocation(content.getLocation());
							item.setActionID(content.getRestrantID());
							data.add(item);
						}
					} catch (Exception e) {

					}
				}
			
			return data;
		}

		protected void onPostExecute(List<ActionItem> result) {
			actionData.clear();
			actionData.addAll(result);
			actionAdapter.notifyDataSetChanged();
			if (progressDialog != null) {
				progressDialog.dismiss();
				progressDialog = null;
			}

		}
	}

	public void phoner() {
		manager = (TelephonyManager) getSystemService(TELEPHONY_SERVICE);
		Class<TelephonyManager> c = TelephonyManager.class;
		Method getITelephonyMethod = null;
		try {
			getITelephonyMethod = c.getDeclaredMethod("getITelephony",
					(Class[]) null);
			getITelephonyMethod.setAccessible(true);
			iTelephony = (ITelephony) getITelephonyMethod.invoke(manager,
					(Object[]) null);
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();

		}
	}
}
