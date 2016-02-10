//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
function NodeToElement() {};

NodeToElement.convert = function(xbfReader) {
    var node = xbfReader.getRoot();
    return NodeToElement.createElement(node, null, null);
};

NodeToElement.createElement = function (node, parent, root) {
    var namespace = node.getNamespace();
    var typeName = node.getTypeName();
    var element = null;

    // Built-in controls are in Windows.UI.Xaml, Windows.UI.Xaml.Controls, Windows.UI.Xaml.Documents,
    // and run.ace.
    if (ace[typeName] && (namespace.startsWith("Windows.UI.Xaml") || namespace == "run.ace")) {
        // This is a built-in element with an available strongly-typed wrapper.
        element = new ace[typeName]();
    }
    else if (namespace == "if") {
        // This is conditional XAML. Get the wrapped element, or null if it's the wrong platform.
        return NodeToElement.getConditionalElement(node, parent, root);
    }
    else {
        // See if there's a wrapper available in the matching namespace
        var parts = namespace.split(".");
        var ns = window;
        for (var i = 0; i < parts.length; i++) {
            ns = ns[parts[i]];
            if (!ns) {
                break;
            }
        }
        if (ns && ns[typeName]) {
            // We found one. Instantiate it.
            element = new ns[typeName]();
            if (!(element instanceof ace.NativeObject)) {
                throw new Error(namespace + "." + typeName + " must derive from NativeObject");
            }
        }
        else {
            // Fall back to a generic UIElement
            var fullTypeName = namespace + "." + typeName;
            if (namespace == "")
                fullTypeName = typeName;
            element = new ace.UIElement(fullTypeName);
            console.warn("There is no JavaScript wrapper class for " + fullTypeName);
        }
    }

    if (!root) {
        // This is the root
        root = element;
    }
    element._root = root;

    // Set its properties
    NodeToElement.setProperties(element, node, parent, root);

    // Now raise its loaded event
    element.raiseEvent("loaded");

    return element;
}

NodeToElement.setProperties = function (element, node, parent, root) {
    var numProperties = node.properties.length;

    // Loop through each property set in XAML
    for (var i = 0; i < numProperties; i++)
    {
        var propertyNode = node.properties[i];
        if (propertyNode.values.length < 1) {
            throw new Error("Unxpected structure of XBF property value");
        }

        var valueNode = propertyNode.values[0];
        if (valueNode.type == ace.NodeType.Text || valueNode.type == ace.NodeType.Value)
        {
            NodeToElement.setSimpleProperty(propertyNode, element, parent);
        }
        else if (valueNode.type == ace.NodeType.Object)
        {
            NodeToElement.setComplexProperty(propertyNode, element, root);
        }
        else
        {
            throw new Error("Unexpected node type of XBF property value: " + valueNode.type);
        }
    }
};

NodeToElement.setSimpleProperty = function (propertyNode, element, parent) {
    var propertyName = propertyNode.getPropertyName();
    var propertyOwner = propertyNode.getPropertyOwner();

    // Get the property value
    var propertyValue = propertyNode.values[0].value;

    // Handle XAML directives and other special properties first
    // TODO: Need to ensure XAML language namespace
    if (propertyName == "Class") {
        // Just ignore
    }
    else if (propertyName == "Key") {
        // Add this to the parent dictionary
        if (parent instanceof ace.Dictionary) {
            parent.add(propertyValue, element);
        }
        else {
            // The parent is likely the generic UIElement fallback
            // because there's no strongly-typed wrapper for this element type.
            // Don't let that prevent us from invoking "Add" on the native side.
            // That's all that Dictionary's add method does, anyway, besides
            // maintaining a local copy of the collection.
            ace.ToNative.queueInvokeMessage(element, "Add", [propertyValue]);
        }
    }
    else if (propertyName == "Name") {
        // Set the special name property for lookups, but don't bother sending it to the native side
        element.setName(propertyValue);
    }
    else if (propertyName == "__implicit_items") {
        // This is the case of a collection content property being set to a simple text value.
        // Like: <ListBox XXX="YYY">The One Item</ListBox>
        if (element instanceof ace.ObservableCollection) {
            element.add(propertyValue);
        }
        else {
            // We encountered __implicit_items on a non-collection.
            // However, this is likely to be the generic UIElement fallback
            // because there's no strongly-typed wrapper for this element type.
            // Don't let that prevent us from invoking "Add" on the native side.
            // That's all that ObservableCollection's add method does, anyway, besides
            // maintaining a local copy of the collection.
            ace.ToNative.queueInvokeMessage(element, "Add", [propertyValue]);
        }
    }
    else if (propertyName == "__implicit_initialization") {
        // This is the case of an element with content set to a simple text value
        // AND no other properties set.
        // Like: <ListBox>The One Item</ListBox>
        if (element instanceof ace.ObservableCollection)
            element.add(propertyValue);
        else
            element.set("ContentControl.Content", propertyValue); // Treat as a content property
    }
    else if (propertyOwner == "On") {
        // This is the attaching of an event
        var eventName = propertyName.toLowerCase();
        element.addEventListener(eventName, function () { eval(propertyValue); }.bind(element)); // TODO: Detach
    }
    else {
        element.set(propertyOwner + "." + propertyName, propertyValue);
    }
};

NodeToElement.setComplexProperty = function (propertyNode, element, root) {
    var propertyName = propertyNode.getPropertyName();
    var propertyOwner = propertyNode.getPropertyOwner();

    var valuesCount = propertyNode.values.length;
    for (var i = 0; i < valuesCount; i++) {
        var childNode = propertyNode.values[i];
        if (childNode != null) {
            // Create the subelement
            var childElement = NodeToElement.createElement(childNode, element, root);
            if (!childElement) {
                // This only happens for a conditional if:XXX element that's empty or not for this platform
                continue;
            }

            // Handle resource references
            if (childElement instanceof ace.StaticResource) {
                var key = childElement.getResourceKey();
                childElement = root.findResource(key);
                if (!childElement) {
                    console.error("Unable to find resource with key \"" + key + "\"");
                }
            }
            // TODO: ThemeResource

            // Add it to the current element as dictated by the property we're setting
            if (propertyName == "__implicit_items") {
                if (element instanceof ace.Dictionary) {
                    // Do nothing, because child was already added when x:Key was processed
                }
                else if (element instanceof ace.ObservableCollection) {
                    element.add(childElement);
                }
                else {
                    // We encountered __implicit_items on a non-collection.
                    // However, this is likely to be the generic UIElement fallback
                    // because there's no strongly-typed wrapper for this element type.
                    // Don't let that prevent us from sending an "Add" message to the native side.
                    // That's all that ObservableCollection's add method does, anyway.
                    ace.ToNative.queueInvokeMessage(element, "Add", [childElement]);
                }
            }
            else if (propertyName == "Style" && childElement instanceof ace.Style) {
                element.setStyle(childElement);
            }
            else {
                element.set(propertyOwner + "." + propertyName, childElement);
            }
        }
        else {
            throw new Error("Null child property object");
        }
    }
};

NodeToElement.getConditionalElement = function (node, parent, root) {
    // The type name is the target platform.
    var platform = node.getTypeName();
    if (platform != ace.platform) {
        return null;
    }

    // This should have a single child, which gets compiled as a 1-item ItemCollection
    var numProperties = node.properties.length;
    if (numProperties == 0) {
        return null;
    }
    if (numProperties != 1) {
        throw new Error("The if." + platform + " element must only have a single element child");
    }

    var propertyNode = node.properties[0];
    if (propertyNode.values.length < 1) {
        throw new Error("The if." + platform + " element must only have a single element child");
    }

    var valueNode = propertyNode.values[0];
    if (valueNode.type != ace.NodeType.Object) {
        throw new Error("The if." + platform + " element must only have a single element child");
    }

    var valuesCount = propertyNode.values.length;
    if (valuesCount != 1) {
        throw new Error("The if." + platform + " element must only have a single element child");
    }

    var itemCollectionNode = propertyNode.values[0];
    if (!itemCollectionNode) {
        throw new Error("The if." + platform + " element must only have a single element child");
    }

    // We've got the item collection node. Now get the child inside.

    var numItemCollectionProperties = itemCollectionNode.properties.length;
    if (numItemCollectionProperties == 0) {
        return null;
    }
    if (numItemCollectionProperties != 1) {
        throw new Error("The if." + platform + " element must only have a single element child");
    }

    var itemCollectionPropertyNode = itemCollectionNode.properties[0];
    if (itemCollectionPropertyNode.values.length < 1) {
        throw new Error("The if." + platform + " element must only have a single element child");
    }

    var itemCollectionValueNode = itemCollectionPropertyNode.values[0];
    if (itemCollectionValueNode.type != ace.NodeType.Object) {
        throw new Error("The if." + platform + " element must only have a single element child");
    }

    var itemCollectionValuesCount = itemCollectionPropertyNode.values.length;
    if (itemCollectionValuesCount != 1) {
        throw new Error("The if." + platform + " element must only have a single element child");
    }

    var childNode = itemCollectionPropertyNode.values[0];
    if (!childNode) {
        throw new Error("The if." + platform + " element must only have a single element child");
    }

    // Create the real element
    return NodeToElement.createElement(childNode, parent, root);
};

module.exports = NodeToElement;
