//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// The base class for UI elements that can use a control template.
//
function Control(nativeTypeName) {
    if (!nativeTypeName) {
        throw new Error("You should instantiate a subclass instead");
    }
    // The caller wants an arbitrary UIElement, but with the strongly-typed members from this class
    ace.UIElement.call(this, nativeTypeName);
};

// Inheritance
Control.prototype = Object.create(ace.UIElement.prototype);

Control.prototype.getBackground = function () { return this.get("Control.Background"); };
Control.prototype.setBackground = function (brush) { this.set("Control.Background", brush); };

Control.prototype.getFontSize = function () { return this.get("Control.FontSize"); };
Control.prototype.setFontSize = function (size) { this.set("Control.FontSize", size); };

Control.prototype.getFontWeight = function () { return this.get("Control.FontWeight"); };
Control.prototype.setFontWeight = function (weight) { this.set("Control.FontWeight", weight); };

Control.prototype.getForeground = function () { return this.get("Control.Foreground"); };
Control.prototype.setForeground = function (brush) { this.set("Control.Foreground", brush); };

Control.prototype.getHorizontalContentAlignment = function () { return this.get("Control.HorizontalContentAlignment"); };
Control.prototype.setHorizontalContentAlignment = function (alignment) { this.set("Control.HorizontalContentAlignment", alignment); };

Control.prototype.getPadding = function () { return this.get("Control.Padding"); };
Control.prototype.setPadding = function (thickness) { this.set("Control.Padding", thickness); };

Control.prototype.getVerticalContentAlignment = function () { return this.get("Control.VerticalContentAlignment"); };
Control.prototype.setVerticalContentAlignment = function (alignment) { this.set("Control.VerticalContentAlignment", alignment); };

module.exports = Control;
