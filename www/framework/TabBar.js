//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A specialized app bar that renders its command elements as tabs.
// <ace:TabBar> in XAML.
//
function TabBar() {
    ace.UIElement.call(this, "run.ace.TabBar");
};

// Inheritance
TabBar.prototype = Object.create(ace.CommandBar.prototype);

// Helpers for navigation bar colors
TabBar.prototype.getTintColor = function () { return this.get("TabBar.TintColor"); };
TabBar.prototype.setTintColor = function (brush) { this.set("TabBar.TintColor", brush); };

TabBar.prototype.getBarTintColor = function () { return this.get("TabBar.BarTintColor"); };
TabBar.prototype.setBarTintColor = function (brush) { this.set("TabBar.BarTintColor", brush); };

module.exports = TabBar;
