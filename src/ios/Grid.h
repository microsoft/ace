//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "IHaveProperties.h"
#import "IRecieveCollectionChanges.h"
#import "UIElementCollection.h"
#import "RowDefinition.h"
#import "ColumnDefinition.h"
#import "RowDefinitionCollection.h"
#import "ColumnDefinitionCollection.h"

@interface Grid : UIView <IHaveProperties, IRecieveCollectionChanges>
{
    UIElementCollection* _children;
}

@property RowDefinitionCollection* RowDefinitions;
@property ColumnDefinitionCollection* ColumnDefinitions;

@property UIEdgeInsets padding;

@end
