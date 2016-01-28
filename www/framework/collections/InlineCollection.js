//
// An ordered collection of Inlines.
//
function InlineCollection() {
    ace.ObservableCollection.call(this, "Windows.UI.Xaml.Documents.InlineCollection");
};

// Inheritance
InlineCollection.prototype = Object.create(ace.ObservableCollection.prototype);

module.exports = InlineCollection;
