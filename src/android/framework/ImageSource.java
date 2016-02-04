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
