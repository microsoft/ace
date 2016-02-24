//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
function UIElement(nativeTypeName) {
    ace.NativeObject.call(this, nativeTypeName);
};

// Inheritance
UIElement.prototype = Object.create(ace.NativeObject.prototype);

var _programmaticInstances = {};

UIElement.prototype.setName = function (name) {
    if (!this._root) {
        // This is being called on an object created programmatically
        this._root = _programmaticInstances;
    }

    if (this._name) {
        // Remove the field for the old name
        this._root[this._name] = undefined;
    }
    this._name = name;
    if (this._name) {
        // Add the field for the new name
        this._root[this._name] = this;
    }
};

UIElement.prototype.getName = function () { return this._name; };

// Finds an element that has the provided identifier name
UIElement.prototype.findName = function (name) {
    var element;
    if (this._root) {
        element = this._root[name];
    }
    if (!element) {
        element = _programmaticInstances[name];
    }
    return element;
};

UIElement.prototype.getHeight = function () { return this.get("FrameworkElement.Height"); };
UIElement.prototype.setHeight = function (height) { this.set("FrameworkElement.Height", height); };

UIElement.prototype.getHorizontalAlignment = function () { return this.get("FrameworkElement.HorizontalAlignment"); };
UIElement.prototype.setHorizontalAlignment = function (alignment) { this.set("FrameworkElement.HorizontalAlignment", alignment); };

UIElement.prototype.getMargin = function () { return this.get("FrameworkElement.Margin"); };
UIElement.prototype.setMargin = function (thickness) { this.set("FrameworkElement.Margin", thickness); };

UIElement.prototype.getParent = function (onSuccess) {
    if (ace.platform == "iOS") {
        this.invoke("superview", onSuccess);
    }
    else if (ace.platform == "Android") {
        this.invoke("getParent", onSuccess);
    }
};

UIElement.prototype.getResources = function () { return this.get("FrameworkElement.Resources"); };
UIElement.prototype.setResources = function (resources) { this.set("FrameworkElement.Resources", resources); };

UIElement.prototype.getStyle = function () { return this.get("FrameworkElement.Style"); };
UIElement.prototype.setStyle = function (style) {
    if (style instanceof ace.Style) {
        var setters = style.getSetters();
        var targetType = style.getTargetType();

        // Set each of the properties in the Style
        for (var i = 0; i < setters.size() ; i++) {
            var propertyName = setters.get(i).getProperty();
            if (propertyName.indexOf(".") == -1) {
                propertyName = targetType + "." + propertyName;
            }
            this.set(propertyName, setters.get(i).getValue());
        }
    }
    else {
        // Treat as JSON
        for (var key in style) {
            //TODO: Need typeName for proper prefix
            this.set("FrameworkElement." + key, style[key]);
        }
    }
    // Don't bother sending to the native side.
    // Just cache locally for the sake of getStyle()
    this.invalidate("FrameworkElement.Style", style);
};

UIElement.prototype.getVerticalAlignment = function () { return this.get("FrameworkElement.VerticalAlignment"); };
UIElement.prototype.setVerticalAlignment = function (alignment) { this.set("FrameworkElement.VerticalAlignment", alignment); };

UIElement.prototype.getWidth = function () { return this.get("FrameworkElement.Width"); };
UIElement.prototype.setWidth = function (width) { this.set("FrameworkElement.Width", width); };

// Removes an element from its parent.
UIElement.prototype.remove = function (onRemoved) {
    if (ace.platform == "iOS") {
        // This works for any UIView
        this.invoke("removeFromSuperview");
        if (onRemoved) {
            onRemoved();
        }
    }
    else if (ace.platform == "Android") {
        // This works for any View
        this.invoke("getParent", function (viewParent) {
            if (viewParent != null) {
                viewParent.invoke("removeView", this);
            }
            if (onRemoved) {
                onRemoved();
            }
        }.bind(this));
    }
};

UIElement.prototype.findResource = function (resourceKey) {
    var dictionary = this.getResources();
    if (dictionary) {
        return dictionary.get(resourceKey);
    }
};

module.exports = UIElement;
