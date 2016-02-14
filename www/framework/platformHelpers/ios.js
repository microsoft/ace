//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// iOS-specific helpers
//

var navigationController = null;

module.exports = {
    getNavigationController: function () {
        if (!navigationController)
            navigationController = new ace.KnownNativeObject("UINavigationController");
        return navigationController;
    },

    getPresentedViewControllerAsync: function (onSuccess) {
        this.getNavigationController().invoke("presentedViewController", function (viewController) {
            onSuccess(viewController);
        });
    },
    
    getCurrentModalContent: function () {
        return new ace.KnownNativeObject("CurrentModalContent");
    },

    setCurrentModalContent: function (content) {
        var root = new ace.KnownNativeObject("CurrentModalRoot");
        ace.NativeObject.invoke("UIViewHelper", "replaceContentIn:with:", root, content);
    }
};
