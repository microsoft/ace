//
// A selectable list of items.
//
function ListBox() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.ListBox");
};

// Inheritance
ListBox.prototype = Object.create(ace.Selector.prototype);

module.exports = ListBox;
