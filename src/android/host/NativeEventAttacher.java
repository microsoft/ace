//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package run.ace;

import android.view.View;
import Windows.UI.Xaml.Controls.Handle;

class NativeEventAttacher {

	public static boolean attach(Object instance, final String methodName, final Handle handle)
	{
        // TODO: Reflect over methods via bestparameter util and discover method + delegate type
        if (methodName.equals("setOnClickListener")) {
            ((android.widget.Button)instance).setOnClickListener(new View.OnClickListener() {
                public void onClick(View v) {
                    OutgoingMessages.raiseEvent(methodName, handle, null);
                }
            });
            return true;
        }
        else if (methodName.equals("setOnRatingBarChangeListener")) {
            ((android.widget.RatingBar)instance).setOnRatingBarChangeListener(new android.widget.RatingBar.OnRatingBarChangeListener() {
                public void onRatingChanged(android.widget.RatingBar ratingBar, float rating, boolean fromUser)  {
                    OutgoingMessages.raiseEvent(methodName, handle, rating /*TODO fromUser also*/);
                }
            });
            return true;
        }
        return false;
	}

	public static boolean detach(Object instance, String methodName)
	{
        // TODO: Reflect over methods via bestparameter util and discover method + delegate type
        if (methodName.equals("setOnClickListener")) {
            ((android.widget.Button)instance).setOnClickListener(null);
            return true;
        }
        else if (methodName.equals("setOnRatingBarChangeListener")) {
            ((android.widget.RatingBar)instance).setOnRatingBarChangeListener(null);
            return true;
        }
        return false;
	}
}
