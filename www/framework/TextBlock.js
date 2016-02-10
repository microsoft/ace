//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A lightweight element for displaying small amounts of text.
//
function TextBlock() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.TextBlock");
};

// Inheritance
TextBlock.prototype = Object.create(ace.UIElement.prototype);

TextBlock.prototype.getFontSize = function () { return this.get("TextBlock.FontSize"); };
TextBlock.prototype.setFontSize = function (size) { this.set("TextBlock.FontSize", size); };

TextBlock.prototype.getFontWeight = function () { return this.get("TextBlock.FontWeight"); };
TextBlock.prototype.setFontWeight = function (weight) { this.set("TextBlock.FontWeight", weight); };

TextBlock.prototype.getForeground = function () { return this.get("TextBlock.Foreground"); };
TextBlock.prototype.setForeground = function (brush) { this.set("TextBlock.Foreground", brush); };

TextBlock.prototype.getPadding = function () { return this.get("TextBlock.Padding"); };
TextBlock.prototype.setPadding = function (thickness) { this.set("TextBlock.Padding", thickness); };

TextBlock.prototype.getText = function () { return this.get("TextBlock.Text"); };
TextBlock.prototype.setText = function (text) { this.set("TextBlock.Text", text); };

module.exports = TextBlock;
