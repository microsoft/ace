//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A NativeObject whose instantiation was triggered in native code
//
function WrappedNativeObject(handle) {
    // Don't call the base constructor, because we initialize this.handle differently
    this._eventHandlers = {};
    this._properties = {};

    // Wrap an unknown native object. All we know is its handle.
    this.handle = handle;
};

// Inheritance
WrappedNativeObject.prototype = Object.create(ace.NativeObject.prototype);

module.exports = WrappedNativeObject;
