//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A selectable list of items.
//
function ListBox() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.ListBox");
};

// Inheritance
ListBox.prototype = Object.create(ace.Selector.prototype);

module.exports = ListBox;
