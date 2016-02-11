//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
var NodeType = require('./NodeType');

function XbfDump() {};

XbfDump.dump = function(xbfReader) {
    var node = xbfReader.getRoot();
    return XbfDump.dumpElement(node, "");
};

XbfDump.dumpElement = function (node, indent) {
    var namespace = node.getNamespace();
    var typeName = node.getTypeName();
    
    console.log(indent + "<" + namespace + "." + typeName + ">");

    // Dump its properties
    XbfDump.dumpProperties(node, indent + "  ");

    console.log(indent + "</" + namespace + "." + typeName + ">");
}

XbfDump.dumpProperties = function (node, indent) {
    var numProperties = node.properties.length;

    // Loop through each property set in XAML
    for (var i = 0; i < numProperties; i++)
    {
        var propertyNode = node.properties[i];
        if (propertyNode.values.length < 1) {
            throw new Error("Unxpected structure of XBF property value");
        }

        var valueNode = propertyNode.values[0];
        if (valueNode.type == NodeType.Text || valueNode.type == NodeType.Value) {
            XbfDump.dumpSimpleProperty(propertyNode, indent);
        }
        else if (valueNode.type == NodeType.Object) {
            XbfDump.dumpComplexProperty(propertyNode, indent);
        }
        else {
            throw new Error("Unexpected node type of XBF property value: " + valueNode.type);
        }
    }
};

XbfDump.dumpSimpleProperty = function (propertyNode, indent) {
    var propertyName = propertyNode.getPropertyName();
    var propertyOwner = propertyNode.getPropertyOwner();

    // Get the property value
    var propertyValue = propertyNode.values[0].value;

    if (propertyName == "__implicit_items") {
        // This is the case of a collection content property being set to a simple text value.
        // Like: <ListBox XXX="YYY">The One Item</ListBox>
        console.log(indent + propertyOwner + "." + propertyName + "=\"" + XbfDump.convertValue(propertyValue) + "\" (" + typeof propertyValue + ")");
    }
    else if (propertyName == "__implicit_initialization") {
        // This is the case of an element with content set to a simple text value
        // AND no other properties set.
        // Like: <ListBox>The One Item</ListBox>
        console.log(indent + propertyOwner + "." + propertyName + "=\"" + XbfDump.convertValue(propertyValue) + "\" (" + typeof propertyValue + ")");
    }
    else {
        console.log(indent + propertyOwner + "." + propertyName + "=\"" + XbfDump.convertValue(propertyValue) + "\" (" + typeof propertyValue + ")");
    }
};

XbfDump.dumpComplexProperty = function (propertyNode, indent) {
    var propertyName = propertyNode.getPropertyName();
    var propertyOwner = propertyNode.getPropertyOwner();

    console.log(indent + "<" + propertyOwner + "." + propertyName + ">");

    var valuesCount = propertyNode.values.length;
    for (var i = 0; i < valuesCount; i++) {
        var childNode = propertyNode.values[i];
        if (childNode != null) {
            XbfDump.dumpElement(childNode, indent + "  ");
        }
        else {
            throw new Error("Null child property object");
        }
    }

    console.log(indent + "</" + propertyOwner + "." + propertyName + ">");
};

XbfDump.convertValue = function (value) {
    if (typeof value === "string" || value instanceof String) {
        return value;
    }
    else if (typeof value === "number" || value instanceof Number) {
        return value;
    }
    else {
        return JSON.stringify(value);
    }
}

module.exports = XbfDump;
