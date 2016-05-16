//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// The root of content hosted in a Frame.
//
function Page() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.Page");
};

// Inheritance
Page.prototype = Object.create(ace.UserControl.prototype);

Page.prototype.getBottomAppBar = function () { return this.get("Page.BottomAppBar"); };
Page.prototype.setBottomAppBar = function (commandBar) { this.set("Page.BottomAppBar", commandBar); };

Page.prototype.getTopAppBar = function () { return this.get("Page.TopAppBar"); };
Page.prototype.setTopAppBar = function (commandBar) { this.set("Page.TopAppBar", commandBar); };

// The same as get/set BottomAppBar, but with a better name:
Page.prototype.getCommandBar = function () { return this.get("Page.BottomAppBar"); };
Page.prototype.setCommandBar = function (commandBar) { this.set("Page.BottomAppBar", commandBar); };

// Helpers for Frame APIs
Page.prototype.getTitle = function () { return this.get("Frame.Title"); };
Page.prototype.setTitle = function (title) { this.set("Frame.Title", title); };

// Helpers for navigation bar colors
Page.prototype.getTintColor = function () { return this.get("Page.TintColor"); };
Page.prototype.setTintColor = function (brush) { this.set("Page.TintColor", brush); };

Page.prototype.getBarTintColor = function () { return this.get("Page.BarTintColor"); };
Page.prototype.setBarTintColor = function (brush) { this.set("Page.BarTintColor", brush); };

module.exports = Page;
