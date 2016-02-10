//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// Android-specific helpers
//

var context = null;
var activity = null;

module.exports = {
    getContext: function () {
        if (!context)
            context = new ace.KnownNativeObject("android.content.Context");
        return context;
    },

    getActivity: function () {
        if (!activity)
            activity = new ace.KnownNativeObject("android.app.Activity");
        return activity;
    },

    getIntent: function () {
        // Don't cache, because this changes.
        // For example, an app widget selection sends a new Intent
        return new ace.KnownNativeObject("android.content.Intent");
    },

    getId: function (name, onSuccess, onError) {
        ace.ToNative.getAndroidId(name, onSuccess, ace.ToNative.errorHandler(onError));
    },

    appWidget: {
        clear: function() {
            ace.NativeObject.invoke("run.ace.AppWidgetData", "clear");
        },
        add: function(text) {
            ace.NativeObject.invoke("run.ace.AppWidgetData", "add", text, ace.android.getContext());
        }
    }
};
