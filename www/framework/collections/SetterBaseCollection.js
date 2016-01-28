//
// An ordered collection of Setters (whose base class is SetterBase).
//
function SetterBaseCollection() {
    ace.ObservableCollection.call(this, "Windows.UI.Xaml.SetterBaseCollection");
};

// Inheritance
SetterBaseCollection.prototype = Object.create(ace.ObservableCollection.prototype);

module.exports = SetterBaseCollection;
