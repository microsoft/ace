//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A general purpose container for hosting UIElements on top of other content, such as HTML.
//
function Popup() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.Primitives.Popup");
    this._isVisible = false;
};

// Inheritance
Popup.prototype = Object.create(ace.ContentControl.prototype);

Popup.closeAll = function () {
    ace.NativeObject.invoke("Windows.UI.Xaml.Controls.Primitives.Popup", "CloseAll");
};

Popup.prototype.isVisible = function () { return this._isVisible; };

Popup.prototype.show = function () {
    this.invoke("Show");
    this._isVisible = true;
};

Popup.prototype.hide = function () {
    this.invoke("Hide");
    this._isVisible = false;
};

Popup.prototype.maximize = function () { this.invoke("Maximize"); };
Popup.prototype.setPosition = function (x, y) { this.invoke(ace.valueOn({ android: "SetPosition", ios: "SetX:andY:" }), x, y, doNotQueue); };
Popup.prototype.setRect = function (rect) { this.invoke(ace.valueOn({ android: "SetRect", ios: "SetX:andY:width:height:" }), rect.x, rect.y, rect.width, rect.height, doNotQueue); };

// Passing a callback as the last parameter to invoke forces it to be done now
doNotQueue = function () { };

module.exports = Popup;
