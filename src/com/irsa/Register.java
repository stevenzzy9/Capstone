package com.irsa;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;

import com.statusmanager.util.PubContant;
import com.statusmanager.util.UtilFunction;

import net.tsz.afinal.FinalHttp;



import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class Register extends Activity {
	private Button RegisterButton;
	private EditText RegisterName;
	private EditText RegisterPassword;
	private EditText GoogleUserName;
	private EditText GooglePassword;
	private EditText GoogleHomeUserName;
	private EditText GoogleHomePassword;
	private String registerName = "";
	private String registerPassword = "";
	private String registerGoogleUserName = "";
	private String registerGooglePassword = "";
	private String registerGoogleHomeUserName="";
	private String registerGoogleHomePassword="";
	private ProgressDialog progressDialog;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.register);
		RegisterButton = (Button) findViewById(R.id.register_button);
		RegisterName = (EditText) findViewById(R.id.username_edit);
		RegisterPassword = (EditText) findViewById(R.id.password_edit);
		GoogleUserName = (EditText) findViewById(R.id.google_account_edit);
		GooglePassword = (EditText) findViewById(R.id.google_password_edit);
		GoogleHomeUserName= (EditText) findViewById(R.id.google_account_home_edit);
		GoogleHomePassword= (EditText) findViewById(R.id.google_password_home_edit);
		super.onCreate(savedInstanceState);
		progressDialog = new ProgressDialog(this);
		progressDialog.setMessage(getString(R.string.loading));
		progressDialog.setCancelable(false);
		
		RegisterButton.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				progressDialog = new ProgressDialog(Register.this);
				progressDialog.setMessage(getString(R.string.loading));
				progressDialog.setCancelable(false);
				progressDialog.show();
				Register();
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

	private void Register() {
		if (fieldOk()) {
			new RegisterAppTask().execute();
			// ����������������������������������

		}
	}

	private boolean fieldOk() {
		boolean result = true;
		registerName = RegisterName.getText().toString();
		registerPassword = MD5(RegisterPassword.getText().toString());
		registerGoogleUserName = GoogleUserName.getText().toString();
		registerGooglePassword = GooglePassword.getText().toString();
		registerGoogleHomeUserName= GoogleHomeUserName.getText().toString();
		registerGoogleHomePassword= GoogleHomePassword.getText().toString();
		if (registerName == "" || registerPassword == ""
				|| registerGoogleUserName == "" || registerGooglePassword == ""
				||registerGoogleHomeUserName==""||registerGoogleHomePassword=="") {
			UtilFunction.creatRequestDialog(getApplicationContext(),
					"Please Enter empty field");
			result = false;
		}
		return result;
	}

	boolean isRegisterSuccess = true;
	

	

	public class RegisterAppTask extends AsyncTask<Void, Void, String> {

		protected String doInBackground(Void... args) {

			String result = "";
			try {  

				FinalHttp pmHttp = new FinalHttp();
				result = pmHttp.get(PubContant.WEBSERVERUSER
						+ "?operation=register" + "&username="
						+ registerName + "&userpassword="
						+ registerPassword + "&googleusername="
						+ registerGoogleUserName + "&googlepassword="
						+ registerGooglePassword+"&googlehomeusername="
						+registerGoogleHomeUserName+"&googlehomeuserpassword="
						+registerGoogleHomePassword
						);
				
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
			if (result!=null&&result.equals("ok")) {
				Toast.makeText(getBaseContext(),
						"register success!", Toast.LENGTH_LONG)
						.show();
				startActivity(new Intent(Register.this,
						LoginActivity.class));
				finish();
			}
			else
			{
				Toast.makeText(getBaseContext(),
						"register failed!\n reason:"+result, Toast.LENGTH_LONG)
						.show();
			} 
			
		}
	}
}
