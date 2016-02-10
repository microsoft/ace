//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// Enables reading primitive data types from a supplied ArrayBuffer
//
function BinaryReader(buffer, isLittleEndian) {
    this.dataView = new DataView(buffer);
    this.offset = 0;
    this.littleEndian = isLittleEndian;
};

BinaryReader.prototype = {
    // Has more bytes
    hasMoreBytes: function () {
        return (this.dataView.byteLength != this.offset);
    },

    // Read a byte
    readByte: function () {
        return this.dataView.getUint8(this.offset++, this.littleEndian);
    },

    // Read a signed 16-bit integer
    readInt16: function () {
        var result = this.dataView.getInt16(this.offset, this.littleEndian);
        this.offset += 2;
        return result;
    },

    // Read an unsigned 16-bit integer
    readUint16: function () {
        var result = this.dataView.getUint16(this.offset, this.littleEndian);
        this.offset += 2;
        return result;
    },

    // Read a signed 32-bit integer
    readInt32: function () {
        var result = this.dataView.getInt32(this.offset, this.littleEndian);
        this.offset += 4;
        return result;
    },

    // Read an unsigned 32-bit integer
    readUint32: function () {
        var result = this.dataView.getUint32(this.offset, this.littleEndian);
        this.offset += 4;
        return result;
    },

    // Read an unsigned 64-bit integer
    readUint64: function () {
        var a, b;
        if (this.littleEndian) {
            b = this.dataView.getUint32(this.offset, this.littleEndian);
            this.offset += 4;
            a = this.dataView.getUint32(this.offset, this.littleEndian);
            this.offset += 4;
        }
        else {
            a = this.dataView.getUint32(this.offset, this.littleEndian);
            this.offset += 4;
            b = this.dataView.getUint32(this.offset, this.littleEndian);
            this.offset += 4;
        }
        return ((a << 4) | b);
    },

    // Read a 32-bit float
    readFloat32: function () {
        var result = this.dataView.getFloat32(this.offset, this.littleEndian);
        this.offset += 4;
        return result;
    },

    // Read a 64-bit float
    readFloat64: function () {
        var result = this.dataView.getFloat64(this.offset, this.littleEndian);
        this.offset += 8;
        return result;
    },

    // Read a string with the specified number of characters
    readString: function (length) {
        var s = "";
        for (var i = 0; i < length; i++) {
            var char = this.readUint16();
            s += String.fromCharCode(char);
        }
        return s;
    },

    // Read the specified number of bytes and return them as an array
    readBytes: function (length) {
        var bytes = [];
        for (var i = 0; i < length; i++) {
            bytes.push(this.dataView.getUint8(this.offset++));
        }
        return bytes;
    },

    // Skip the specified number of bytes
    skip: function (length) {
        this.offset += length;
    }
};

module.exports = BinaryReader;
