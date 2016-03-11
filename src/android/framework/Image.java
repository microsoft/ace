package Windows.UI.Xaml.Controls;

import android.content.Context;
import android.graphics.Bitmap;
import android.os.AsyncTask;
import android.view.View;
import run.ace.*;

//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
public class Image extends android.widget.ImageView implements IHaveProperties {
	public Image(Context context) {
		super(context);
	}

	// IHaveProperties.setProperty
	public void setProperty(String propertyName, Object propertyValue)
	{
		if (!ViewHelper.setProperty(this, propertyName, propertyValue, true)) {
			if (propertyName.endsWith(".Source")) {
				if (propertyValue instanceof String) {
                    setSource((String)propertyValue);
				}
				else if (propertyValue instanceof ImageSource) {
                    setSource(((ImageSource)propertyValue).getUriSource());
				}
				else if (propertyValue == null) {
                    this.setImageBitmap(null);
				}
				else {
                    throw new RuntimeException("Invalid type for Image.Source: " + propertyValue.getClass().getSimpleName());
				}
			}
			else {
                throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
			}
		}
	}
    
    void setSource(String url) {
        if (url.contains("://")) {
            new BackgroundTask().execute(url);
        }
        else {
            this.setImageBitmap(Utils.getBitmapAsset(getContext(), url));
        }
    }

    // Fetch the image on a background thread, which is necessary for network-based images
    private class BackgroundTask extends AsyncTask<String, Void, Bitmap> {
        @Override
        protected Bitmap doInBackground(String... params) {
            // On the backround thread
            return Utils.getBitmapHttp(getContext(), params[0]);
        }

        @Override
        protected void onPostExecute(Bitmap result) {
            // On the UI thread
            Image.this.setImageBitmap(result);
        }
    }
}
