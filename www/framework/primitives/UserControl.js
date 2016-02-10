//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A base class for defining a new control.
//
function UserControl() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.UserControl");
};

// Inheritance
UserControl.prototype = Object.create(ace.Control.prototype);

UserControl.prototype.getContent = function () { this.get("UserControl.Content"); };
UserControl.prototype.setContent = function (element) { this.set("UserControl.Content", element); };

module.exports = UserControl;
