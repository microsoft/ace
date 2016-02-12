//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// Interacts with external native UI, perhaps from other plugins.
//
module.exports = {
    getCurrentModalContent: function () {
        return new ace.KnownNativeObject("CurrentModalContent");
    },

    setCurrentModalContent: function (content) {
        var root = new ace.KnownNativeObject("CurrentModalRoot");
        if (ace.platform == "iOS") {
            ace.NativeObject.invoke("UIViewHelper", "replaceContentIn:with:", root, content);
        }
        else {
            throw new Error("Not supported on the current platform.");
        }
    }
};
