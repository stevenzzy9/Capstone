package com.statusmanager.model;

public class UserModel {
	private int userid;
	public int getUserid() {
		return userid;
	}
	public void setUserid(int userid) {
		this.userid = userid;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getUserpassword() {
		return userpassword;
	}
	public void setUserpassword(String userpassword) {
		this.userpassword = userpassword;
	}
	public String getGoogleusername() {
		return googleusername;
	}
	public void setGoogleusername(String googleusername) {
		this.googleusername = googleusername;
	}
	public String getGoogleuserpassword() {
		return googleuserpassword;
	}
	public void setGoogleuserpassword(String googleuserpassword) {
		this.googleuserpassword = googleuserpassword;
	}
	private String username;
	private String userpassword;
	private String googleusername;
	private String googleuserpassword;
	private String googlehomeusername;
	private String googlehomeuserpassword;
	public String getGooglehomeusername() {
		return googlehomeusername;
	}
	public void setGooglehomeusername(String googlehomeusername) {
		this.googlehomeusername = googlehomeusername;
	}
	public String getGooglehomeuserpassword() {
		return googlehomeuserpassword;
	}
	public void setGooglehomeuserpassword(String googlehomeuserpassword) {
		this.googlehomeuserpassword = googlehomeuserpassword;
	}
}
