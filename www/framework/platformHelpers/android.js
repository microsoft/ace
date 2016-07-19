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
    ifVersionAtLeast: function(version, onTrue, onFalse) {
        if (!onTrue) {
            throw new Error("An onTrue callback must be specified.");
        }

        ace.NativeObject.getField("android.os.Build$VERSION", "SDK_INT", function (sdk_int) {
            if (sdk_int >= version) {
                onTrue(sdk_int);
            }
            else if (onFalse) {
                onFalse(sdk_int);
            }
        });
    },
    
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

    startActivity: function (name, onSuccess, onError) {
        ace.ToNative.startAndroidActivity(name, onSuccess, ace.ToNative.errorHandler(onError));
    },

    appWidget: {
        clear: function() {
            ace.NativeObject.invoke("run.ace.AppWidgetData", "clear");
        },
        add: function(text) {
            ace.NativeObject.invoke("run.ace.AppWidgetData", "add", text, ace.android.getContext());
        }
    },
    
    version: {
        BASE: 1,
        BASE_1_1: 2,
        CUPCAKE: 3,
        CUR_DEVELOPMENT: 10000,
        DONUT: 4,
        ECLAIR: 5,
        ECLAIR_0_1: 6,
        ECLAIR_MR1: 7,
        FROYO: 8,
        GINGERBREAD: 9,
        GINGERBREAD_MR1: 10,
        HONEYCOMB: 11,
        HONEYCOMB_MR1: 12,
        HONEYCOMB_MR2: 13,
        ICE_CREAM_SANDWICH: 14,
        ICE_CREAM_SANDWICH_MR1: 15,
        JELLY_BEAN: 16,
        JELLY_BEAN_MR1: 17,
        JELLY_BEAN_MR2: 18,
        KITKAT: 19,
        KITKAT_WATCH: 20,
        LOLLIPOP: 21,
        LOLLIPOP_MR1: 22,
        M: 23
    }
};
