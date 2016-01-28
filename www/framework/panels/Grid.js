//
// Arranges child elements into flexible rows and columns
//
function Grid() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.Grid");
};

// Inheritance
Grid.prototype = Object.create(ace.Panel.prototype);

// Attached properties
Grid.getColumn = function (element) { return element.get("Grid.Column"); };
Grid.setColumn = function (element, value) { element.set("Grid.Column", value); };

Grid.getColumnSpan = function (element) { return element.get("Grid.ColumnSpan"); };
Grid.setColumnSpan = function (element, value) { element.set("Grid.ColumnSpan", value); };

Grid.getRow = function (element) { return element.get("Grid.Row"); };
Grid.setRow = function (element, value) { element.set("Grid.Row", value); };

Grid.getRowSpan = function (element) { return element.get("Grid.RowSpan"); };
Grid.setRowSpan = function (element, value) { element.set("Grid.RowSpan", value); };

module.exports = Grid;
