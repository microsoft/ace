//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A button that functions as a hyperlink.
//
function HyperlinkButton() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.HyperlinkButton");
};

// Inheritance
HyperlinkButton.prototype = Object.create(ace.ButtonBase.prototype);

HyperlinkButton.prototype.getNavigateUri = function () { return this.get("HyperlinkButton.NavigateUri"); };
HyperlinkButton.prototype.setNavigateUri = function (uri) { this.set("HyperlinkButton.NavigateUri", uri); };

module.exports = HyperlinkButton;
