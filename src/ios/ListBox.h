#import "Selector.h"

@interface ListBox : Selector<IRecieveCollectionChanges, UITableViewDelegate, UITableViewDataSource>
{
    UITableView* _tv;
}

// TODO: Currently here for the benefit of ListView
@property id Header;

@end
