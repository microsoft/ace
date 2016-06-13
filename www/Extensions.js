//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
if (!String.prototype.startsWith) {
    String.prototype.startsWith = function (substring) {
        return (this.slice(0, substring.length) == substring);
    };
}

if (!String.prototype.endsWith) {
    String.prototype.endsWith = function (substring) {
        return (this.slice(substring.length * -1) == substring);
    };
}

Array.prototype.removeAt = function (index) {
    var remainder = this.slice(index + 1);
    this.length = index;
    return this.push.apply(this, remainder);
};

Array.prototype.remove = function (item) {
    var index = -1;
    for (var i = 0; i < this.length; i++) {
        if (this[i] == item) {
            index = i;
            break;
        }
    }
    if (index >= 0)
        return this.removeAt(index);
    else
        return null;
};

Array.prototype.peek = function () {
    return this[this.length - 1];
};

Object.defineProperty(Array.prototype, "removeAt", { enumerable: false });
Object.defineProperty(Array.prototype, "remove", { enumerable: false });
Object.defineProperty(Array.prototype, "peek", { enumerable: false });

module.exports = {};
