//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

public interface IRecieveCollectionChanges {
	void add(Object collection, Object item);
	void removeAt(Object collection, int index);
}
