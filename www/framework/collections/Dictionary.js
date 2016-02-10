//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// The base class for a dynamic list of key/value pairs.
//
function Dictionary(nativeTypeName) {
    this._items = {};
    this.handle = ace.ToNative.queueCreateMessage(this, nativeTypeName);
};

// Inheritance
Dictionary.prototype = Object.create(ace.NativeObject.prototype);

Dictionary.prototype.add = function (key, value) {
    this._items[key] = value;
    this.invoke(ace.valueOn({ android: "Add", ios: "Add:value:" }), key, value);
};

Dictionary.prototype.get = function (key) {
    return this._items[key];
};

Dictionary.prototype.clear = function () {
    return this._items = {};
    this.invoke("Clear");
};

Dictionary.prototype.remove = function (key) {
    this._items[key] = undefined;
    this.invoke("Remove", key);
};

module.exports = Dictionary;
