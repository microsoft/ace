package Windows.UI.Xaml.Controls;

public class ColumnDefinition implements IHaveProperties {
    public GridLength Width;
    public double CalculatedWidth;
    public double CalculatedLeft;

	// IHaveProperties.setProperty
	public void setProperty(String propertyName, Object propertyValue) {
        if (propertyName.equals("ColumnDefinition.Width")) {
            if (propertyValue instanceof GridLength)
                this.Width = (GridLength)propertyValue;
            else
                this.Width = GridLengthConverter.parse((String)propertyValue);
        }
        else {
            throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
        }
	}
}
