//
// An ordered collection of CommandBarElements.
//
function CommandBarElementCollection() {
    ace.ObservableCollection.call(this, "Windows.UI.Xaml.Controls.CommandBarElementCollection");
};

// Inheritance
CommandBarElementCollection.prototype = Object.create(ace.ObservableCollection.prototype);

module.exports = CommandBarElementCollection;
