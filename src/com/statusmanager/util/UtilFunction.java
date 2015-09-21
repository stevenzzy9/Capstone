package com.statusmanager.util;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.ksoap2.SoapEnvelope;
import org.ksoap2.serialization.SoapObject;
import org.ksoap2.serialization.SoapPrimitive;
import org.ksoap2.serialization.SoapSerializationEnvelope;
import org.ksoap2.transport.HttpTransportSE;
import org.xmlpull.v1.XmlPullParserException;

import android.app.Dialog;
import android.app.WallpaperManager;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import com.irsa.R;
import com.statusmanager.model.Facility;

public class UtilFunction {
	public String[] MoviesPicture = {};

	public static Dialog creatRequestDialog(final Context context, String tip) {

		final Dialog dialog = new Dialog(context, R.style.mask_dialog);
		dialog.setContentView(R.layout.dialog_layout);
		Window window = dialog.getWindow();
		WindowManager.LayoutParams lp = window.getAttributes();
		int width = UtilFunction.getScreenWidth(context);
		lp.width = (int) (0.6 * width);

		TextView titleTxtv = (TextView) dialog.findViewById(R.id.tvLoad);
		if (tip == null || tip.length() == 0) {
			titleTxtv.setText("Sending request...");
		} else {
			titleTxtv.setText(tip);
		}

		return dialog;
	}

	public static final String SOAPNAMESPACE = "http://tempuri.org/";

	/**
	 * ��ȡJson���
	 * 
	 * @param paramMap
	 *            �����෵�صĲ������
	 * @return Json���
	 */
	public static String GetJson(String url, Map<String, String> paramMap) {
		String result = null;
		HttpPost httpRequest = new HttpPost(url);
		List<NameValuePair> params = new ArrayList<NameValuePair>();
		for (Map.Entry<String, String> param : paramMap.entrySet()) {
			params.add(new BasicNameValuePair(param.getKey(), param.getValue()));
		}
		try {
			HttpEntity httpEntity = new UrlEncodedFormEntity(params, "UTF-8");
			httpRequest.setEntity(httpEntity);
			HttpClient httpClient = new DefaultHttpClient();
			HttpResponse httpResponse = httpClient.execute(httpRequest);
			if (httpResponse.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
				result = EntityUtils.toString(httpResponse.getEntity());
				return result;
			}
		} catch (Exception e) {
			return null;
		}
		return null;
	}

	public static int getScreenWidth(Context context) {
		WindowManager manager = (WindowManager) context
				.getSystemService(Context.WINDOW_SERVICE);
		Display display = manager.getDefaultDisplay();
		return display.getWidth();
	}

	public static int getScreenHeight(Context context) {
		WindowManager manager = (WindowManager) context
				.getSystemService(Context.WINDOW_SERVICE);
		Display display = manager.getDefaultDisplay();
		return display.getHeight();
	}

	public static float getScreenDensity(Context context) {
		try {
			DisplayMetrics dm = new DisplayMetrics();
			WindowManager manager = (WindowManager) context
					.getSystemService(Context.WINDOW_SERVICE);
			manager.getDefaultDisplay().getMetrics(dm);
			return dm.density;
		} catch (Exception ex) {

		}
		return 1.0f;
	}

	public static String GetSoapObject(String URL, String Function,
			Map<String, String> propertyMap) {
		String result = "";
		SoapObject soapObject = new SoapObject(SOAPNAMESPACE, Function);
		Iterator iter = propertyMap.entrySet().iterator();

		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();
			Object key = entry.getKey();
			Object val = entry.getValue();
			soapObject.addProperty(key.toString(), val.toString());
		}

		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
				SoapEnvelope.VER11); // �汾

		envelope.bodyOut = soapObject;

		envelope.dotNet = true;

		envelope.setOutputSoapObject(soapObject);

		HttpTransportSE trans = new HttpTransportSE(URL);

		trans.debug = true; // ʹ�õ��Թ���

		try {

			trans.call(SOAPNAMESPACE + Function, envelope);
			if (envelope.getResponse() != null) {
				SoapPrimitive sp = (SoapPrimitive) envelope.getResponse();
				result = sp.toString();
			}
			System.out.println("Call Successful!");
		}

		catch (IOException e) {
			System.out.println("IOException");

			e.printStackTrace();

		} catch (XmlPullParserException e) {

			System.out.println("XmlPullParserException");

			e.printStackTrace();

		}

		return result;

	}

	public static Bitmap rotate(Bitmap b, float degrees) {
		if (degrees != 0 && b != null) {
			Matrix m = new Matrix();
			m.setRotate(degrees, (float) b.getWidth() / 2,
					(float) b.getHeight() / 2);
			try {
				Bitmap b2 = Bitmap.createBitmap(b, 0, 0, b.getWidth(),
						b.getHeight(), m, true);
				if (b != b2) {
					b.recycle(); // Android�������ٴ���ʾBitmap������Ӧ����ʾ���ͷ�
					b = b2;
				}
			} catch (OutOfMemoryError ex) {
				// Android123��������γ������ڴ治���쳣�����return ԭʼ��bitmap����.
			}
		}
		return b;
	}

	public static int ActionTypeIconID(String ActionType) {
		int ActionTypeIconId = 0;

		ActionTypeIconId = getResourceImageID(ActionType);
		if (ActionTypeIconId == 0) {
			ActionTypeIconId = getResourceImageID("moviedefault");
		}

		return ActionTypeIconId;
	}

	public static int FriendIconID(String ICONID) {
		int FriendICONID = 0;

		FriendICONID = getResourceImageID("touxiang" + ICONID);

		return FriendICONID;
	}

	public static int getResourceImageID(String imageName) {
		int value = 0;
		try {
			Class<com.irsa.R.drawable> cls = R.drawable.class;
			value = cls.getDeclaredField(imageName).getInt(null);

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return 0;
		}
		return value;
	}

	/**
	 * �������汳��
	 */
	public static void putWallpaper(Context context, String wallpapername) {
		try {
			Resources res = context.getResources();
			Bitmap bitmap = BitmapFactory.decodeResource(res,
					getResourceImageID(wallpapername));
			WallpaperManager wallpaperManager = WallpaperManager
					.getInstance(context);
			wallpaperManager.setBitmap(bitmap);
		} catch (IOException e) {

		}
	}

	public static ArrayList<Facility> ParseAPISearchJson(String json) {

		ArrayList<Facility> list = new ArrayList<Facility>();
		try {
			JSONObject object = new JSONObject(json);
			JSONArray array = new JSONArray(object.getString("results"));

			for (int i = 0; i < array.length(); i++) {
				JSONObject item;

				item = array.getJSONObject(i);

				Facility facility = new Facility();
				facility.id = item.getString("id");
				facility.reference = item.getString("reference");
				JSONObject location = item.getJSONObject("geometry")
						.getJSONObject("location");
				facility.lat = location.getString("lat");
				facility.lng = location.getString("lng");
				facility.name=item.getString("name");
				facility.vicinity=item.getString("vicinity");
				list.add(facility);
			}
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}
}
