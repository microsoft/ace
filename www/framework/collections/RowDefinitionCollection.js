//
// An ordered collection of RowDefinitions.
//
function RowDefinitionCollection() {
  ace.ObservableCollection.call(this, "Windows.UI.Xaml.Controls.RowDefinitionCollection");
};

// Inheritance
RowDefinitionCollection.prototype = Object.create(ace.ObservableCollection.prototype);

module.exports = RowDefinitionCollection;
