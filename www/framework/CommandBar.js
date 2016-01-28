//
// A specialized app bar that provides layout for AppBarButton and related command elements.
//
function CommandBar() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.CommandBar");
};

// Inheritance
CommandBar.prototype = Object.create(ace.ContentControl.prototype);

module.exports = CommandBar;
