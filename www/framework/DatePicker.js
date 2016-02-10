//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A control that enables a user to pick a date value.
//
function DatePicker() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.DatePicker");
    // Invalidations from native property changes:
    this.addEventListener("datechanged", this._onDateChanged.bind(this));
};

// Inheritance
DatePicker.prototype = Object.create(ace.Control.prototype);

// TODO: Enable data sent back to specify type so it can be converted properly (string->date)
DatePicker.prototype._onDateChanged = function (datePicker, dateString) {
    var d = new Date(dateString);
    datePicker.invalidate("DatePicker.Date", d);
}

DatePicker.prototype.destroy = function () { this.removeEventListener("datechanged", this._onDateChanged); };

DatePicker.prototype.getDate = function () { return this.get("DatePicker.Date"); };
DatePicker.prototype.setDate = function (date) { this.set("DatePicker.Date", date); };

DatePicker.prototype.getHeader = function () { return this.get("DatePicker.Header"); };
DatePicker.prototype.setHeader = function (content) { this.set("DatePicker.Header", content); };

module.exports = DatePicker;
