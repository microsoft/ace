//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// An ordered collection of ColumnDefinitions.
//
function ColumnDefinitionCollection() {
  ace.ObservableCollection.call(this, "Windows.UI.Xaml.Controls.ColumnDefinitionCollection");
};

// Inheritance
ColumnDefinitionCollection.prototype = Object.create(ace.ObservableCollection.prototype);

module.exports = ColumnDefinitionCollection;
