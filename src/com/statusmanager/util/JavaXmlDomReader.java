package com.statusmanager.util;

import java.io.File;
import java.io.InputStream;
import java.util.ArrayList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import android.content.Context;

import com.statusmanager.model.KeyWord;
import com.statusmanager.model.MovieModel;
import com.statusmanager.model.RestrantModel;
import com.statusmanager.model.UserLocation;



public class JavaXmlDomReader {
	InputStream inputStream=null;

	public String getIndoorMapPrefix()
	{
		String prefix="";
		try {
			File f=new File("src/com/irsa/util/BuildingInfo.xml");
			DocumentBuilderFactory factory=DocumentBuilderFactory.newInstance();
			DocumentBuilder builder=factory.newDocumentBuilder();
			Document doc=builder.parse(f);
			NodeList nl=doc.getElementsByTagName("Building");
			prefix= doc.getElementsByTagName("BuildingTilePrifex")
					.item(0).getFirstChild().getNodeValue();
			
				
		} catch (Exception e) {
			// TODO Auto-generated catch block
			
			e.printStackTrace();
		}
		return prefix;		
	}
	
	public ArrayList<RestrantModel> getRestrantList(Context context)
	{
		
		ArrayList<RestrantModel> RestrantList=new ArrayList<RestrantModel>();
		try {
			inputStream=context.getResources().getAssets().open("Restaurant.xml");
			
			
			DocumentBuilderFactory factory=DocumentBuilderFactory.newInstance();
			DocumentBuilder builder=factory.newDocumentBuilder();
			
			Document doc=builder.parse(PubContant.WEBSERVERRESTRANT);
			if(doc==null)
			{
				doc=builder.parse(inputStream);
			}
			
			NodeList nl=doc.getElementsByTagName("Restaurant");
		
			for(int i=0;i<nl.getLength();i++)
			{
				RestrantModel restrant=new RestrantModel();
				restrant.setRestrantID(Integer.parseInt(doc.getElementsByTagName("RestaurantID")
						.item(i).getFirstChild().getNodeValue()));
				restrant.setRestrantImageUrl(doc.getElementsByTagName("RestaurantImage")
						.item(i).getFirstChild().getNodeValue());
				restrant.setRestrantType(doc.getElementsByTagName("RestaurantType")
						.item(i).getFirstChild().getNodeValue());
				restrant.setRestrantName(doc.getElementsByTagName("RestaurantName")
						.item(i).getFirstChild().getNodeValue());
 
				
				restrant.setLocation(doc.getElementsByTagName("Location")
						.item(i).getFirstChild().getNodeValue());
				
				RestrantList.add(restrant);
			}
			
			
				
		} catch (Exception e) {
			// TODO Auto-generated catch block
		
			e.printStackTrace();
		}
		return RestrantList;
	}
	public ArrayList<MovieModel> getMovieList(Context context)
	{
		ArrayList<MovieModel> MovieList=new ArrayList<MovieModel>();
		try {
			inputStream=context.getResources().getAssets().open("Movie.xml");
			DocumentBuilderFactory factory=DocumentBuilderFactory.newInstance();
			DocumentBuilder builder=factory.newDocumentBuilder();
			
			Document doc=null;
			try {
				doc = builder.parse(PubContant.WEBSERVERMOVIE);
			} catch (Exception e) {
				System.out.println("Fasdf");
			}
			if(doc==null)
			{
				doc=builder.parse(inputStream);
			}
			NodeList nl=doc.getElementsByTagName("Movie");
		
			for(int i=0;i<nl.getLength();i++)
			{
				MovieModel Movie=new MovieModel();
				Movie.setMovieID(Integer.parseInt(doc.getElementsByTagName("MovieID")
						.item(i).getFirstChild().getNodeValue()));
				Movie.setMovieImageUrl(doc.getElementsByTagName("MovieImageUrl")
						.item(i).getFirstChild().getNodeValue());
				Movie.setHitTime(Integer.parseInt(doc.getElementsByTagName("HitTime")
						.item(i).getFirstChild().getNodeValue()));
				Movie.setMovieName(doc.getElementsByTagName("MovieName")
						.item(i).getFirstChild().getNodeValue());
			
				Movie.setMovieTime(doc.getElementsByTagName("MovieTime")
						.item(i).getFirstChild().getNodeValue());
				
				Movie.setLocation(doc.getElementsByTagName("Location")
						.item(i).getFirstChild().getNodeValue());
				Movie.setMovieType(doc.getElementsByTagName("MovieType")
						.item(i).getFirstChild().getNodeValue());
				MovieList.add(Movie);
			}
			
			
				
		} catch (Exception e) {
			// TODO Auto-generated catch block
		
			e.printStackTrace();
		}
		return MovieList;
	}
	public ArrayList<KeyWord> getKeyWordList(Context context)
	{
		
		ArrayList<KeyWord> KeyWordList=new ArrayList<KeyWord>();
		try {
			inputStream=context.getResources().getAssets().open("Keyword.xml");
			
			
			DocumentBuilderFactory factory=DocumentBuilderFactory.newInstance();
			DocumentBuilder builder=factory.newDocumentBuilder();
			
			Document doc=builder.parse(PubContant.WEBSERVERKEYWORD);
			if(doc==null)
			{
				doc=builder.parse(inputStream);
			}
			
			NodeList nl=doc.getElementsByTagName("KeyWordModel");
		
			for(int i=0;i<nl.getLength();i++)
			{
				KeyWord keyword=new KeyWord();
				keyword.setMeetingID(Integer.parseInt(doc.getElementsByTagName("MeetingID")
						.item(i).getFirstChild().getNodeValue()));
				keyword.setKeyWord(doc.getElementsByTagName("KeyWord")
						.item(i).getFirstChild().getNodeValue());
				
				
				KeyWordList.add(keyword);
			}
			
			
				
		} catch (Exception e) {
			// TODO Auto-generated catch block
		
			e.printStackTrace();
		}
		return KeyWordList;
	}
	
	
	
	
	public ArrayList<UserLocation> getUserLocationList(Context context)
	{
		
		ArrayList<UserLocation> UserLocationList=new ArrayList<UserLocation>();
		try {
			inputStream=context.getResources().getAssets().open("UserLocation.xml");
			
			
			DocumentBuilderFactory factory=DocumentBuilderFactory.newInstance();
			DocumentBuilder builder=factory.newDocumentBuilder();
			
			Document doc=builder.parse(PubContant.WEBSERVERUSERLOCATION);
			if(doc==null)
			{
				doc=builder.parse(inputStream);
			}
			
			NodeList nl=doc.getElementsByTagName("Location");
		
			for(int i=0;i<nl.getLength();i++)
			{
				UserLocation userLocation=new UserLocation();
				userLocation.setUserid(Integer.parseInt(doc.getElementsByTagName("userid")
						.item(i).getFirstChild().getNodeValue()));
				userLocation.setLocation(doc.getElementsByTagName("location")
						.item(i).getFirstChild().getNodeValue());
				userLocation.setLocationtype(Integer.parseInt(doc.getElementsByTagName("locationtype")
						.item(i).getFirstChild().getNodeValue()));
				
				
				UserLocationList.add(userLocation);
			}
			
			
				
		} catch (Exception e) {
			// TODO Auto-generated catch block
		
			e.printStackTrace();
		}
		return UserLocationList;
	}
	
}
