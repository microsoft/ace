package Windows.UI.Xaml.Controls;

public interface IRecieveCollectionChanges {
	void add(Object collection, Object item);
	void removeAt(Object collection, int index);
}
