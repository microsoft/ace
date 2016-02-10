//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A control that presents a collection of items.
//
function ItemsControl(nativeTypeName) {
    if (!nativeTypeName) {
        throw new Error("You should instantiate a subclass instead");
    }
    // The caller wants an arbitrary UIElement, but with the strongly-typed members from this class
    ace.UIElement.call(this, nativeTypeName);
};

// Inheritance
ItemsControl.prototype = Object.create(ace.Control.prototype);

ItemsControl.prototype.getItems = function () {
    // Give an empty collection by default rather than null
    var items = this.get("ItemsControl.Items");
    if (!items) {
        items = new ace.ItemCollection();
        this.setItems(items);
    }
    return items;
};
ItemsControl.prototype.setItems = function (items) { this.set("ItemsControl.Items", items); };

module.exports = ItemsControl;
