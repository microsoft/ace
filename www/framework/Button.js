//
// A button that can respond to clicks.
//
function Button() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.Button");
};

// Inheritance
Button.prototype = Object.create(ace.ButtonBase.prototype);

module.exports = Button;
