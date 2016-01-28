//
// The root of content hosted in a Frame.
//
function Page() {
    ace.UIElement.call(this, "Windows.UI.Xaml.Controls.Page");
};

// Inheritance
Page.prototype = Object.create(ace.UserControl.prototype);

Page.prototype.getBottomAppBar = function () { return this.get("Page.BottomAppBar"); };
Page.prototype.setBottomAppBar = function (commandBar) { this.set("Page.BottomAppBar", commandBar); };

// The same as get/set BottomAppBar, but with a better name:
Page.prototype.getCommandBar = function () { return this.get("Page.BottomAppBar"); };
Page.prototype.setCommandBar = function (commandBar) { this.set("Page.BottomAppBar", commandBar); };

// Helpers for Frame APIs
Page.prototype.getTitle = function () { return this.get("Frame.Title"); };
Page.prototype.setTitle = function (title) { this.set("Frame.Title", title); };

module.exports = Page;
