//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// Enables positioning child elements with coordinates.
//
function Canvas() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.Canvas");
};

// Inheritance
Canvas.prototype = Object.create(ace.Panel.prototype);

// Attached properties
Canvas.getLeft = function (element) { return element.get("Canvas.Left"); };
Canvas.setLeft = function (element, value) { element.set("Canvas.Left", value); };

Canvas.getTop = function (element) { return element.get("Canvas.Top"); };
Canvas.setTop = function (element, value) { element.set("Canvas.Top", value); };

module.exports = Canvas;
