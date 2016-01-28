package Windows.UI.Xaml.Controls;

public interface IFireEvents {
		void addEventHandler(String eventName, Handle handle);
		void removeEventHandler(String eventName);
}
