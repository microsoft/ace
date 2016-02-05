//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// An ordered collection of RowDefinitions.
//
function RowDefinitionCollection() {
  ace.ObservableCollection.call(this, "Windows.UI.Xaml.Controls.RowDefinitionCollection");
};

// Inheritance
RowDefinitionCollection.prototype = Object.create(ace.ObservableCollection.prototype);

module.exports = RowDefinitionCollection;
