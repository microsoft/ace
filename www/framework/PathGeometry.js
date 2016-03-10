//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A shape that may be composed of arcs, curves, ellipses, lines, and rectangles.
//
function PathGeometry() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Shapes.PathGeometry");
};

// Inheritance
PathGeometry.prototype = Object.create(ace.Geometry.prototype);

PathGeometry.prototype.getFigures = function () { return this.get("PathGeometry.Figures"); };
PathGeometry.prototype.setFigures = function (figures) { this.set("PathGeometry.Figures", figures); };

PathGeometry.prototype.getFillRule = function () { return this.get("PathGeometry.FillRule"); };
PathGeometry.prototype.setFillRule = function (fillRule) { this.set("PathGeometry.FillRule", fillRule); };

module.exports = PathGeometry;
