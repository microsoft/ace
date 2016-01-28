package Windows.UI.Xaml.Controls;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import run.ace.*;

public class ToggleSwitch extends android.widget.Switch implements IHaveProperties, IFireEvents {
    int _isOnChangedHandlers = 0;

	public ToggleSwitch(Context context) {
		super(context);
	}

	// IHaveProperties.setProperty
	public void setProperty(String propertyName, Object propertyValue)
	{
		if (!TextViewHelper.setProperty(this, propertyName, propertyValue)) {
			if (propertyName.equals("ToggleSwitch.IsOn")) {
				this.setChecked((Boolean)propertyValue);	
			}
			else {
				throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
			}
		}
	}

	// IFireEvents.addEventHandler
	public void addEventHandler(final String eventName, final Handle handle) {
		if (eventName.equals("isonchanged")) {
			if (_isOnChangedHandlers == 0) {
				// Set up the message sending, which goes to all handlers
                this.setOnCheckedChangeListener(new android.widget.CompoundButton.OnCheckedChangeListener() {
                    public void onCheckedChanged(android.widget.CompoundButton buttonView, boolean isChecked) {
						OutgoingMessages.raiseEvent(eventName, handle, isChecked);
                    }
                });
			}
			_isOnChangedHandlers++;
		}
	}

	// IFireEvents.removeEventHandler
	public void removeEventHandler(String eventName) {
		if (eventName.equals("isonchanged")) {
			_isOnChangedHandlers--;
			if (_isOnChangedHandlers == 0) {
				// Stop sending messages because nobody is listening
				this.setOnCheckedChangeListener(null);
			}
		}
	}
}
