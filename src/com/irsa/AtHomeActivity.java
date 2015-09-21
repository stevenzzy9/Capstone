package com.irsa;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.location.Location;
import android.media.AudioManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
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

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesClient.ConnectionCallbacks;
import com.google.android.gms.common.GooglePlayServicesClient.OnConnectionFailedListener;
import com.google.android.gms.location.LocationClient;
import com.google.android.gms.location.LocationListener;
import com.irsa.OnTheGoActivity.NearbyFacility;
import com.statusmanager.listview.ActionAdapter;
import com.statusmanager.listview.ActionItem;
import com.statusmanager.model.MovieModel;
import com.statusmanager.util.JavaXmlDomReader;
import com.statusmanager.util.PubContant;
import com.statusmanager.util.UtilFunction;

public class AtHomeActivity extends Activity implements ConnectionCallbacks,
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
	private Button email;
	private boolean isDone = false;


	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		// currentLocation = (TextView) findViewById(R.id.currentLocation);
		setContentView(R.layout.athome);
		isDone = false;
		mAudioManager = (AudioManager) getSystemService(getBaseContext().AUDIO_SERVICE);
		setlocation = (Button) findViewById(R.id.setlocation);
		email = (Button) findViewById(R.id.email);
		email.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Intent myIntent = new Intent();
				myIntent.putExtra("from", PubContant.Status_At_Home);
				myIntent.setClass(AtHomeActivity.this, EmailActivity.class);
				startActivity(myIntent);
				finish();
			}
		});
		setlocation.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				isDone = true;
				startActivity(new Intent(AtHomeActivity.this,
						UpdateMultiMapDemoActivity.class));
			}
		});
		linearLayout = (LinearLayout) findViewById(R.id.content_frame);
		
		actionData = new ArrayList<ActionItem>();

		actionAdapter = new ActionAdapter(this, actionData);

		actionlistSwipeListView = (ListView) findViewById(R.id.actionlistswipelistview);

		actionlistSwipeListView.setAdapter(actionAdapter);

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
	}
	

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// TODO Auto-generated method stub
		menu.add("Personal Information").setOnMenuItemClickListener(
				new OnMenuItemClickListener() {

					@Override
					public boolean onMenuItemClick(MenuItem item) {
						// TODO Auto-generated method stub
						startActivity(new Intent(AtHomeActivity.this,
								Account.class));
						return false;
					}
				});
		return super.onCreateOptionsMenu(menu);
		//return super.onCreateOptionsMenu(menu);
		
	}


	Runnable runnable = new Runnable() {
		@Override
		public void run() {
			// TODO Auto-generated method stub
			// ���������������
			new MovieListAppTask().execute();
			AtWorkHandler.postDelayed(this, 5000);
		}
	};

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

	private void updateLocation(Location location) {
		linearLayout.setBackgroundDrawable(getResources().getDrawable(
				R.drawable.backgoundwhite));
		String latLng;
		if (location != null) {
			double lat = location.getLatitude();
			double lng = location.getLongitude();
			// ������������������������������������������
			if (Math.abs(lat - PubContant.ATWORK_LAT) < PubContant.Lat_Lon_Distance
					&& Math.abs(lng - PubContant.ATWORK_LON) < PubContant.Lat_Lon_Distance) {
				
				finish();
				startActivity(new Intent(AtHomeActivity.this,
						AtWorkActivity.class));
				isDone = true;

				return;
			} else {
				if (Math.abs(lat - PubContant.ATHOME_LAT) < PubContant.Lat_Lon_Distance
						&& Math.abs(lng - PubContant.ATHOME_LON) < PubContant.Lat_Lon_Distance
						) {

					return;
				} else {
					
					startActivity(new Intent(AtHomeActivity.this,
							OnTheGoActivity.class));
				}
			}

			isDone = true;
			finish();

		} else {
			latLng = "Can't access your location";
		}
	}

	public class MovieListAppTask extends
			AsyncTask<Void, Void, List<ActionItem>> {

		protected List<ActionItem> doInBackground(Void... args) {

			List<ActionItem> data = new ArrayList<ActionItem>();
			
				JavaXmlDomReader jxdr = new JavaXmlDomReader();
				ArrayList<MovieModel> MovieList = jxdr
						.getMovieList(getBaseContext());
				for (int index = 0; index < MovieList.size(); index++) {
					try {
						MovieModel content = MovieList.get(index);

						if (content.getMovieID() != 0) {
							ActionItem item = new ActionItem();
							item.setActionname(content.getMovieName());
							item.setActionTime(content.getMovieTime());

							item.setActionTypeIcon((getBaseContext())
									.getResources()
									.getDrawable(
											UtilFunction.ActionTypeIconID(content
													.getMovieImageUrl())));
							item.setActionLocation(content.getLocation());
							item.setActionID(content.getMovieID());
							item.setActionType(content.getMovieType());
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

}
