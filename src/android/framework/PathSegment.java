//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

public class PathSegment {
    boolean _isSmoothJoin;
    boolean _isStroked;

    boolean getIsSmoothJoin() {
        return _isSmoothJoin;
    }
    public void setIsSmoothJoin(boolean isSmoothJoin) {
        _isSmoothJoin = isSmoothJoin;
    }

    boolean getIsStroked() {
        return _isStroked;
    }
    public void setIsStroked(boolean isStroked) {
        _isStroked = isStroked;
    }
}
