package com.statusmanager.model;

public class RestrantModel {

	private int RestrantID;
	public int getRestrantID() {
		return RestrantID;
	}
	public void setRestrantID(int restrantID) {
		RestrantID = restrantID;
	}
	public String getRestrantName() {
		return RestrantName;
	}
	public void setRestrantName(String restrantName) {
		RestrantName = restrantName;
	}
	public String getRestrantType() {
		return RestrantType;
	}
	public void setRestrantType(String restrantType) {
		RestrantType = restrantType;
	}
	
	public String getLocation() {
		return Location;
	}
	public void setLocation(String location) {
		Location = location;
	}
	public String getRestrantImageUrl() {
		return RestrantImageUrl;
	}
	public void setRestrantImageUrl(String restrantImageUrl) {
		RestrantImageUrl = restrantImageUrl;
	}
	private String RestrantName;
	private String RestrantType;
	private String RestrantImageUrl;
	private String Location;
	private String LocationDescription;
	public String getLocationDescription() {
		return LocationDescription;
	}
	public void setLocationDescription(String locationDescription) {
		LocationDescription = locationDescription;
	}
}
