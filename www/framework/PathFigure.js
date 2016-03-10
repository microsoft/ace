//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A portion of a geometry.
//
function PathFigure() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Media.PathFigure");
};

// Inheritance
PathFigure.prototype = Object.create(ace.NativeObject.prototype);

PathFigure.prototype.getIsClosed = function () { return this.get("PathFigure.IsClosed"); };
PathFigure.prototype.setIsClosed = function (isClosed) { this.set("PathFigure.IsClosed", isClosed); };

PathFigure.prototype.getIsFilled = function () { return this.get("PathFigure.IsFilled"); };
PathFigure.prototype.setIsFilled = function (isFilled) { this.set("PathFigure.IsFilled", isFilled); };

PathFigure.prototype.getSegments = function () { return this.get("PathFigure.Segments"); };
PathFigure.prototype.setSegments = function (segments) { this.set("PathFigure.Segments", segments); };

PathFigure.prototype.getStartPoint = function () { return this.get("PathFigure.StartPoint"); };
PathFigure.prototype.setStartPoint = function (point) { this.set("PathFigure.StartPoint", point); };

module.exports = PathFigure;
