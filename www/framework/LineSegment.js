//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A line between two points.
//
function LineSegment() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Media.LineSegment");
};

// Inheritance
LineSegment.prototype = Object.create(ace.PathSegment.prototype);

// The end point of the line segment
LineSegment.prototype.getPoint = function () { return this.get("LineSegment.Point"); };
LineSegment.prototype.setPoint = function (point) { this.set("LineSegment.Point", point); };

module.exports = LineSegment;
