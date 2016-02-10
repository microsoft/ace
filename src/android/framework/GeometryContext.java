//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

public class GeometryContext {
  PathGeometry _pathGeometry;

  public GeometryContext(Geometry g) {
    _pathGeometry = (PathGeometry)g;
  }

  public void close() {
    this.finishSegment();
  }

  // TODO: Implement

  void finishSegment() {
    // TODO: Implement
  }
}
