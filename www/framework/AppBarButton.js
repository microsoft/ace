//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A button meant to be displayed in a CommandBar.
//
function AppBarButton() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.AppBarButton");
};

// Inheritance
AppBarButton.prototype = Object.create(ace.Button.prototype);

AppBarButton.prototype.getIcon = function () { return this.get("AppBarButton.Icon"); };
AppBarButton.prototype.setIcon = function (icon) { this.set("AppBarButton.Icon", icon); };

AppBarButton.prototype.getLabel = function () { return this.get("AppBarButton.Label"); };
AppBarButton.prototype.setLabel = function (label) { this.set("AppBarButton.Label", label); };

module.exports = AppBarButton;
