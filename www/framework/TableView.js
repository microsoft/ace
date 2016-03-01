//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A selectable list of items with support for hierarchies.
//
function TableView() {
    ace.UIElement.call(this, "run.ace.TableView");
};

// Inheritance
TableView.prototype = Object.create(ace.ListBox.prototype);

module.exports = TableView;
