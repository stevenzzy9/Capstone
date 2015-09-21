package com.statusmanager.model;

public class MovieModel {
	private int MovieID;
	public int getMovieID() {
		return MovieID;
	}
	public void setMovieID(int movieID) {
		MovieID = movieID;
	}
	public String getMovieName() {
		return MovieName;
	}
	public void setMovieName(String movieName) {
		MovieName = movieName;
	}
	
	public String getMovieImageUrl() {
		return MovieImageUrl;
	}
	public void setMovieImageUrl(String movieImageUrl) {
		MovieImageUrl = movieImageUrl;
	}
	public String getMovieTime() {
		return MovieTime;
	}
	public void setMovieTime(String movieTime) {
		MovieTime = movieTime;
	}
	public int getHitTime() {
		return HitTime;
	}
	public void setHitTime(int hitTime) {
		HitTime = hitTime;
	}
	
	public String getLocation() {
		return Location;
	}
	public void setLocation(String location) {
		Location = location;
	}
	public String getTheaterName() {
		return TheaterName;
	}
	public void setTheaterName(String theaterName) {
		TheaterName = theaterName;
	}
	private String MovieName;
	private String MovieImageUrl;
	private String MovieTime;
	private int HitTime;
	private String Location;
	private String TheaterName;
	private String MovieType;
	public String getMovieType() {
		return MovieType;
	}
	public void setMovieType(String movieType) {
		MovieType = movieType;
	}
}
