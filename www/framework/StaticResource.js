//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A resource referenced used in XAML.
//
function StaticResource() {
    ace.NativeObject.call(this, "Windows.UI.Xaml.StaticResource");
};

// Inheritance
StaticResource.prototype = Object.create(ace.NativeObject.prototype);

StaticResource.prototype.getResourceKey = function () { return this.get("StaticResource.ResourceKey"); };
StaticResource.prototype.setResourceKey = function (key) { this.set("StaticResource.ResourceKey", key); };

module.exports = StaticResource;
