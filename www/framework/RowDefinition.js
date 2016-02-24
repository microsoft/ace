//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// Defines row-specific properties that apply to Grid elements.
//
function RowDefinition(optionalHeight) {
  ace.UIElement.call(this, "Windows.UI.Xaml.Controls.RowDefinition");
  
  if (optionalHeight) {
    this.setHeight(optionalHeight);    
  }
};

// Inheritance
RowDefinition.prototype = Object.create(ace.NativeObject.prototype);

RowDefinition.prototype.getHeight = function () { return this.get("RowDefinition.Height"); };
RowDefinition.prototype.setHeight = function (gridLength) { this.set("RowDefinition.Height", gridLength); };

module.exports = RowDefinition;
