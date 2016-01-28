package Windows.UI.Xaml.Controls;

import org.json.JSONException;
import org.json.JSONObject;

public class Thickness {

	public double left;
	public double top;
	public double right;
	public double bottom;

	public Thickness(double left, double top, double right, double bottom) {
        this.left = left;
        this.top = top;
        this.right = right;
        this.bottom = bottom;
	}

	public static Thickness deserialize(JSONObject obj) {
		try {
			double left = obj.getDouble("left");
			double top = obj.getDouble("top");
			double right = obj.getDouble("right");
			double bottom = obj.getDouble("bottom");
			return new Thickness(left, top, right, bottom);
		}
		catch (JSONException ex) {
			throw new RuntimeException(ex);
		}
	}
}
