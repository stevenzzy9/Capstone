package com.irsa;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.statusmanager.util.GMailSender;
import com.statusmanager.util.PubContant;

public class EmailActivity extends Activity {
	private Button sendEmailButton;
	private EditText emailTitle;

	private EditText emailTo;
	private EditText emailContent;
	private TextView emailstatus;
	private String emailTitleString;
	private String emailToString;
	private String emailCCString;
	private String emailContentString;
	private Handler AtWorkHandler = new Handler();
	private int EmailFrom;
	private boolean isEmpty(String judgeString) {
		if (judgeString == null || judgeString.equals("")) {
			return true;
		}
		return false;
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.email);
		sendEmailButton = (Button) findViewById(R.id.sendmail);
		emailTitle = (EditText) findViewById(R.id.emailTitle);
		emailTo = (EditText) findViewById(R.id.emailTo);
		emailstatus=(TextView) findViewById(R.id.emailstatus);
		emailContent = (EditText) findViewById(R.id.emailContent);
		Intent intent = getIntent();
		EmailFrom  = intent.getIntExtra("from",PubContant.Status_At_Home);
        if(EmailFrom==PubContant.Status_At_Home)
        {
        	emailstatus.setText("From Home Email");
        	
        }
        else
        {
        	emailstatus.setText("From Work Email");
        }
		
		sendEmailButton.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				emailTitleString = emailTitle.getText().toString();
				emailToString = emailTo.getText().toString();

				emailContentString = emailContent.getText().toString();
				if (isEmpty(emailTitleString) || isEmpty(emailToString)

				|| isEmpty(emailContentString)) {
					Toast.makeText(getBaseContext(),
							"Some field must be filled", Toast.LENGTH_LONG)
							.show();
				} else {
					AtWorkHandler.post(runnable);
					
				}
			}
		});
	}
	Runnable runnable = new Runnable() {
		@Override
		public void run() {
			new RestrantAppTask().execute();
		}
	};
	public class RestrantAppTask extends AsyncTask<Void, Void, String> {

		protected String doInBackground(Void... args) {
			String sendMailReturnString = "";
			try {
				GMailSender sender = null;
				if (EmailFrom == PubContant.Status_At_Home) {
					sender = new GMailSender(PubContant.CurrentUser.getGooglehomeusername(),
							PubContant.CurrentUser.getGooglehomeuserpassword());
				} else {
					sender = new GMailSender(PubContant.CurrentUser.getGoogleusername(),
							PubContant.CurrentUser.getGoogleuserpassword());
				}
				sendMailReturnString = sender.sendMail(emailTitleString,
						emailContentString, "testcapcal@gmail.com",
						emailToString);

			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
			return sendMailReturnString;
		}

		protected void onPostExecute(String result) {

			if (result.equals("success")) {
				Toast.makeText(getBaseContext(), "send mail success",
						Toast.LENGTH_LONG).show();
			} else {
				Toast.makeText(getBaseContext(), "send mail failed",
						Toast.LENGTH_LONG).show();
			}
		}
	}

}
