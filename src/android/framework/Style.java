package Windows.UI.Xaml;

public class Style implements Windows.UI.Xaml.Controls.IHaveProperties {
	public Style(android.content.Context context) {
	}

	// IHaveProperties.setProperty
	public void setProperty(String propertyName, Object propertyValue)
	{
        if (propertyName.equals("Style.TargetType") || propertyName.equals("Style.Setters")) {
            // Ignore. These are handled on the managed side.
        }
        else {
            throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
        }
	}
}
