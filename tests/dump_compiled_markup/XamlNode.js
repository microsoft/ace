//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
var NodeType = require('./NodeType');

function XamlNode(type, nodeInfo, xbfReader) {
    this.type = type;
    this.nodeInfo = nodeInfo;
    this.xbfReader = xbfReader;
};

XamlNode.prototype = {
    getNamespace: function () {
        if (this.type != NodeType.Object)
            throw new Error("Invalid node type for getNamespace: " + this.type);

        var nodeId = this.nodeInfo.nodeId;
        var namespaceId = this.xbfReader.typeTable[nodeId].typeNamespaceId;
        var stringId = this.xbfReader.typeNamespaceTable[namespaceId].stringId;
        return this.xbfReader.stringTable[stringId];
    },

    getTypeName: function () {
        if (this.type != NodeType.Object)
            throw new Error("Invalid node type for getTypeName: " + this.type);

        var nodeId = this.nodeInfo.nodeId;
        var stringId = this.xbfReader.typeTable[nodeId].stringId;
        return this.xbfReader.stringTable[stringId];
    },

    getPropertyName: function () {
        if (this.type != NodeType.Property)
            throw new Error("Invalid node type for getPropertyName: " + this.type);

        var nodeId = this.nodeInfo.nodeId;
        var stringId = this.xbfReader.propertyTable[nodeId].stringId;
        return this.xbfReader.stringTable[stringId];
    },

    getPropertyOwner: function () {
        if (this.type != NodeType.Property)
            throw new Error("Invalid node type for getPropertyOwner: " + this.type);

        var nodeId = this.nodeInfo.nodeId;
        var typeId = this.xbfReader.propertyTable[nodeId].typeId;
        var stringId = this.xbfReader.typeTable[typeId].stringId;
        return this.xbfReader.stringTable[stringId];
    }
};

module.exports = XamlNode;
