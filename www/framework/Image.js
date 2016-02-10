//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// Displays an image.
//
function Image() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.Image");
};

// Inheritance
Image.prototype = Object.create(ace.UIElement.prototype);

Image.prototype.getSource = function () { return this.get("Image.Source"); };
Image.prototype.setSource = function (source) { this.set("Image.Source", source); };

module.exports = Image;
