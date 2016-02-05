//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
function platform_specific_ui_init() {
    document.getElementById("mixedLink").addEventListener('click', navigateToMixedLink, false);
}

function navigateToMixedLink() {
    if (ace.platform == "iOS") {
        document.location.href = "native://MixediOS.xaml";
    }
    else if (ace.platform == "Android") {
        document.location.href = "native://MixedAndroid.xaml";
    }
}
