//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A specialized app bar that provides layout for AppBarButton and related command elements.
//
function CommandBar() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.CommandBar");
};

// Inheritance
CommandBar.prototype = Object.create(ace.ContentControl.prototype);

CommandBar.prototype.getPrimaryCommands = function () {
    // Give an empty collection by default rather than null
    var items = this.get("CommandBar.PrimaryCommands");
    if (!items) {
        items = new ace.CommandBarElementCollection();
        this.setPrimaryCommands(items);
    }
    return items;
};
CommandBar.prototype.setPrimaryCommands = function (items) { this.set("CommandBar.PrimaryCommands", items); };

CommandBar.prototype.getSecondaryCommands = function () {
    // Give an empty collection by default rather than null
    var items = this.get("CommandBar.SecondaryCommands");
    if (!items) {
        items = new ace.CommandBarElementCollection();
        this.setSecondaryCommands(items);
    }
    return items;
};
CommandBar.prototype.setSecondaryCommands = function (items) { this.set("CommandBar.SecondaryCommands", items); };

module.exports = CommandBar;
