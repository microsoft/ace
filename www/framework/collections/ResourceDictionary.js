//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// Defines a repository for XAML resources, such as styles, that your app uses.
//
function ResourceDictionary() {
    ace.Dictionary.call(this, "Windows.UI.Xaml.ResourceDictionary");
};

// Inheritance
ResourceDictionary.prototype = Object.create(ace.Dictionary.prototype);

module.exports = ResourceDictionary;
