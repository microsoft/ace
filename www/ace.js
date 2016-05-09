//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
_eventHandlers = {};

var _oldNavigatingAwayHandler = null;
var _oldRoot = null;

var _hostPage = null;
var _hostWebView = null;

// Convert a native:// XAML URL to a path
function convertXamlUrlToPath(url) {
    var filename = url.substr("native://".length);
    if (filename.toLowerCase().endsWith(".xaml")) {
        filename = filename.substr(0, filename.length - ".xaml".length);
    }
    return "www/xbf/" + filename + ".xbf";
}

// Convert an android:// URL to a layout resource name
function convertAndroidUrlToPath(url) {
    var filename = url.substr("android://".length);
    if (filename.toLowerCase().endsWith(".xml")) {
        filename = filename.substr(0, filename.length - ".xml".length);
    }
    return filename;
}

// Convert an ios:// NIB/XIB URL to a path
function convertiOSUrlToPath(url) {
    var path = url.substr("ios://".length);
    if (path.toLowerCase().endsWith(".nib") || path.toLowerCase().endsWith(".xib")) {
        path = path.substr(0, path.length - ".nib".length);
    }
    return path;
}

module.exports = {
    valueOn: function (platformValues) {
        return platformValues[ace.platform.toLowerCase()];
    },

    isSupported: function (onSuccess, onError) {
        return ace.ToNative.isSupported(onSuccess, onError);
    },

    navigate: function (urlOrUIElement, onNavigated, onNavigatingAway, onError) {
        if (_oldNavigatingAwayHandler) {
            _oldNavigatingAwayHandler(_oldRoot);
            _oldNavigatingAwayHandler = null;
        }
        else {
            // Only raise the global event if there's no handler for it
            ace.raiseEvent("navigating", _oldRoot, urlOrUIElement);
        }

        var onLoaded = function(root) {
            _oldRoot = root;
            ace.ToNative.queueNavigateMessage(root);
            if (onNavigated) {
                onNavigated(root);
            }
            else {
                // Only raise the global event if there's no handler for it
                ace.raiseEvent("navigated", root, urlOrUIElement);
            }
        };

        if (typeof urlOrUIElement == "string") {
            var url = urlOrUIElement;
            if (url.startsWith("native://")) {
                //if (url.toLowerCase().endsWith(".xaml")) {
                    // XAML
                    url = convertXamlUrlToPath(url);
                    ace.XbfReader.load(url, onLoaded, ace.ToNative.errorHandler(onError));
                //}
            }
            else if (url.startsWith("android://")) {
                // ANDROID XML
                url = convertAndroidUrlToPath(url);
                ace.ToNative.loadPlatformSpecificMarkup(url, function(handle) { onLoaded(ace.ToNative.instanceFromHandle(handle)); }, ace.ToNative.errorHandler(onError));
            }
            else if (url.startsWith("ios://")) {
                // INTERFACE BUILDER NIB/XIB
                url = convertiOSUrlToPath(url);
                ace.ToNative.loadPlatformSpecificMarkup(url, function(handle) { onLoaded(ace.ToNative.instanceFromHandle(handle)); }, ace.ToNative.errorHandler(onError));
            }
            else {
                throw new Error("Unsupported url for navigate: " + url);
            }
        }
        else if (urlOrUIElement instanceof ace.NativeObject) {
            onLoaded(urlOrUIElement);
        }
        else {
            throw new Error("The first parameter must be a url or a NativeObject");
        }
    },

    load: function (url, onSuccess, onError) {
        if (url.startsWith("native://")) {
            //if (url.toLowerCase().endsWith(".xaml")) {
                // XAML
                url = convertXamlUrlToPath(url);
                ace.XbfReader.load(url, onSuccess, ace.ToNative.errorHandler(onError));
            //}
        }
        else if (url.startsWith("android://")) {
            // ANDROID XML
            url = convertAndroidUrlToPath(url);
            ace.ToNative.loadPlatformSpecificMarkup(url, function (handle) { onSuccess(ace.ToNative.instanceFromHandle(handle)); }, ace.ToNative.errorHandler(onError));
        }
        else if (url.startsWith("ios://")) {
            // INTERFACE BUILDER NIB/XIB
            url = convertiOSUrlToPath(url);
            ace.ToNative.loadPlatformSpecificMarkup(url, function (handle) { onSuccess(ace.ToNative.instanceFromHandle(handle)); }, ace.ToNative.errorHandler(onError));
        }
        else {
            throw new Error("Unsupported url for load: " + url);
        }
    },

    goBack: function() {
        ace.Frame.goBack();
    },

    getHostPage: function () {
        // This is just like KnownNativeObject, but derives from Page instead, so the nice APIs are available
        function HostPage() {
            // Don't call the base constructor, because we initialize this.handle differently
            this._eventHandlers = {};
            this._properties = {};

            // Get an existing instance of a well-known named object
            this.handle = ace.ToNative.queueGetInstanceMessage(this, "HostPage");
        };
        // Inheritance
        HostPage.prototype = Object.create(ace.Page.prototype);

        if (!_hostPage)
            _hostPage = new HostPage();
        return _hostPage;
    },

    getHostWebView: function () {
        // This is just like KnownNativeObject, but derives from WebView instead, so the nice APIs are available
        function HostWebView() {
            // Don't call the base constructor, because we initialize this.handle differently
            this._eventHandlers = {};
            this._properties = {};

            // Get an existing instance of a well-known named object
            this.handle = ace.ToNative.queueGetInstanceMessage(this, "HostWebView");
        };
        // Inheritance
        HostWebView.prototype = Object.create(ace.WebView.prototype);

        if (!_hostWebView)
            _hostWebView = new HostWebView();
        return _hostWebView;
    },

    setPopupsCloseOnHtmlNavigation: function (bool) {
        ace.ToNative.setPopupsCloseOnHtmlNavigation(bool);
    },

    addEventListener: function (event, func) {
        var eventName = event.toLowerCase();
        if (!_eventHandlers[eventName]) {
            _eventHandlers[eventName] = [];
        }
        _eventHandlers[eventName].push(func);
    },

    removeEventListener: function (event, func) {
        var eventName = event.toLowerCase();
        if (_eventHandlers[eventName]) {
            _eventHandlers[eventName].remove(func);
        }
    },

    raiseEvent: function (event, eventData1, eventData2) {
        var eventName = event.toLowerCase();
        if (_eventHandlers[eventName]) {
            // Create a clone of the current event handlers list to ensure that we continue to notify
            // all handlers even if one calls back into removeEventListener
            var handlers = _eventHandlers[eventName].slice(0);
            for (var i = 0; i < handlers.length; i++) {
                handlers[i](eventData1, eventData2);
            }
        }
    }
};
