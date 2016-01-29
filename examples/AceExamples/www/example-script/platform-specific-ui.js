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
