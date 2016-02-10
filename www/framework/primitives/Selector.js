//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A control that enables selection from a collection of items.
//
function Selector(nativeTypeName) {
    if (!nativeTypeName) {
        throw new Error("You should instantiate a subclass instead");
    }
    // The caller wants an arbitrary UIElement, but with the strongly-typed members from this class
    ace.UIElement.call(this, nativeTypeName);
};

// Inheritance
Selector.prototype = Object.create(ace.ItemsControl.prototype);

module.exports = Selector;
