/*
 * Copyright (C) 2012 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.irsa;

import net.tsz.afinal.FinalHttp;
import android.app.ProgressDialog;
import android.content.Intent;
import android.location.Location;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.FragmentActivity;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.Toast;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesClient.ConnectionCallbacks;
import com.google.android.gms.common.GooglePlayServicesClient.OnConnectionFailedListener;
import com.google.android.gms.location.LocationClient;
import com.google.android.gms.location.LocationListener;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.GoogleMap.OnMapClickListener;
import com.google.android.gms.maps.GoogleMap.OnMarkerDragListener;
import com.google.android.gms.maps.GoogleMap.OnMyLocationButtonClickListener;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;

import com.statusmanager.model.UserLocation;
import com.statusmanager.util.PubContant;


public class MultiMapDemoActivity extends FragmentActivity implements
		ConnectionCallbacks, OnConnectionFailedListener, LocationListener,
		OnMyLocationButtonClickListener, OnMapClickListener,
		OnMarkerDragListener {
	private Handler handler = new Handler();
	private Button button;

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// TODO Auto-generated method stub

		return super.onCreateOptionsMenu(menu);
	}
	private LinearLayout linearLayout = null;
	private GoogleMap mAtHomeMap;
	private GoogleMap mAtWorkMap;
	private UserLocation AtHomeLocation;
	private UserLocation AtWorkLocation;
	private ProgressDialog progressDialog;
	private LocationClient mLocationClient;
	// These settings are the same as the settings for the map. They will in
	// fact give you updates
	// at the maximal rates currently possible.
	private static final LocationRequest REQUEST = LocationRequest.create()
			.setInterval(5000) // 5 seconds
			.setFastestInterval(16) // 16ms = 60fps
			.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);

	private void setUpMapIfNeeded() {
		// Do a null check to confirm that we have not already instantiated the
		// map.
		if (mAtHomeMap == null) {
			// Try to obtain the map from the SupportMapFragment.
			mAtHomeMap = ((SupportMapFragment) getSupportFragmentManager()
					.findFragmentById(R.id.AtHomeMap)).getMap();
			// Check if we were successful in obtaining the map.
			if (mAtHomeMap != null) {
				mAtHomeMap.setMyLocationEnabled(true);
				mAtHomeMap.setOnMapClickListener(new OnMapClickListener() {

					@Override
					public void onMapClick(LatLng arg0) {
						// TODO Auto-generated method stub
						AtHomeLocation = new UserLocation();
						AtHomeLocation.setUserid(PubContant.CurrentUser
								.getUserid());
						AtHomeLocation.setLocation(arg0.latitude + ","
								+ arg0.longitude);
						AtHomeLocation
								.setLocationtype(PubContant.LocationAtHome);

						mAtHomeMap.clear();
						Marker mPerth = mAtHomeMap
								.addMarker(new MarkerOptions().draggable(true)
										.position(arg0).title("home"));
						mAtHomeMap.moveCamera(CameraUpdateFactory
								.newLatLng(arg0));
					}
				});
			}
		}
		if (mAtWorkMap == null) {
			// Try to obtain the map from the SupportMapFragment.
			mAtWorkMap = ((SupportMapFragment) getSupportFragmentManager()
					.findFragmentById(R.id.AtWorkMap)).getMap();
			// Check if we were successful in obtaining the map.
			if (mAtWorkMap != null) {
				mAtWorkMap.setMyLocationEnabled(true);
				mAtWorkMap.setOnMapClickListener(new OnMapClickListener() {

					@Override
					public void onMapClick(LatLng arg0) {
						// TODO Auto-generated method stub

						AtWorkLocation = new UserLocation();
						AtWorkLocation.setUserid(PubContant.CurrentUser
								.getUserid());
						AtWorkLocation.setLocation(arg0.latitude + ","
								+ arg0.longitude);
						AtWorkLocation
								.setLocationtype(PubContant.LocationAtWork);
						mAtWorkMap.clear();
						Marker mPerth = mAtWorkMap
								.addMarker(new MarkerOptions().draggable(true)
										.position(arg0).title("work"));
						mAtWorkMap.moveCamera(CameraUpdateFactory
								.newLatLng(arg0));

					}
				});
			}
		}

	}

	@Override
	public void onBackPressed() {
		// TODO Auto-generated method stub
		super.onBackPressed();
		
	}

	@Override
	protected void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
	}

	@Override
	protected void onPause() {
		// TODO Auto-generated method stub
		super.onPause();
		if (mLocationClient != null) {
			mLocationClient.disconnect();
		}
	}

	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		setUpMapIfNeeded();
		setUpLocationClientIfNeeded();
		mLocationClient.connect();
	}

	private void setUpLocationClientIfNeeded() {
		if (mLocationClient == null) {
			mLocationClient = new LocationClient(getApplicationContext(), this, // ConnectionCallbacks
					this); // OnConnectionFailedListener
		}
	}

	/**
	 * Button to get current Location. This demonstrates how to get the current
	 * Location as required without needing to register a LocationListener.
	 */
	public void showMyLocation(View view) {
		if (mLocationClient != null && mLocationClient.isConnected()) {
			String msg = "Location = " + mLocationClient.getLastLocation();
			Toast.makeText(getApplicationContext(), msg, Toast.LENGTH_SHORT)
					.show();
		}
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.multimap_demo);

		
		button = (Button) findViewById(R.id.updatelocation);
		button.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if (AtWorkLocation == null) {
					Toast.makeText(getBaseContext(),
							"Please choose the work location",
							Toast.LENGTH_LONG).show();

				} else {
					if (AtHomeLocation == null) {
						Toast.makeText(getBaseContext(),
								"Please choose the home location",
								Toast.LENGTH_LONG).show();
					} else {
						new UpdateLocation().execute();
					}
				}

			}
		});
		
		// ��ȡ���û����趨��λ��
		progressDialog = new ProgressDialog(this);
		progressDialog.setMessage(getString(R.string.loading));
		progressDialog.setCancelable(false);
		progressDialog.show();
		new GetLocation().execute();
	}

	@Override
	public void onMapClick(LatLng arg0) {
		// TODO Auto-generated method stub
		// mTapTextView.setText("tapped, point=" + arg0);
	}

	@Override
	public void onMarkerDrag(Marker arg0) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onMarkerDragEnd(Marker arg0) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onMarkerDragStart(Marker arg0) {
		// TODO Auto-generated method stub

	}

	@Override
	public boolean onMyLocationButtonClick() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public void onLocationChanged(Location arg0) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onConnectionFailed(ConnectionResult arg0) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onConnected(Bundle arg0) {
		// TODO Auto-generated method stub
		mLocationClient.requestLocationUpdates(REQUEST, this); // LocationListener
	}

	@Override
	public void onDisconnected() {
		// TODO Auto-generated method stub

	}

	public class GetLocation extends AsyncTask<Void, Void, String> {

		protected String doInBackground(Void... args) {

			String result = "";
			try {

				FinalHttp pmHttp = new FinalHttp();
				result = pmHttp.get(PubContant.WEBSERVERLOCATIONUPDATE

				+ "?operationType=getlocation" + "&userid=" +PubContant.CurrentUser.getUserid());

				return result;
			} catch (Exception e) {
				// TODO Auto-generated catch block
				Toast.makeText(getBaseContext(),
						"Sorry register error \n.reason:" + result,
						Toast.LENGTH_LONG).show();
				result="failed";
				return result;
			}
			
		}

		protected void onPostExecute(String result) {
			if (progressDialog != null) {
				progressDialog.dismiss();
				progressDialog = null;
			}
			
			if (result != null&&!result.equals("failed")) {
				
				// ������λ��
				String[] splitResult = result.split(";");
				for (int i = 0; i < splitResult.length; i++) {
					try {
						Double lat = Double.parseDouble(splitResult[i]
								.split(",")[0]);
						Double lon = Double.parseDouble(splitResult[i]
								.split(",")[1]);
						int locationType = Integer.parseInt(splitResult[i]
								.split(",")[2]);
						if (locationType == PubContant.LocationAtHome) {
							LatLng location = new LatLng(lat, lon);
							AtHomeLocation = new UserLocation();
							AtHomeLocation.setUserid(PubContant.CurrentUser
									.getUserid());
							AtHomeLocation.setLocation(location.latitude + ","
									+ location.longitude);
							AtHomeLocation
									.setLocationtype(PubContant.LocationAtHome);
							Marker mPerth = mAtHomeMap
									.addMarker(new MarkerOptions()
											.draggable(true).position(location)
											.title("home"));
							mAtHomeMap.moveCamera(CameraUpdateFactory
									.newLatLng(location));
						}
						if (locationType == PubContant.LocationAtWork) {
							LatLng location = new LatLng(lat, lon);
							AtWorkLocation = new UserLocation();
							AtWorkLocation.setUserid(PubContant.CurrentUser
									.getUserid());
							AtWorkLocation.setLocation(location.latitude + ","
									+ location.longitude);
							AtWorkLocation
									.setLocationtype(PubContant.LocationAtWork);
							Marker mPerth = mAtWorkMap
									.addMarker(new MarkerOptions().draggable(true)
											.position(location).title("work"));
							mAtWorkMap.moveCamera(CameraUpdateFactory
									.newLatLng(location));
						}
					} catch (NumberFormatException e) {

					}
					
					
				}
			} else {

			}

		}
	}

	public class UpdateLocation extends AsyncTask<Void, Void, String> {

		protected String doInBackground(Void... args) {

			String result = "";
			try {

				FinalHttp pmHttp = new FinalHttp();
				result = pmHttp.get(PubContant.WEBSERVERLOCATIONUPDATE

				+ "?operationType=updatethroughmap" + "&homelocation="
						+ AtHomeLocation.getLocation() + "&worklocation="
						+ AtWorkLocation.getLocation() + "&userid=" + PubContant.CurrentUser
						.getUserid());

				return result;
			} catch (Exception e) {
				// TODO Auto-generated catch block
				Toast.makeText(getBaseContext(),
						"Sorry update error \n.reason:" + result,
						Toast.LENGTH_LONG).show();
			}
			return result;
		}

		protected void onPostExecute(String result) {
			if (progressDialog != null) {
				progressDialog.dismiss();
				progressDialog = null;
			}
			if (result != null && !result.equals("failed")) {
				Toast.makeText(getBaseContext(), "Success", Toast.LENGTH_LONG)
				.show();
				
			} else {

				Toast.makeText(getBaseContext(),
						"Sorry update Error\nPlease Check Your Location",
						Toast.LENGTH_LONG).show();
				
			}

		}
	}

}
