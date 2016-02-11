//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// Arranges child elements into a single line that can be oriented horizontally or vertically.
//
function StackPanel() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.StackPanel");
};

// Inheritance
StackPanel.prototype = Object.create(ace.Panel.prototype);

StackPanel.prototype.getOrientation = function () { return this.get("StackPanel.Orientation"); };
StackPanel.prototype.setOrientation = function (orientation) { this.set("StackPanel.Orientation", orientation); };

StackPanel.prototype.getPadding = function () { return this.get("StackPanel.Padding"); };
StackPanel.prototype.setPadding = function (thickness) { this.set("StackPanel.Padding", thickness); };

module.exports = StackPanel;
