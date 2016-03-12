//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.app.DatePickerDialog;
import android.content.Context;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import run.ace.*;

// A control that enables a user to pick a date value
public class DatePicker extends LinearLayout
  implements IHaveProperties, IFireEvents, DatePickerDialog.OnDateSetListener {
  int _dateChangedHandlers = 0;
  Handle _dateChangedHandle;

  TextView _header;
  Button _button;
  Calendar _calendar;

  public DatePicker(final Context context) {
    super(context);

    _header = new TextView(context);
    // Apply a different style to the button:
    _button = new Button(context, null, android.R.attr.spinnerItemStyle);

    this.setOrientation(LinearLayout.HORIZONTAL);

    LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
      LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
    lp.setMargins(10,0,20,0);

    LinearLayout.LayoutParams lp2 = new LinearLayout.LayoutParams(
      LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);

    this.addView(_header, lp);
    this.addView(_button, lp2);
    
    // Default padding
    this.setPadding(19,24,0,26);

    // Show the dialog when the button is clicked
    final DatePicker instance = this;
    _button.setOnClickListener(new View.OnClickListener() {
      public void onClick(View v) {
        DatePickerDialog d = new DatePickerDialog(Frame.getTopmostActivity(), instance,
          _calendar.get(Calendar.YEAR),
          _calendar.get(Calendar.MONTH),
          _calendar.get(Calendar.DAY_OF_MONTH));
        d.show();
      }
    });

    _calendar = Calendar.getInstance();
    String dateString = DateFormat.getDateInstance().format(_calendar.getTime());
    updateDisplay(dateString);
  }

  void setDate(int year, int month, int dayOfMonth) {
    // Only take action if the date has changed
    if (_calendar.get(Calendar.YEAR) != year ||
        _calendar.get(Calendar.MONTH) != month ||
        _calendar.get(Calendar.DAY_OF_MONTH) != dayOfMonth) {
	    _calendar.set(year, month, dayOfMonth);
	    String dateString = DateFormat.getDateInstance().format(_calendar.getTime());
	    updateDisplay(dateString);
	    raiseDateChangedEvent(dateString);
		}
  }

  void updateDisplay(String dateString) {
    _button.setText(dateString);
  }

  void raiseDateChangedEvent(String dateString) {
    if (_dateChangedHandlers > 0) {
      OutgoingMessages.raiseEvent("datechanged", _dateChangedHandle, dateString);
    }
  }

  // DatePickerDialog.OnDateSetListener.onDateSet
  public void onDateSet(android.widget.DatePicker view, int year, int month, int dayOfMonth) {
    setDate(year, month, dayOfMonth);
  }

  // IHaveProperties.setProperty
  public void setProperty(String propertyName, Object propertyValue)
  {
    if (!ViewGroupHelper.setProperty(this, propertyName, propertyValue)) {
      if (propertyName.equals("DatePicker.Header")) {
        _header.setText(propertyValue.toString());
      }
      else if (propertyName.equals("DatePicker.Date")) {
        try {
          Date date = (new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss")).parse(propertyValue.toString());
          Calendar calendar = Calendar.getInstance();
					calendar.setTime(date);
          setDate(calendar.get(Calendar.YEAR),
            calendar.get(Calendar.MONTH),
            calendar.get(Calendar.DAY_OF_MONTH));
        }
        catch (ParseException ex) {
          throw new RuntimeException("Cannot parse date " + propertyValue + ": " + ex.toString());
        }
      }
      else {
          // Try to set the property on the button and header
          Boolean setHeader = TextViewHelper.setProperty(_header, propertyName, propertyValue);
          Boolean setButton = TextViewHelper.setProperty(_button, propertyName, propertyValue);
          if (!setHeader && !setButton) {
            throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
          }
      }
    }
  }

  // IFireEvents.addEventHandler
  public void addEventHandler(String eventName, Handle handle) {
    if (eventName.equals("datechanged")) {
      if (_dateChangedHandlers == 0) {
        _dateChangedHandle = handle;
      }
      _dateChangedHandlers++;
    }
  }

  // IFireEvents.removeEventHandler
  public void removeEventHandler(String eventName) {
    if (eventName.equals("datechanged")) {
      _dateChangedHandlers--;
    }
  }
}
