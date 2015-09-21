/*
 * Copyright (C) 2013 47 Degrees, LLC
 *  http://47deg.com
 *  hello@47deg.com
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

package com.statusmanager.listview;

import android.graphics.drawable.Drawable;

public class ActionItem {


	public int getActionID() {
		return ActionID;
	}

	public void setActionID(int actionID) {
		ActionID = actionID;
	}

	
	public Drawable getActionTypeIcon() {
		return ActionTypeIcon;
	}

	public void setActionTypeIcon(Drawable actionTypeIcon) {
		ActionTypeIcon = actionTypeIcon;
	}

	public String getActionname() {
		return Actionname;
	}

	public void setActionname(String actionname) {
		Actionname = actionname;
	}

	public String getActionTime() {
		return ActionTime;
	}

	public void setActionTime(String actionTime) {
		ActionTime = actionTime;
	}

	private int ActionID;

    private Drawable ActionTypeIcon;

    private String Actionname;

    private String ActionTime;
    
    private String ActionLocation;

	public String getActionLocation() {
		return ActionLocation;
	}

	public String getActionType() {
		return ActionType;
	}

	public void setActionType(String actionType) {
		ActionType = actionType;
	}

	public void setActionLocation(String actionLocation) {
		ActionLocation = actionLocation;
	}
 
	
	private String ActionType;
}
