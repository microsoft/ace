//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A container for an item in a TableView.
//
function TableViewCell() {
    ace.UIElement.call(this, "run.ace.TableViewCell");
};

// Inheritance
TableViewCell.prototype = Object.create(ace.ListBoxItem.prototype);

TableViewCell.prototype.getImage = function () { return this.get("TableViewCell.Image"); };
TableViewCell.prototype.setImage = function (image) { this.set("TableViewCell.Image", image); };

TableViewCell.prototype.getDetailText = function () { return this.get("TableViewCell.DetailText"); };
TableViewCell.prototype.setDetailText = function (detailText) { this.set("TableViewCell.DetailText", detailText); };

TableViewCell.prototype.getText = function () { return this.get("TableViewCell.Text"); };
TableViewCell.prototype.setText = function (text) { this.set("TableViewCell.Text", text); };

module.exports = TableViewCell;
