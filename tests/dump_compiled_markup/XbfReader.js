//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
var BinaryReader = require('./BinaryReader');
var XamlNode = require('./XamlNode');
var NodeType = require('./NodeType');
var XbfDump = require('./XbfDump');

// Extensions
Array.prototype.peek = function () {
    return this[this.length - 1];
};

//
// Reads an XBF 1.0 file represented by an ArrayBuffer
//
function XbfReader(buffer) {
    this.reader = new BinaryReader(buffer, true);
    this.root = null;

    this.stringTable = [];
    this.assemblyTable = [];
    this.typeNamespaceTable = [];
    this.typeTable = [];
    this.propertyTable = [];
    this.xmlNamespaceTable = [];

    this.readHeader();
    this.readTables();
    this.readNodes();
};

//
// Enums
//

XamlTypeInfoProviderKind = {
    Unknown : 0,
    Native : 1,
    Managed : 2,
    System : 3,
    Parser : 4,
    Alternate : 5
};

PersistedXamlTypeFlags = {
    None : 0,
    MarkupDirective : 1
};

PersistedXamlPropertyFlags = {
    None : 0,
    XmlProperty : 0x01,
    MarkupDirective : 0x02,
    ImplicitProperty : 0x04
};

XamlNodeType = {
    None : 0,
    StartObject : 1,
    EndObject : 2,
    StartProperty : 3,
    EndProperty : 4,
    Text : 5,
    Value : 6,
    Namespace : 7,
    EndOfAttributes : 8,
    EndOfStream : 9,
    LineInfo : 10,
    LineInfoAbsolute : 11
};

PersistedXamlValueNodeType = {
    None: 0,
    BoolFalse: 1,
    BoolTrue: 2,
    Float: 3,
    Signed: 4,
    String: 5,
    KeyTime: 6,
    Thickness: 7,
    LengthConverter: 8,
    GridLength: 9,
    Color: 10,
    Duration: 11
};

XbfReader.prototype = {
    readHeader: function() {
        var magicNumber = this.reader.readBytes(4);

        // 'X' 'B' 'F'
        if (magicNumber[0] != 0x58 && magicNumber[1] != 0x42 && magicNumber[2] != 0x46 && magicNumber[3] == 0x00) {
            throw new Error("Invalid XBF header");
        }

        var metadataSize = this.reader.readUint32();
        var nodeSize = this.reader.readUint32();
        var majorFileVersion = this.reader.readUint32();
        var minorFileVersion = this.reader.readUint32();
        var stringTableOffset = this.reader.readUint64();
        var assemblyTableOffset = this.reader.readUint64();
        var typeNamespaceTableOffset = this.reader.readUint64();
        var typeTableOffset = this.reader.readUint64();
        var propertyTableOffset = this.reader.readUint64();
        var xmlNamespaceTableOffset = this.reader.readUint64();

        // Skip the 64-byte hash
        this.reader.skip(64);

        if (majorFileVersion != 1 || minorFileVersion != 0) {
            throw new Error("Unsupported XBF version: " + majorFileVersion + "." + minorFileVersion);
        }
    },

    dump: function () {
        XbfDump.dump(this);
    },

    getRoot: function() {
        return this.root;
    },

    readTables: function() {
        this.readStringTable();
        this.readAssemblyTable();
        this.readTypeNamespaceTable();
        this.readTypeTable();
        this.readPropertyTable();
        this.readXmlNamespaceTable();
    },

    readStringTable: function()
    {
        var count = this.reader.readUint32();
        for (var i = 0; i < count; i++)
        {
            var length = this.reader.readUint32();
            var value = this.reader.readString(length);
            this.stringTable.push(value);
        }
    },

    readAssemblyTable: function()
    {
        var count = this.reader.readUint32();
        for (var i = 0; i < count; i++)
        {
            var entry = {
                providerKind: this.reader.readUint32(),
                stringId: this.reader.readUint32()
            };
            this.assemblyTable.push(entry);
        }
    },

    readTypeNamespaceTable: function()
    {
        var count = this.reader.readUint32();
        for (var i = 0; i < count; i++)
        {
            var entry = {
                assemblyId: this.reader.readUint32(),
                stringId: this.reader.readUint32()
            };
            this.typeNamespaceTable.push(entry);
        }
    },

    readTypeTable: function()
    {
        var count = this.reader.readUint32();
        for (var i = 0; i < count; i++)
        {
            var entry = {
                typeFlags: this.reader.readUint32(),
                typeNamespaceId: this.reader.readUint32(),
                stringId: this.reader.readUint32()
            };
            this.typeTable.push(entry);
        }
    },

    readPropertyTable: function()
    {
        var count = this.reader.readUint32();
        for (var i = 0; i < count; i++)
        {
            var entry = {
                propertyFlags: this.reader.readUint32(),
                typeId: this.reader.readUint32(),
                stringId: this.reader.readUint32()
            };
            this.propertyTable.push(entry);
        }
    },

    readXmlNamespaceTable: function()
    {
        var count = this.reader.readUint32();
        for (var i = 0; i < count; i++)
        {
            var entry = { stringId: this.reader.readUint32() };
            this.xmlNamespaceTable.push(entry);
        }
    },

    readNodes: function()
    {
        var typeStack = new Array();
        var propertyStack = new Array();
        var currentLinePosition = 0;
        var currentLineNumber = 0;

        while (this.reader.hasMoreBytes()) {
            var nodeType = this.reader.readByte();
            switch (nodeType) {
                case XamlNodeType.LineInfo:
                    this.skipLineInfo(currentLineNumber, currentLinePosition);
                    break;

                case XamlNodeType.LineInfoAbsolute:
                    this.skipLineInfoAbsolute();
                    break;

                case XamlNodeType.Namespace:
                    this.readNamespaceNode();
                    break;

                case XamlNodeType.StartObject:
                    var node = this.readObjectNode();
                    if (this.root == null) {
                        this.root = node;
                    }
                    typeStack.push(node);
                    break;

                case XamlNodeType.EndObject:
                    if (propertyStack.length > 0) {
                        var parentProperty = propertyStack.peek();
                        var node = typeStack.peek();
                        parentProperty.values.push(node);
                    }
                    typeStack.pop();
                    break;

                case XamlNodeType.StartProperty:
                    var node = this.readPropertyNode();
                    propertyStack.push(node);
                    break;

                case XamlNodeType.EndProperty:
                    if (typeStack.length > 0) {
                        var parentObject = typeStack.peek();
                        parentObject.properties.push(propertyStack.peek());
                    }
                    propertyStack.pop();
                    break;

                case XamlNodeType.Value:
                    var node = this.readValueNode();
                    if (propertyStack.length > 0) {
                        var parentProperty = propertyStack.peek();
                        parentProperty.values.push(node);
                    }
                    break;
                case XamlNodeType.Text:
                    var node = this.readTextNode();
                    if (propertyStack.length > 0) {
                        var parentProperty = propertyStack.peek();
                        parentProperty.values.push(node);
                    }
                    break;
                default:
                    throw new Error("Unexpected node type: " + nodeType);
            }
        }
    },

    skipLineInfo: function(lineNumber, linePosition)
    {
        var lineNumberDelta = this.reader.readInt16();
        var linePositionDelta = this.reader.readInt16();
    },

    skipLineInfoAbsolute: function()
    {
        var lineNumber = this.reader.readUint32();
        var linePosition = this.reader.readUint32();
    },

    readXamlNode: function()
    {
        return {
            nodeId: this.reader.readUint32(),
            nodeFlags: this.reader.readUint32()
        };
    },

    readValueNode: function () {
        var value = null;
        var valueNodeType = this.reader.readByte();

        switch (valueNodeType) {
            case PersistedXamlValueNodeType.BoolFalse:
                value = false;
                break;
            case PersistedXamlValueNodeType.BoolTrue:
                value = true;
                break;
            case PersistedXamlValueNodeType.Float:
            case PersistedXamlValueNodeType.KeyTime:
            case PersistedXamlValueNodeType.LengthConverter:
            case PersistedXamlValueNodeType.Duration:
                value = this.reader.readFloat32();
                break;
            case PersistedXamlValueNodeType.Signed:
                value = this.reader.readInt32();
                break;
            case PersistedXamlValueNodeType.String:
                var length = this.reader.readUint32();
                value = this.reader.readString(length);
                break;
            case PersistedXamlValueNodeType.Color:
                value = this.reader.readUint32();
                break;
            case PersistedXamlValueNodeType.Thickness:
                // TODO: Need to make class for programmatic use:
                value = {
                    _t: "Thickness",
                    left: this.reader.readFloat32(),
                    top: this.reader.readFloat32(),
                    right: this.reader.readFloat32(),
                    bottom: this.reader.readFloat32()
                };
                break;
            case PersistedXamlValueNodeType.GridLength:
                // TODO: Need to make class for programmatic use:
                value = {
                    _t: "GridLength",
                    type: this.reader.readUint32(),
                    gridValue: this.reader.readFloat32()
                };
                break;
            case PersistedXamlValueNodeType.None:
                // Ignore
                return null;
            default:
                throw new Error("Unknown value node type: " + valueNodeType);
        }

        var node = new XamlNode(NodeType.Value, null, this);
        node.value = value;
        return node;
    },

    readNamespaceNode: function()
    {
        var nodeInfo = this.readXamlNode();
        var length = this.reader.readUint32();
        var name = this.reader.readString(length);
        return { nodeInfo: nodeInfo, name: name };
    },

    readObjectNode: function ()
    {
        var nodeInfo = this.readXamlNode();
        var node = new XamlNode(NodeType.Object, nodeInfo, this);
        node.properties = [];
        return node;
    },

    readPropertyNode: function()
    {
        var nodeInfo = this.readXamlNode();
        var node = new XamlNode(NodeType.Property, nodeInfo, this);
        node.values = [];
        return node;
    },

    readTextNode: function()
    {
        var nodeInfo = this.readXamlNode();
        node = new XamlNode(NodeType.Text, nodeInfo, this);
        node.value = this.stringTable[nodeInfo.nodeId];
        return node;
    }
};

module.exports = XbfReader;
