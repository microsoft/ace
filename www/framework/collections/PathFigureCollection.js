//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// An ordered collection of PathFigures.
//
function PathFigureCollection() {
  ace.ObservableCollection.call(this, "Windows.UI.Xaml.Media.PathFigureCollection");
};

// Inheritance
PathFigureCollection.prototype = Object.create(ace.ObservableCollection.prototype);

module.exports = PathFigureCollection;
