package com.statusmanager.model;

public class UserLocation {
	private int userid;
	public int getUserid() {
		return userid;
	}
	public void setUserid(int userid) {
		this.userid = userid;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public int getLocationtype() {
		return locationtype;
	}
	public void setLocationtype(int locationtype) {
		this.locationtype = locationtype;
	}
	private String location;
	private int locationtype;
}
