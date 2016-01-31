//
// An ordered collection of ColumnDefinitions.
//
function ColumnDefinitionCollection() {
  ace.ObservableCollection.call(this, "Windows.UI.Xaml.Controls.ColumnDefinitionCollection");
};

// Inheritance
ColumnDefinitionCollection.prototype = Object.create(ace.ObservableCollection.prototype);

module.exports = ColumnDefinitionCollection;
