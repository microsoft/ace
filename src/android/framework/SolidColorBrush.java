package Windows.UI.Xaml.Controls;

public class SolidColorBrush extends Brush {
	public int Color;

	public SolidColorBrush(android.content.Context context) {
		super(context);
	}

	public SolidColorBrush(int color) {
		super(null);
		Color = color;
	}
}
