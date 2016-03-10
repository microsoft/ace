//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A base class for shapes.
//
function Shape() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Shapes.Shape");
};

// Inheritance
Shape.prototype = Object.create(ace.UIElement.prototype);

Shape.prototype.getFill = function () { return this.get("Shape.Fill"); };
Shape.prototype.setFill = function (fill) { this.set("Shape.Fill", fill); };

Shape.prototype.getStretch = function () { return this.get("Shape.Stretch"); };
Shape.prototype.setStretch = function (stretch) { this.set("Shape.Stretch", stretch); };

Shape.prototype.getStroke = function () { return this.get("Shape.Stroke"); };
Shape.prototype.setStroke = function (stroke) { this.set("Shape.Stroke", stroke); };

Shape.prototype.getStrokeEndLineCap = function () { return this.get("Shape.StrokeEndLineCap"); };
Shape.prototype.setStrokeEndLineCap = function (cap) { this.set("Shape.StrokeEndLineCap", cap); };

Shape.prototype.getStrokeLineJoin = function () { return this.get("Shape.StrokeLineJoin"); };
Shape.prototype.setStrokeLineJoin = function (join) { this.set("Shape.StrokeLineJoin", join); };

Shape.prototype.getStrokeMiterLimit = function () { return this.get("Shape.StrokeMiterLimit"); };
Shape.prototype.setStrokeMiterLimit = function (limit) { this.set("Shape.StrokeMiterLimit", limit); };

Shape.prototype.getStrokeStartLineCap = function () { return this.get("Shape.StrokeStartLineCap"); };
Shape.prototype.setStrokeStartLineCap = function (cap) { this.set("Shape.StrokeStartLineCap", cap); };

Shape.prototype.getStrokeThickness = function () { return this.get("Shape.StrokeThickness"); };
Shape.prototype.setStrokeThickness = function (thickness) { this.set("Shape.StrokeThickness", thickness); };

module.exports = Shape;
