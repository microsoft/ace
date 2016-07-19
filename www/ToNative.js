//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
var exec = require('cordova/exec');
var platform = require('cordova/platform');

// Set up the callback for native events being sent back
exec(onNativeEventRaised, onInitializeFailed, "NativeHost", "initialize", []);

//
// The layer that communicates with the native host
//
function ToNative() {}

_pendingMessages = [];
_handlesFromManagedCount = 0;

// TODO: Lifetime: destroy APIs
_objectsFromManaged = {};
_objectsFromNative = {};

MessageType = {
    Create: 0,
    Set: 1,
    Invoke: 2,
    EventAdd: 3,
    EventRemove: 4,
    StaticInvoke: 5,
    FieldGet: 6,
    StaticFieldGet: 7,
    GetInstance: 8,
    Navigate: 9,
    FieldSet: 10,
    PrivateFieldGet: 11
};

function onInitializeFailed(error) {
    var prefix = "Unable to initialize the Ace plugin: ";
    var suffix = ". The most common reason is that <feature name=\"NativeHost\">...</feature> is missing from the copy of config.xml in the platforms directory. " +
        "Try uninstalling the plugin then reinstalling it.";
        
    var message = error;
    if (!message.startsWith(prefix)) {
        message = prefix + error + suffix;
    }

    console.log(message);
}

function defaultOnError(error) {
    var help = "See http://ace.run/docs/errors for help.";
    throw new Error("Native error: " + error + "\r\n\r\n" + help);
}

ToNative.errorHandler = function (handler) {
    return handler ? handler : defaultOnError;
};

function onNativeEventRaised(message) {
    /* TODO: No startupMarkup event:
    if (message instanceof ArrayBuffer) {
        // This is startup markup retured from initialize
        ace.XbfReader.loadBytes(message, function (root) {
            ace.getHostPage().setContent(root);
        });
        return;
    }
    */

    var handle = message[0];
    var eventName = message[1];
    var eventData = message[2];
    var eventData2 = null;
    if (message.length > 3) {
        eventData2 = message[3];
    }

    // iOS sets a null handle to -1 because otherwise the marshalled array gets cut off
    if (handle == null || handle == -1) {
        // TODO: Map ace.navigate to frame's navigate event?
        if (eventName == "ace.navigate") {
            ace.navigate(eventData);
            return;
        }
        else if (eventName == "ace.android.intentchanged") {
            ace.raiseEvent("android.intentchanged");
            return;
        }
    }

    // Move the below to a call to instanceFromHandle? But re-wraps if can't be found. Should have option to console.warn + ignore for this case.
    // Get the instance from the handle
    var instance;
    if (handle.fromNative) {
        instance = _objectsFromNative[handle.value];
    }
    else {
        instance = _objectsFromManaged[handle.value];
    }

    if (!instance.raiseEvent(eventName, eventData, eventData2)) {
        // The event should only be raised if there are existing handlers
        console.warn(eventName + " raised from native code, but there are no handlers");
    }
}

function debugPrintMessage(messageArray) {
    var debugArray = [];
    for (var i = 0; i < messageArray.length; i++) {
        var s = messageArray[i];
        if (i == 0) {
            if (s == MessageType.Create)
                s = "Create";
            else if (s == MessageType.Set)
                s = "Set";
            else if (s == MessageType.Invoke)
                s = "Invoke";
            else if (s == MessageType.EventAdd)
                s = "EventAdd";
            else if (s == MessageType.EventRemove)
                s = "EventRemove";
            else if (s == MessageType.StaticInvoke)
                s = "StaticInvoke";
            else if (s == MessageType.FieldGet)
                s = "FieldGet";
            else if (s == MessageType.StaticFieldGet)
                s = "StaticFieldGet";
            else if (s == MessageType.GetInstance)
                s = "GetInstance";
            else if (s == MessageType.Navigate)
                s = "Navigate";
            else if (s == MessageType.FieldSet)
                s = "FieldSet";
            else if (s == MessageType.PrivateFieldGet)
                s = "PrivateFieldGet";
            else
                s = "UNKNOWN";
        }
        else if (i == 1) {
            var n = s.fromNative;
            s = "$" + s.value;
            if (n)
                s += "N";
        }
        debugArray.push(s);
    }
    console.log("Queue " + _pendingMessages.length + ": " + debugArray);
}

function queueMessage(messageArray) {
    if (_pendingMessages.length == 0) {
        // Set up the function to send the messages on idle
        setTimeout(ToNative.sendPendingMessages, 0);
    }
    // debugPrintMessage(messageArray);
    _pendingMessages.push(messageArray);
}

ToNative.instanceFromHandle = function (handle) {
    var instance;
    // Try to get the existing instance
    if (handle.fromNative) {
        instance = _objectsFromNative[handle.value];
    }
    else {
        instance = _objectsFromManaged[handle.value];
    }

    if (instance === undefined) {
        // Wrapping the handle in a new instance
        instance = new ace.WrappedNativeObject(handle);
        if (handle.fromNative) {
            _objectsFromNative[handle.value] = instance;
        }
        else {
            throw new Error("The instance is missing for a managed-initiated object");
        }
    }

    return instance;
};

ToNative.queueCreateMessage = function (instance, nativeTypeName, constructorArgs) {
    var handle = { _t: "H", value: _handlesFromManagedCount++ };
    if (constructorArgs) {
        for (var i = 0; i < constructorArgs.length; i++) {
            // Marshal a NativeObject by sending its handle
            if (constructorArgs[i] instanceof ace.NativeObject)
                constructorArgs[i] = constructorArgs[i].handle;
        }
        queueMessage([MessageType.Create, handle, nativeTypeName, constructorArgs]);
    }
    else {
        queueMessage([MessageType.Create, handle, nativeTypeName]);
    }
    _objectsFromManaged[handle.value] = instance;
    return handle;
};

ToNative.queueGetInstanceMessage = function (instance, nativeTypeName) {
    var handle = { _t: "H", value: _handlesFromManagedCount++ };
    queueMessage([MessageType.GetInstance, handle, nativeTypeName]);
    _objectsFromManaged[handle.value] = instance;
    return handle;
};

ToNative.queueInvokeMessage = function (instance, methodName, args) {
    for (var i = 0; i < args.length; i++) {
        // Marshal a NativeObject by sending its handle
        if (args[i] instanceof ace.NativeObject)
            args[i] = args[i].handle;
    }
    queueMessage([MessageType.Invoke, instance.handle, methodName, args]);
};

ToNative.queueStaticInvokeMessage = function (className, methodName, args) {
    for (var i = 0; i < args.length; i++) {
        // Marshal a NativeObject by sending its handle
        if (args[i] instanceof ace.NativeObject)
            args[i] = args[i].handle;
    }
    queueMessage([MessageType.StaticInvoke, className, methodName, args]);
};

ToNative.queueFieldGetMessage = function (instance, fieldName) {
    queueMessage([MessageType.FieldGet, instance.handle, fieldName]);
};

ToNative.queueStaticFieldGetMessage = function (className, fieldName) {
    queueMessage([MessageType.StaticFieldGet, className, fieldName]);
};

ToNative.queuePrivateFieldGetMessage = function (instance, fieldName) {
    queueMessage([MessageType.PrivateFieldGet, instance.handle, fieldName]);
};

ToNative.queueSetMessage = function (instance, propertyName, propertyValue) {
    // Marshal a NativeObject by sending its handle
    if (propertyValue instanceof ace.NativeObject)
        propertyValue = propertyValue.handle;

    queueMessage([MessageType.Set, instance.handle, propertyName, propertyValue]);
};

ToNative.queueFieldSetMessage = function (instance, fieldName, fieldValue) {
    // Marshal a NativeObject by sending its handle
    if (fieldValue instanceof ace.NativeObject)
        fieldValue = fieldValue.handle;

    queueMessage([MessageType.FieldSet, instance.handle, fieldName, fieldValue]);
};

ToNative.queueEventAddMessage = function (instance, eventName) {
    queueMessage([MessageType.EventAdd, instance.handle, eventName]);
};

ToNative.queueEventRemoveMessage = function (instance, eventName) {
    queueMessage([MessageType.EventRemove, instance.handle, eventName]);
};

ToNative.queueNavigateMessage = function (instance) {
    queueMessage([MessageType.Navigate, instance.handle]);
};

ToNative.sendPendingMessages = function (onSuccess, onError) {
    if (_pendingMessages.length > 0) {
        // Send all in one batch
        // onSuccess and onError are only sent in the case of invoking a method (in a "batch" of 1)
        // in which a return value is requested.
        exec(onSuccess, ToNative.errorHandler(onError), "NativeHost", "send", _pendingMessages);
        _pendingMessages = [];
    }
};

ToNative.loadXbf = function (uri, onSuccess, onError) {
    exec(onSuccess, onError, "NativeHost", "loadXbf", [uri]);
};

ToNative.loadPlatformSpecificMarkup = function (uri, onSuccess, onError) {
    exec(onSuccess, onError, "NativeHost", "loadPlatformSpecificMarkup", [uri]);
};

ToNative.isSupported = function (onSuccess, onError) {
    exec(onSuccess, onError, "NativeHost", "isSupported", []);
};

ToNative.navigate = function (root, onSuccess, onError) {
    exec(onSuccess, onError, "NativeHost", "navigate", [root.handle]);
};

ToNative.setPopupsCloseOnHtmlNavigation = function (bool, onSuccess, onError) {
    exec(onSuccess, onError, "NativeHost", "setPopupsCloseOnHtmlNavigation", [bool]);
};

//
// Android-specific entry points:
//
ToNative.getAndroidId = function (name, onSuccess, onError) {
    exec(onSuccess, onError, "NativeHost", "getAndroidId", [name]);
};

ToNative.startAndroidActivity = function (name, onSuccess, onError) {
    exec(onSuccess, onError, "NativeHost", "startAndroidActivity", [name]);
};

module.exports = ToNative;
