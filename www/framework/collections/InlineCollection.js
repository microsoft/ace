//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// An ordered collection of Inlines.
//
function InlineCollection() {
    ace.ObservableCollection.call(this, "Windows.UI.Xaml.Documents.InlineCollection");
};

// Inheritance
InlineCollection.prototype = Object.create(ace.ObservableCollection.prototype);

module.exports = InlineCollection;
