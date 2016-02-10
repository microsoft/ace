//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// Applies a value to a property in a Style.
//
function Setter() {
    ace.NativeObject.call(this, "Windows.UI.Xaml.Setter");
};

// Inheritance
Setter.prototype = Object.create(ace.NativeObject.prototype);

Setter.prototype.getProperty = function () { return this.get("Setter.Property"); };
Setter.prototype.setProperty = function (propertyName) { this.set("Setter.Property", propertyName); };

Setter.prototype.getValue = function () { return this.get("Setter.Value"); };
Setter.prototype.setValue = function (value) { this.set("Setter.Value", value); };

module.exports = Setter;
