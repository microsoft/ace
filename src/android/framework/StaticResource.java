package Windows.UI.Xaml;

public class StaticResource implements Windows.UI.Xaml.Controls.IHaveProperties {
	public StaticResource(android.content.Context context) {
	}

	// IHaveProperties.setProperty
	public void setProperty(String propertyName, Object propertyValue)
	{
        if (propertyName.equals("StaticResource.ResourceKey")) {
            // Ignore. This is handled on the managed side.
        }
        else {
            throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
        }
	}
}
