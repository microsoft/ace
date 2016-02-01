//
// Defines row-specific properties that apply to Grid elements.
//
function RowDefinition() {
  ace.UIElement.call(this, "Windows.UI.Xaml.Controls.RowDefinition");
};

// Inheritance
RowDefinition.prototype = Object.create(ace.NativeObject.prototype);

RowDefinition.prototype.getHeight = function () { return this.get("RowDefinition.Height"); };
RowDefinition.prototype.setHeight = function (gridLength) { this.set("RowDefinition.Height", gridLength); };

module.exports = RowDefinition;
