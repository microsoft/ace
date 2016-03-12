//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.app.TimePickerDialog;
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

// A control that enables a user to pick a time value
public class TimePicker extends LinearLayout
  implements IHaveProperties, IFireEvents, TimePickerDialog.OnTimeSetListener {
  int _timeChangedHandlers = 0;
  Handle _timeChangedHandle;

  TextView _header;
  Button _button;
  Calendar _calendar;

  public TimePicker(final Context context) {
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
    final TimePicker instance = this;
    _button.setOnClickListener(new View.OnClickListener() {
      public void onClick(View v) {
        TimePickerDialog d = new TimePickerDialog(Frame.getTopmostActivity(), instance,
          _calendar.get(Calendar.HOUR_OF_DAY),
          _calendar.get(Calendar.MINUTE),
          false);
        d.show();
      }
    });

    _calendar = Calendar.getInstance();

    // We don't want any seconds in the Time object
    _calendar.set(Calendar.SECOND, 0);

    String timeString = DateFormat.getTimeInstance(DateFormat.SHORT).format(_calendar.getTime());
    updateDisplay(timeString);
  }

  void setTime(int hourOfDay, int minute) {
    // Only take action if the time has changed
    if (_calendar.get(Calendar.HOUR_OF_DAY) != hourOfDay ||
        _calendar.get(Calendar.MINUTE) != minute) {
        _calendar.set(Calendar.HOUR_OF_DAY, hourOfDay);
        _calendar.set(Calendar.MINUTE, minute);
	    String timeString = DateFormat.getTimeInstance(DateFormat.SHORT).format(_calendar.getTime());
	    updateDisplay(timeString);
	    raiseTimeChangedEvent(_calendar.getTimeInMillis());
    }
  }

  void updateDisplay(String timeString) {
    _button.setText(timeString);
  }

  void raiseTimeChangedEvent(long timeMilliseconds) {
    if (_timeChangedHandlers > 0) {
      OutgoingMessages.raiseEvent("timechanged", _timeChangedHandle, timeMilliseconds);
    }
  }

  // TimePickerDialog.OnTimeSetListener.onTimeSet
  public void onTimeSet(android.widget.TimePicker view, int hourOfDay, int minute) {
    setTime(hourOfDay, minute);
  }

  // IHaveProperties.setProperty
  public void setProperty(String propertyName, Object propertyValue)
  {
    if (!ViewGroupHelper.setProperty(this, propertyName, propertyValue)) {
      if (propertyName.equals("TimePicker.Header")) {
        _header.setText(propertyValue.toString());
      }
      else if (propertyName.equals("TimePicker.Time")) {
        try {
          Date t = (new SimpleDateFormat("HH:mm:ss")).parse(propertyValue.toString());
          Calendar calendar = Calendar.getInstance();
          calendar.setTime(t);
          setTime(calendar.get(Calendar.HOUR_OF_DAY),
            calendar.get(Calendar.MINUTE));
        }
        catch (ParseException ex) {
          throw new RuntimeException("Cannot parse time " + propertyValue + ": " + ex.toString());
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
    if (eventName.equals("timechanged")) {
      if (_timeChangedHandlers == 0) {
        _timeChangedHandle = handle;
      }
      _timeChangedHandlers++;
    }
  }

  // IFireEvents.removeEventHandler
  public void removeEventHandler(String eventName) {
    if (eventName.equals("timechanged")) {
      _timeChangedHandlers--;
    }
  }
}
