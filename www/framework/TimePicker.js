//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A control that enables a user to pick a time value.
//
function TimePicker() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.TimePicker");
    // Invalidations from native property changes:
    this.addEventListener("timechanged", this._onTimeChanged.bind(this));
};

// Inheritance
TimePicker.prototype = Object.create(ace.Control.prototype);

// TODO: Enable data sent back to specify type so it can be converted properly (string->time)
TimePicker.prototype._onTimeChanged = function (timePicker, timeMilliseconds) {
    var d = new Date(timeMilliseconds);
    timePicker.invalidate("TimePicker.Time", d);
}

TimePicker.prototype.destroy = function () { this.removeEventListener("timechanged", this._onTimeChanged); };

TimePicker.prototype.getTime = function () { return this.get("TimePicker.Time"); };
TimePicker.prototype.setTime = function (time) { this.set("TimePicker.Time", time); };

TimePicker.prototype.getHeader = function () { return this.get("TimePicker.Header"); };
TimePicker.prototype.setHeader = function (content) { this.set("TimePicker.Header", content); };

module.exports = TimePicker;
