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

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import net.tsz.afinal.FinalHttp;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.apache.http.util.EntityUtils;

import android.content.Intent;
import android.graphics.Color;
import android.location.Location;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.FragmentActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.MenuItem.OnMenuItemClickListener;
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
import com.google.android.gms.maps.GoogleMap.OnMarkerClickListener;
import com.google.android.gms.maps.GoogleMap.OnMyLocationButtonClickListener;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.maps.model.Polyline;
import com.google.android.gms.maps.model.PolylineOptions;
import com.google.android.maps.GeoPoint;
import com.irsa.AtHomeActivity.MovieListAppTask;

import com.statusmanager.listview.ActionItem;
import com.statusmanager.model.Facility;
import com.statusmanager.model.MovieModel;
import com.statusmanager.util.JavaXmlDomReader;
import com.statusmanager.util.PubContant;
import com.statusmanager.util.UtilFunction;

/**
 * This demo shows how GMS Location can be used to check for changes to the
 * users location. The "My Location" button uses GMS Location to set the blue
 * dot representing the users location. To track changes to the users location
 * on the map, we request updates from the {@link LocationClient}.
 */
public class OnTheGoActivity extends FragmentActivity implements
		ConnectionCallbacks, OnConnectionFailedListener, LocationListener,
		OnMyLocationButtonClickListener {
	private boolean isDone = false;
	private Button setlocation;
	private Handler AtWorkHandler = new Handler();
	private LinearLayout linearLayout = null;
	private GoogleMap mMap;
	private LatLng currentPosition = new LatLng(20, 100);
	private LocationClient mLocationClient;
	private Handler OnTheGoHandler = new Handler();
	private String currentPositionString="";
	private String goalPositionString="";
	private PolylineOptions polyoption;
	private Polyline line;
	String currentLocation = "";
	// These settings are the same as the settings for the map. They will in
	// fact give you updates
	// at the maximal rates currently possible.
	private static final LocationRequest REQUEST = LocationRequest.create()
			.setSmallestDisplacement(1000.0f)
			.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.my_location_demo);

		setlocation = (Button) findViewById(R.id.setlocation);
		setlocation.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				startActivity(new Intent(OnTheGoActivity.this,
						UpdateMultiMapDemoActivity.class));
			}
		});
		isDone = false;
		
		setUpLocationClientIfNeeded();

	}
	Runnable Route = new Runnable() {
		@Override
		public void run() {
			// TODO Auto-generated method stub
			// ���������������
			new ShowPOI().execute(currentPositionString,goalPositionString);
			
		}
	};
	@Override
	protected void onResume() {
		super.onResume();
		setUpMapIfNeeded();
		setUpLocationClientIfNeeded();
		mLocationClient.connect();

	}
	
	

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// TODO Auto-generated method stub
		menu.add("Personal Information").setOnMenuItemClickListener(
				new OnMenuItemClickListener() {

					@Override
					public boolean onMenuItemClick(MenuItem item) {
						// TODO Auto-generated method stub
						startActivity(new Intent(OnTheGoActivity.this,
								Account.class));
						return false;
					}
				});
		return super.onCreateOptionsMenu(menu);
		//return super.onCreateOptionsMenu(menu);
	}



	@Override
	public void onPause() {
		super.onPause();
		setUpLocationClientIfNeeded();
		mLocationClient.connect();
	}

	private void setUpMapIfNeeded() {
		// Do a null check to confirm that we have not already instantiated the
		// map.
		if (mMap == null) {
			// Try to obtain the map from the SupportMapFragment.
			mMap = ((SupportMapFragment) getSupportFragmentManager()
					.findFragmentById(R.id.map)).getMap();
			// Check if we were successful in obtaining the map.
			if (mMap != null) {
				mMap.setMyLocationEnabled(true);
				mMap.setOnMyLocationButtonClickListener(this);

			}
			mMap.setOnMarkerClickListener(new OnMarkerClickListener() {

				@Override
				public boolean onMarkerClick(Marker arg0) {
					LatLng p = arg0.getPosition();
					arg0.showInfoWindow();
					currentPositionString=currentPosition.latitude
							+ "," + currentPosition.longitude;
					goalPositionString=p.latitude + ","
							+ p.longitude;
					AtWorkHandler.post(Route);
					

					return true;
				}

			});
		}
	}
	
	
	

	public class ShowPOI extends AsyncTask<String, Void, 	String> {
		
		@Override
		protected String doInBackground(String... args) {
			String result = "";
			try {

				FinalHttp pmHttp = new FinalHttp();
				String url = "http://maps.google.com/maps/api/directions/xml?origin="+args[0] +
						"&destination="+args[1]+"&sensor=false&mode=walking";
				result = pmHttp.get(url);

				return result;
			} catch (Exception e) {
				// TODO Auto-generated catch block
				Toast.makeText(getBaseContext(),
						"Sorry register error \n.reason:" + result,
						Toast.LENGTH_LONG).show();
			}
			return result;
		}

		protected void onPostExecute(String result) {
			drawRoute(result);
		}

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

	/**
	 * Implementation of {@link LocationListener}.
	 */
	@Override
	public void onLocationChanged(Location location) {
		if (!isDone)
			updateLocation(location);
	}

	/**
	 * Callback called when connected to GCore. Implementation of
	 * {@link ConnectionCallbacks}.
	 */
	@Override
	public void onConnected(Bundle connectionHint) {
		mLocationClient.requestLocationUpdates(REQUEST, this); // LocationListener
	}

	/**
	 * Callback called when disconnected from GCore. Implementation of
	 * {@link ConnectionCallbacks}.
	 */
	@Override
	public void onDisconnected() {
		// Do nothing
	}

	/**
	 * Implementation of {@link OnConnectionFailedListener}.
	 */
	@Override
	public void onConnectionFailed(ConnectionResult result) {
		// Do nothing
	}

	private void updateLocation(Location location) {
		String latLng;

		if (location != null) {
			double lat = location.getLatitude();
			double lng = location.getLongitude();
			if ((currentPosition.latitude != lat || currentPosition.longitude != lng)) {
				currentPosition = new LatLng(lat, lng);

				mMap.moveCamera(CameraUpdateFactory.newLatLng(currentPosition));
				mMap.animateCamera(CameraUpdateFactory.zoomTo(18));
				Random random = new Random();
			
				currentLocation = "" + lat + "," + lng;
				OnTheGoHandler.post(runnable);
			}

			// ������������������������������������������
			if (Math.abs(lat - PubContant.ATHOME_LAT) < PubContant.Lat_Lon_Distance
					&& Math.abs(lng - PubContant.ATHOME_LON) < PubContant.Lat_Lon_Distance) {

				finish();
				startActivity(new Intent(OnTheGoActivity.this,
						AtHomeActivity.class));

				isDone = true;
				return;
			} else {
				if (Math.abs(lat - PubContant.ATWORK_LAT) < PubContant.Lat_Lon_Distance
						&& Math.abs(lng - PubContant.ATWORK_LON) < PubContant.Lat_Lon_Distance) {

					finish();
					startActivity(new Intent(OnTheGoActivity.this,
							AtWorkActivity.class));
					finish();
					isDone = true;
					return;
				}

			}

		} else {
			latLng = "Can't access your location";
		}
	}

	Runnable runnable = new Runnable() {
		@Override
		public void run() {
			new NearbyFacility().execute();
		}
	};

	@Override
	public boolean onMyLocationButtonClick() {
		Toast.makeText(this, "MyLocation button clicked", Toast.LENGTH_SHORT)
				.show();
		// Return false so that we don't consume the event and the default
		// behavior still occurs
		// (the camera animates to the user's current position).
		return false;
	}

	private final double EARTH_RADIUS = 6378137.0;

	private double gps2m(double lat_a, double lng_a, double lat_b, double lng_b) {
		double radLat1 = (lat_a * Math.PI / 180.0);
		double radLat2 = (lat_b * Math.PI / 180.0);
		double a = radLat1 - radLat2;
		double b = (lng_a - lng_b) * Math.PI / 180.0;
		double s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a / 2), 2)
				+ Math.cos(radLat1) * Math.cos(radLat2)
				* Math.pow(Math.sin(b / 2), 2)));
		s = s * EARTH_RADIUS;
		s = Math.round(s * 10000) / 10000;
		return s;

	}
	 /**
		 * �����������������google map��������������xml������������map������������������
		 */
		public void drawRoute(String strResult){
			
			
			
		
			
			if (-1 == strResult.indexOf("<status>OK</status>")){
			
				this.finish();
				return;
			}
			
			int pos = strResult.indexOf("<overview_polyline>");
			pos = strResult.indexOf("<points>", pos + 1);
			int pos2 = strResult.indexOf("</points>", pos);
			strResult = strResult.substring(pos + 8, pos2);
			
			List<LatLng> points = decodePoly(strResult);
			
			polyoption=new PolylineOptions().width(5).color(Color.RED);  
			
			for(int i=0;i<points.size();i++)
			{
				
				polyoption.add(new LatLng(points.get(i).latitude, points.get(i).longitude));
			}
			if(line !=null)
			{
			line.remove();
			}
			line= mMap.addPolyline(polyoption);
			
			
//			if (points.size() >= 2){
//				mMap.moveCamera(CameraUpdateFactory.newLatLng(new LatLng(points.get(0).getLatitudeE6(),points.get(0).getLongitudeE6())));
//			}
			 
		
		}
		 /**
		 * ������������������������xml������overview_polyline����������������������
		 * 
		 * @param encoded
		 * @return
		 */
		private List<LatLng> decodePoly(String encoded) {

		    List<LatLng> poly = new ArrayList<LatLng>();
		    int index = 0, len = encoded.length();
		    int lat = 0, lng = 0;

		    while (index < len) {
		        int b, shift = 0, result = 0;
		        do {
		            b = encoded.charAt(index++) - 63;
		            result |= (b & 0x1f) << shift;
		            shift += 5;
		        } while (b >= 0x20);
		        int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
		        lat += dlat;

		        shift = 0;
		        result = 0;
		        do {
		            b = encoded.charAt(index++) - 63;
		            result |= (b & 0x1f) << shift;
		            shift += 5;
		        } while (b >= 0x20);
		        int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
		        lng += dlng;

		        LatLng p = new LatLng(((double) lat / 1E5) ,
		             ((double) lng / 1E5));
		        poly.add(p);
		    }

		    return poly;
		}
	public class NearbyFacility extends
			AsyncTask<Void, Void, ArrayList<Facility>> {

		protected ArrayList<Facility> doInBackground(Void... args) {
			ArrayList<Facility> resultFacility = new ArrayList<Facility>();

			String result = "";

			String radius = "1000";
			String sensor = "true";

			String urlString = PubContant.hostString + "location="
					+ currentLocation + "&" + "radius=" + radius + "&sensor="
					+ sensor + "&types=food|cafe" + "&key=" + PubContant.apiKey;
			try {
				FinalHttp pmHttp = new FinalHttp();
				result = pmHttp.get(urlString);
				resultFacility = UtilFunction.ParseAPISearchJson(result);
				return resultFacility;
			} catch (Exception e) {
				// TODO Auto-generated catch block

			}

			return resultFacility;
		}

		protected void onPostExecute(ArrayList<Facility> resultFacility) {
			
		
			
			for (int i = 0; i < resultFacility.size(); i++) {
				double tempLat = Double.parseDouble(resultFacility.get(i).lat);
				double tempLon = Double.parseDouble(resultFacility.get(i).lng);
				LatLng tempPosition = new LatLng(tempLat, tempLon);
				Double distance = gps2m(currentPosition.latitude,
						currentPosition.longitude, tempLat, tempLon);
				Marker tempMarker = mMap.addMarker(new MarkerOptions()
						.position(tempPosition)
						.title(resultFacility.get(i).name + "   " + distance
								+ " m").snippet(resultFacility.get(i).vicinity)
						.infoWindowAnchor(0.5f, 0.5f));

			}
		}

	}
}
