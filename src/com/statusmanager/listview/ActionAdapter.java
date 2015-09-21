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

import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import com.irsa.R;


public class ActionAdapter extends BaseAdapter {

    private List<ActionItem> data;
    private Context context;

    public ActionAdapter(Context context, List<ActionItem> data) {
        this.context = context;
        this.data = data;
    }

    @Override
    public int getCount() {
        return data.size();
    }

    @Override
    public ActionItem getItem(int position) {
        return data.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }



    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final ActionItem item = getItem(position);
        ViewHolder holder;
        if (convertView == null) {
            LayoutInflater li = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = li.inflate(R.layout.actionitem, parent, false);
            holder = new ViewHolder();
            holder.ivImage = (ImageView) convertView.findViewById(R.id.example_row_iv_image);
            holder.ActionName = (TextView) convertView.findViewById(R.id.example_row_tv_title);
            holder.ActionTime = (TextView) convertView.findViewById(R.id.example_row_tv_description);
            holder.ActionLocation= (TextView) convertView.findViewById(R.id.example_row_location_description);
            holder.ActionType= (TextView) convertView.findViewById(R.id.example_row_tv_type);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }

      
        holder.ivImage.setImageDrawable(item.getActionTypeIcon());
        holder.ActionName.setText(item.getActionname());
        holder.ActionTime.setText(item.getActionTime());
        holder.ActionLocation.setText(item.getActionLocation());
        holder.ActionType.setText(item.getActionType());
        return convertView;
    }

    static class ViewHolder {
        ImageView ivImage;
        TextView ActionName;
        TextView ActionTime;
        TextView ActionLocation;
        TextView ActionType;
    }

  

}
