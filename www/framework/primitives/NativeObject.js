//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// The base class for all objects with a corresponding native instance.
// All objects have a handle property.
//
function NativeObject(nativeTypeName /*, ...*/) {
    this._eventHandlers = {};
    this._properties = {};

    if (arguments.length > 1) {
        var constructorArgs = [];
        for (var i = 1; i < arguments.length; i++) {
            constructorArgs.push(arguments[i]);
        }
        // Call a parameterized constructor
        this.handle = ace.ToNative.queueCreateMessage(this, nativeTypeName, constructorArgs);
    }
    else {
        this.handle = ace.ToNative.queueCreateMessage(this, nativeTypeName);
    }
};

function unwrapResult(result) {
    if (!result)
        return result;

    if (result.length !== undefined) {
        if (result.length == 1) {
            // This is a single primitive value from Android, which wraps it in a JSONArray
            // TODO: Fix this so we can distinguish between this and a one-element array
            return result[0];
        }
        else if (typeof result === "string" || result instanceof String) {
            // Just a string, not really an array!
            return result;
        }
        else {
            alert("NYI: array: " + result.length + ", " + result);
        }
    }
    else if (result.value !== undefined) {
        var instance = ace.ToNative.instanceFromHandle(result);
        return instance;
    }
    else {
        // This is a single primitive value
        return result;
    }
}

function fieldHelper(instance, isPrivate, className, fieldName, onSuccess, onError) {
    if (!fieldName) {
        throw new Error("You must specify a field");
    }

    if (!onSuccess) {
        throw new Error("You must specify a callback that receives the value");
    }

    // The caller needs the value, so we can't queue this message in the same
    // batch as all the other messages.

    // First send out all pending messages
    ace.ToNative.sendPendingMessages();

    // Now queue this single message
    if (instance) {
        if (isPrivate) {
            ace.ToNative.queuePrivateFieldGetMessage(instance, fieldName);
        }
        else {
            ace.ToNative.queueFieldGetMessage(instance, fieldName);
        }
    }
    else {
        ace.ToNative.queueStaticFieldGetMessage(className, fieldName);
    }
    
    // Send this out as a batch of one, with the passed-in callbacks
    ace.ToNative.sendPendingMessages(function (result) { onSuccess(unwrapResult(result)) }, onError);
}

function invokeHelper(instance, className, methodName, varargsStartIndex, varargs) {
    if (!methodName) {
        throw new Error("You must specify a method to invoke.");
    }

    var args = [];
    var onSuccess = null;
    var onError = null;

    // Process the arguments, skipping varargs[0] and perhaps varagrs[1],
    // which were either methodName or className+methodName
    for (var i = varargsStartIndex; i < varargs.length; i++) {
        if (typeof varargs[i] === "function") {
            if (!onSuccess)
                onSuccess = varargs[i];
            else
                onError = varargs[i];
        }
        else {
            args.push(varargs[i]);
        }
    }

    if (onSuccess) {
        // The caller wants a return value, so we can't queue this message in the same
        // batch as all the other messages.

        // First send out all pending messages
        ace.ToNative.sendPendingMessages();

        // Now queue this single invocation message
        if (instance)
            ace.ToNative.queueInvokeMessage(instance, methodName, args);
        else
            ace.ToNative.queueStaticInvokeMessage(className, methodName, args);

        // Send this out as a batch of one, with the passed-in callbacks
        ace.ToNative.sendPendingMessages(function (result) { onSuccess(unwrapResult(result)) }, onError);
    }
    else {
        if (instance)
            ace.ToNative.queueInvokeMessage(instance, methodName, args);
        else
            ace.ToNative.queueStaticInvokeMessage(className, methodName, args);
    }
}

// Invoke an instance (or static) method
//
// Pass any arguments as additional parameters.
// Valid arguments are primitive types.
// If the last two parameters are functions, they will be used as
// "onSuccess" and "onError" callback functions.
// onSuccess is passed the return value from the method.
// onError is passed the error.
// If only the last parameter is a function, it will be used as an "onSuccess"
// callback.
NativeObject.prototype.invoke = function (methodName /*, ...*/) {
    invokeHelper(this, null, methodName, 1, arguments);
};

// Invoke a static method
//
// Pass any arguments as additional parameters.
// Valid arguments are primitive types.
// If the last two parameters are functions, they will be used as
// "onSuccess" and "onError" callback functions.
// onSuccess is passed the return value from the method.
// onError is passed the error.
// If only the last parameter is a function, it will be used as an "onSuccess"
// callback.
NativeObject.invoke = function (className, methodName /*, ...*/) {
    invokeHelper(null, className, methodName, 2, arguments);
};

// Get a property value
// Properties are special because they are cached locally and therefore
// can be retrieved synchronously.
NativeObject.prototype.get = function (propertyName) {
    // Only ever retrieve a local value.
    // If something on the native side changes a property value, it will be reflected already.
    //
    // By design, the default value of all properties is undefined, which means "has never been set."
    // In practice, this could mean different native values on different platforms (like a different default font size).
    return this._properties[propertyName];
};

// Set a property value
NativeObject.prototype.set = function (propertyName, propertyValue) {
    // Store locally
    this.invalidate(propertyName, propertyValue);
    // Send to the native side
    ace.ToNative.queueSetMessage(this, propertyName, propertyValue);
};

// Set the property value without propagating the change to the native side.
// This should ONLY be called in response to property invalidations that originate
// from the native side. That way, both sides still stay in-sync.
NativeObject.prototype.invalidate = function (propertyName, propertyValue) {
    // Store locally
    this._properties[propertyName] = propertyValue;
};

// Get the value of an instance (or static) field
NativeObject.prototype.getField = function (fieldName, onSuccess, onError) {
    fieldHelper(this, false, null, fieldName, onSuccess, onError);
};

// Get the value of a static field
NativeObject.getField = function (className, fieldName, onSuccess, onError) {
    fieldHelper(null, false, className, fieldName, onSuccess, onError);
};

// Get the value of a private instance (or static) field
NativeObject.prototype.getPrivateField = function (fieldName, onSuccess, onError) {
    fieldHelper(this, true, null, fieldName, onSuccess, onError);
};

// Set the value of an instance (or static) field
NativeObject.prototype.setField = function (fieldName, fieldValue) {
    ace.ToNative.queueFieldSetMessage(this, fieldName, fieldValue);
};

NativeObject.prototype.addEventListener = function (eventName, func) {
    if (!this._eventHandlers[eventName]) {
        this._eventHandlers[eventName] = [];
    }
    this._eventHandlers[eventName].push(func);

    // The "loaded" event is special and handled purely on the managed side
    if (eventName != "loaded") {
        ace.ToNative.queueEventAddMessage(this, eventName);
    }
};

NativeObject.prototype.removeEventListener = function (eventName, func) {
    if (this._eventHandlers[eventName]) {
        this._eventHandlers[eventName].remove(func);
    }
    ace.ToNative.queueEventRemoveMessage(this, eventName);
};

NativeObject.prototype.removeAllEventListeners = function () {
    //TODO: Need to detach on native side, too!
    this._eventHandlers = {};
};

NativeObject.prototype.raiseEvent = function (eventName, eventData, eventData2) {
    // Call any handlers
    // Currently, derived collections do not have the _eventHandlers member
    if (this._eventHandlers) {
        if (this._eventHandlers[eventName]) {
            // Create a clone of the current event handlers list to ensure that we continue to notify
            // all handlers even if one calls back into removeEventListener
            var handlers = this._eventHandlers[eventName].slice(0);
            for (var i = 0; i < handlers.length; i++) {
                handlers[i](this, eventData, eventData2);
            }
            return true;
        }
    }
    return false;
};

module.exports = NativeObject;
