//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
var path = require('path');
var fs = require('fs');
var XbfReader = require('./XbfReader');

//
// Prints the contents of compiled markup as a XAML-like syntax (with a bit more internal details)
// You can run this as follows:
//      node dump_compiled_markup.js <filename.xbf>
//
function dump_compiled_markup(filename) {
    var contents = null;
    try {
        contents = fs.readFileSync(filename, 'utf-8');
    }
    catch (err) {
        console.error("Unable to read input .xbf file '" + filename + "': " + err);
        return;
    }
    
    // Convert the string into an ArrayBuffer
    var buffer = new ArrayBuffer(contents.length);
    var bufferView = new Uint8Array(buffer);
    for (var i = 0; i < contents.length; i++) {
        bufferView[i] = contents.charCodeAt(i);
    }

    var xbfReader = new XbfReader(buffer);
    xbfReader.dump();
};

// argv[0] is node
// argv[1] is this script
// argv[2] is the .xbf file
if (process.argv.length < 2) {
    console.error("You must pass an .xbf file as an argument.");
    return;
}

dump_compiled_markup(process.argv[2]);
