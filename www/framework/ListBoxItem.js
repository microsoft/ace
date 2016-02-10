//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A container for an item in a ListBox.
//
function ListBoxItem() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.ListBoxItem");
};

// Inheritance
ListBoxItem.prototype = Object.create(ace.SelectorItem.prototype);

module.exports = ListBoxItem;
