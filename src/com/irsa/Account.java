package com.irsa;

import net.tsz.afinal.FinalHttp;

import com.irsa.Register.RegisterAppTask;
import com.statusmanager.util.PubContant;
import com.statusmanager.util.UtilFunction;

import android.os.AsyncTask;
import android.os.Bundle;
import android.app.Activity;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

public class Account extends Activity {
	
	private Button updateButton;
	
	private EditText workAcc;
	private EditText workPwd;
	private EditText homeAcc;
	private EditText homePwd;
	private String upworkAcc = "";
	private String upworkPwd = "";
	private String uphomeAcc="";
	private String uphomePwd="";

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_account);
		
		updateButton = (Button)findViewById(R.id.update_button);
		workAcc = (EditText)findViewById(R.id.workacc);
		workPwd = (EditText)findViewById(R.id.workpwd);
		homeAcc = (EditText)findViewById(R.id.homeacc);
		homePwd = (EditText)findViewById(R.id.homepwd);
		String wa = PubContant.CurrentUser.getGoogleusername();
		String wp = PubContant.CurrentUser.getGoogleuserpassword();
		
		String ha = PubContant.CurrentUser.getGooglehomeusername();
		String hp = PubContant.CurrentUser.getGooglehomeuserpassword();
		
		workAcc.setText(wa);
		workPwd.setText(wp);
		homeAcc.setText(ha);
		homePwd.setText(hp);
		updateButton.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				update();
			}
			
		});
		
		
		
	}
	
	private void update(){
		
		
		if (fieldOk()){
			new updateAppTask().execute();
		}
	}
	
	public class updateAppTask extends AsyncTask<Void, Void, String>{
		
		String result = "";

		@Override
		protected String doInBackground(Void... params) {
			// TODO Auto-generated method stub
			
			FinalHttp pmHttp = new FinalHttp();
			
			
			return result;
		}
		

		@Override
		protected void onPostExecute(String result) {
			// TODO Auto-generated method stub
			//super.onPostExecute(result);
			if (result!=null&&result.equals("ok")) {
				Toast.makeText(getBaseContext(),
						"Update success!", Toast.LENGTH_LONG)
						.show();
				finish();
				}else{
					
					Toast.makeText(getBaseContext(),
							"Update success!"+result, Toast.LENGTH_LONG)
							.show();
					}
				}
				
		
		
		
	}
	
	private boolean fieldOk() {
		boolean result = true;
		
		upworkAcc = workAcc.getText().toString();
		upworkPwd = workPwd.getText().toString();
		uphomeAcc = homeAcc.getText().toString();
		uphomePwd = homePwd.getText().toString();
		if ( upworkAcc == "" || upworkPwd == ""
				||uphomeAcc==""||uphomePwd=="") {
			UtilFunction.creatRequestDialog(getApplicationContext(),
					"Please Enter empty field");
			result = false;
		}
		return result;
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.account, menu);
		return true;
	}

}
