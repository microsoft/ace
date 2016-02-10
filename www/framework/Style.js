//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// Contains property setters that can be shared between instances of a type. Usually declared in a resources collection.
//
function Style() {
    ace.NativeObject.call(this, ace.valueOn({ android: "Windows.UI.Xaml.Style", ios: "XamlStyle" }));
};

// Inheritance
Style.prototype = Object.create(ace.NativeObject.prototype);

Style.prototype.getSetters = function () {
    // Give an empty collection by default rather than null
    var setters = this.get("Style.Setters");
    if (!setters) {
        setters = new ace.SetterBaseCollection();
        this.setSetters(setters);
    }
    return setters;
};
Style.prototype.setSetters = function (setters) { this.set("Style.Setters", setters); };

Style.prototype.getTargetType = function () { return this.get("Style.TargetType"); };
Style.prototype.setTargetType = function (targetType) { this.set("Style.TargetType", targetType); };

module.exports = Style;
