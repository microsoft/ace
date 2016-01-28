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

@end
