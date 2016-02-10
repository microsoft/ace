//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// A dynamic list that provides notifications when items change.
//
function ObservableCollection(nativeTypeName) {
    this._items = [];
    this.handle = ace.ToNative.queueCreateMessage(this, nativeTypeName);
};

// Inheritance
ObservableCollection.prototype = Object.create(ace.NativeObject.prototype);

ObservableCollection.prototype.add = function (item) {
    this._items.push(item);
    this.invoke(ace.valueOn({ android: "Add", ios: "Add:" }), item);
};

ObservableCollection.prototype.size = function () {
    return this._items.length;
};

ObservableCollection.prototype.get = function (index) {
    return this._items[index];
};

ObservableCollection.prototype.clear = function () {
    this.invoke("Clear");
    return this._items = [];
};

ObservableCollection.prototype.remove = function (item) {
    for (var i = 0; i < this._items.length; i++) {
        if (this._items[i] == item) {
            return this.removeAt(i);
        }
    }
    return null;
};

ObservableCollection.prototype.removeAt = function (index) {
    this.invoke("RemoveAt", index);
    return this._items.removeAt(index);
};

module.exports = ObservableCollection;
