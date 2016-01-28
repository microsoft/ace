//
// An ordered collection of UIElements.
//
function UIElementCollection() {
    ace.ObservableCollection.call(this, "Windows.UI.Xaml.Controls.UIElementCollection");
};

// Inheritance
UIElementCollection.prototype = Object.create(ace.ObservableCollection.prototype);

module.exports = UIElementCollection;
