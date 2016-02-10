//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A control with a single piece of content. A base class for more interesting controls such as Button.
//
function ContentControl(nativeTypeName) {
    if (!nativeTypeName) {
        throw new Error("You should instantiate a subclass instead");
    }
    // The caller wants an arbitrary UIElement, but with the strongly-typed members from this class
    ace.UIElement.call(this, nativeTypeName);
};

// Inheritance
ContentControl.prototype = Object.create(ace.Control.prototype);

ContentControl.prototype.getContent = function () { return this.get("ContentControl.Content"); };
ContentControl.prototype.setContent = function (content) { this.set("ContentControl.Content", content); };

module.exports = ContentControl;
