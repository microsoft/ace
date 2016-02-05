//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.content.Context;

public class ImageSource {
    String _uriSource;

    public ImageSource(Context context) {
    }

    public String getUriSource() {
        return _uriSource;
    }

    public void setUriSource(String value) {
        _uriSource = value;
    }
}
