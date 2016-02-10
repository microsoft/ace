//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// The base class for all panels, which position and arrange child elements.
//
function Panel() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.Panel");
};

// Inheritance
Panel.prototype = Object.create(ace.UIElement.prototype);

Panel.prototype.getBackground = function () { return this.get("Panel.Background"); };
Panel.prototype.setBackground = function (brush) { this.set("Panel.Background", brush); };

Panel.prototype.getChildren = function () {
    // Give an empty collection by default rather than null
    var children = this.get("Panel.Children");
    if (!children) {
        children = new ace.UIElementCollection();
        this.setChildren(children);
    }
    return children;
};
Panel.prototype.setChildren = function (children) { this.set("Panel.Children", children); };

module.exports = Panel;
