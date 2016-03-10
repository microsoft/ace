//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// Base class for a segment of a PathFigure.
//
function PathSegment() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Media.PathSegment");
};

// Inheritance
PathSegment.prototype = Object.create(ace.NativeObject.prototype);

module.exports = PathSegment;
