//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A base class for defining geometric shapes.
//
function Geometry() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Media.Geometry");
};

// Inheritance
Geometry.prototype = Object.create(ace.NativeObject.prototype);

module.exports = Geometry;
