package com.irsa;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import net.tsz.afinal.FinalHttp;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.location.Location;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesClient.ConnectionCallbacks;
import com.google.android.gms.common.GooglePlayServicesClient.OnConnectionFailedListener;
import com.google.android.gms.location.LocationClient;
import com.google.android.gms.location.LocationListener;
import com.irsa.AtWorkActivity.GoogleCalendarTask;
import com.irsa.AtWorkActivity.RestrantAppTask;
import com.irsa.service.MyService;

import com.statusmanager.model.UserModel;
import com.statusmanager.util.PubContant;
import com.statusmanager.util.UtilFunction;

public class LoginActivity extends Activity {
	private Button LoginButton;

	@Override
	protected void onPause() {
		// TODO Auto-generated method stub
		super.onPause();

	}

	private void updateLocation() {

		// ������������������������������������������
		if (PubContant.Current_Status == PubContant.Status_At_Home) {
			startActivity(new Intent(LoginActivity.this, AtHomeActivity.class));
			finish();
			return;
		} else {
			if (PubContant.Current_Status == PubContant.Status_At_Work) {
				startActivity(new Intent(LoginActivity.this,
						AtWorkActivity.class));
				finish();
				return;
			} else {
				finish();
				startActivity(new Intent(LoginActivity.this,
						OnTheGoActivity.class));
			}
		}

	}

	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();

	}

	private EditText LoginName;
	private EditText LoginPassword;
	private ProgressDialog progressDialog;
	private String loginName;
	private String loginPassword;
	private TextView RegisterLink;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.login);
		// setUpLocationClientIfNeeded();
		LoginButton = (Button) findViewById(R.id.signin_button);
		LoginName = (EditText) findViewById(R.id.username_edit);
		progressDialog = new ProgressDialog(this);
		progressDialog.setMessage(getString(R.string.loading));
		progressDialog.setCancelable(false);
		LoginPassword = (EditText) findViewById(R.id.password_edit);
		RegisterLink = (TextView) findViewById(R.id.register_link);
		
		RegisterLink.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				startActivity(new Intent(LoginActivity.this, Register.class));
			}
		});
		LoginButton.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				// HttpLogin();
				progressDialog = new ProgressDialog(LoginActivity.this);
				progressDialog.setMessage(getString(R.string.loading));
				progressDialog.setCancelable(false);
				progressDialog.show();
				Login();

			}
		});
	}
	
	private String MD5(String pwd){
		try {
	        MessageDigest m = MessageDigest.getInstance("MD5");
	        m.update(pwd.getBytes(), 0, pwd.length());
	        BigInteger i = new BigInteger(1,m.digest());
	        return String.format("%1$032x", i);         
	    } catch (NoSuchAlgorithmException e) {
	        e.printStackTrace();
	    }
	    return null;
	}

	private void Login() {
		if (fieldOk()) {
			new LoginAppTask().execute();

		}
	}

	public static final String SOAPNAMESPACE = "http://tempuri.org/";

	private boolean fieldOk() {
		boolean result = true;
		loginName = LoginName.getText().toString();
		loginPassword = MD5(LoginPassword.getText().toString());
		if (loginName == "" || loginPassword == "") {
			UtilFunction.creatRequestDialog(getApplicationContext(),
					"Please Enter loginName and password");
			result = false;
		}
		return result;
	}

	boolean isLoginSuccess = true;

	public class LoginAppTask extends AsyncTask<Void, Void, String> {

		protected String doInBackground(Void... args) {
			
			String result = "";
			try {

				FinalHttp pmHttp = new FinalHttp();
				result = pmHttp.get(PubContant.WEBSERVERUSER
						+ "?operation=login" + "&username=" + loginName
						+ "&userpassword=" + loginPassword);
				
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
			if (progressDialog != null) {
				progressDialog.dismiss();
				progressDialog = null;
			}
			if (result != null && !result.equals("failed")) {
				// ��������������������������UserModel������������������PubContant������
				UserModel userModel = new UserModel();
				String[] fieldArray = result.split(PubContant.interSplit);
				userModel.setUserid(Integer.parseInt(fieldArray[0]));
				userModel.setUsername(fieldArray[1]);
				userModel.setUserpassword(fieldArray[2]);
				userModel.setGoogleusername(fieldArray[3]);
				userModel.setGoogleuserpassword(fieldArray[4]);
				userModel.setGooglehomeusername(fieldArray[5]);
				userModel.setGooglehomeuserpassword(fieldArray[6]);
				PubContant.CurrentUser = userModel;

				new LocationIsComplete().execute();
			} else {
				Toast.makeText(getBaseContext(),
						"Account and Password mismatch", Toast.LENGTH_LONG)
						.show();
			}

		}
	}

	class MyBroadReciver extends BroadcastReceiver {
		@Override
		public void onReceive(Context context, Intent intent) {
			PubContant.Current_Status = intent.getIntExtra("msgFromServ",
					PubContant.Status_At_Home);
		}

	}
	
	public class LocationIsComplete extends AsyncTask<Void, Void, String> {

		protected String doInBackground(Void... args) {
			Intent itstart = new Intent(getApplicationContext(), MyService.class);
			startService(itstart);
			String result = "";
			try {

				FinalHttp pmHttp = new FinalHttp();
				result = pmHttp.get(PubContant.WEBSERVERUSER
						+ "?operation=isCompleteLocation" + "&username="
						+ loginName + "&userpassword=" + loginPassword);
				
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
			if (progressDialog != null) {
				progressDialog.dismiss();
				progressDialog = null;
			}
			if (result != null && !result.equals("failed")) {

				// ��������������������������
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
							PubContant.ATHOME_LAT = lat;
							PubContant.ATHOME_LON = lon;

						}
						if (locationType == PubContant.LocationAtWork) {
							PubContant.ATWORK_LAT = lat;
							PubContant.ATWORK_LON = lon;
						}
					} catch (NumberFormatException e) {

					}

					updateLocation();
					
				}
			} else {
				Toast.makeText(getBaseContext(),
						"Please choose your work and home location",
						Toast.LENGTH_LONG).show();
				startActivity(new Intent(LoginActivity.this,
						MultiMapDemoActivity.class));
				finish();
			}

		}
	}

}
