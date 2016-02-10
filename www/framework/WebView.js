//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A control that hosts HTML.
//
function WebView() {
    ace.UIElement.call(this, ace.valueOn({ android: "Windows.UI.Xaml.Controls.WebView", ios: "AceWebView" }));
};

// Inheritance
WebView.prototype = Object.create(ace.UIElement.prototype);

WebView.prototype.getSource = function () { return this.get("WebView.Source"); };
WebView.prototype.setSource = function (url) { this.set("WebView.Source", url); };

module.exports = WebView;
