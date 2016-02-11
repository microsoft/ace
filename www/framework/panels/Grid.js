//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

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

// Regular properties
Grid.prototype.getColumnDefinitions = function () {
    // Give an empty collection by default rather than null
    var definitions = this.get("Grid.ColumnDefinitions");
    if (!definitions) {
        definitions = new ace.ColumnDefinitionCollection();
        this.setColumnDefinitions(definitions);
    }
    return definitions;
};
Grid.prototype.setColumnDefinitions = function (collection) { this.set("Grid.ColumnDefinitions", collection); };

Grid.prototype.getPadding = function () { return this.get("Grid.Padding"); };
Grid.prototype.setPadding = function (thickness) { this.set("Grid.Padding", thickness); };

Grid.prototype.getRowDefinitions = function () {
    // Give an empty collection by default rather than null
    var definitions = this.get("Grid.RowDefinitions");
    if (!definitions) {
        definitions = new ace.RowDefinitionCollection();
        this.setRowDefinitions(definitions);
    }
    return definitions;
};
Grid.prototype.setRowDefinitions = function (collection) { this.set("Grid.RowDefinitions", collection); };

module.exports = Grid;
