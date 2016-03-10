//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

//
// An ordered collection of PathSegments.
//
function PathSegmentCollection() {
  ace.ObservableCollection.call(this, "Windows.UI.Xaml.Media.PathSegmentCollection");
};

// Inheritance
PathSegmentCollection.prototype = Object.create(ace.ObservableCollection.prototype);

module.exports = PathSegmentCollection;
