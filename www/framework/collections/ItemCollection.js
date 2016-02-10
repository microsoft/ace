//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// An ordered collection of items in an ItemsControl.
//
function ItemCollection() {
    ace.ObservableCollection.call(this, "Windows.UI.Xaml.Controls.ItemCollection");
};

// Inheritance
ItemCollection.prototype = Object.create(ace.ObservableCollection.prototype);

module.exports = ItemCollection;
