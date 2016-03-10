//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A series of connected lines and curves.
//
function Path() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Shapes.Path");
};

// Inheritance
Path.prototype = Object.create(ace.Shape.prototype);

Path.prototype.getData = function () { return this.get("Path.Data"); };
Path.prototype.setData = function (data) { this.set("Path.Data", data); };

module.exports = Path;
