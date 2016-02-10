//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A switch that can be toggled between two states.
//
function ToggleSwitch() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.ToggleSwitch");
    // Invalidations from native property changes:
    this.addEventListener("isonchanged", this._onIsOnChanged.bind(this));
};

// Inheritance
ToggleSwitch.prototype = Object.create(ace.Control.prototype);

ToggleSwitch.prototype._onIsOnChanged = function (instance, value) {
    instance.invalidate("ToggleSwitch.IsOn", value);
}

//TODO: Need to call base destroy:
ToggleSwitch.prototype.destroy = function () { this.removeEventListener("isonchanged", this._onIsOnChanged); };

ToggleSwitch.prototype.getHeader = function () { return this.get("ToggleSwitch.Header"); };
ToggleSwitch.prototype.setHeader = function (content) { this.set("ToggleSwitch.Header", content); };

ToggleSwitch.prototype.getIsOn = function () { return this.get("ToggleSwitch.IsOn"); };
ToggleSwitch.prototype.setIsOn = function (value) { this.set("ToggleSwitch.IsOn", value); };

module.exports = ToggleSwitch;
