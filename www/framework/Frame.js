//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// The container for navigation.
//
function Frame() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.Frame");
};

// Inheritance
Frame.prototype = Object.create(ace.ContentControl.prototype);

Frame.goBack = function () {
    ace.NativeObject.invoke("Windows.UI.Xaml.Controls.Frame", "GoBack");
};

Frame.hideNavigationBar = function () {
    ace.NativeObject.invoke("Windows.UI.Xaml.Controls.Frame", "HideNavigationBar");
};

Frame.showNavigationBar = function () {
    ace.NativeObject.invoke("Windows.UI.Xaml.Controls.Frame", "ShowNavigationBar");
};

Frame.getTitle = function (page) { return page.get("Frame.Title"); };
Frame.setTitle = function (page, title) { page.set("Frame.Title", title); };

module.exports = Frame;
