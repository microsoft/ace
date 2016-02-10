//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A well-known NativeObject instance that was created in native code
//
function KnownNativeObject(nativeTypeName) {
    // Don't call the base constructor, because we initialize this.handle differently
    this._eventHandlers = {};
    this._properties = {};

    // Get an existing instance of a well-known named object
    this.handle = ace.ToNative.queueGetInstanceMessage(this, nativeTypeName);
};

// Inheritance
KnownNativeObject.prototype = Object.create(ace.NativeObject.prototype);

module.exports = KnownNativeObject;
