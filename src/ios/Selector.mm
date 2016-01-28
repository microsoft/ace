#import "Selector.h"

@implementation Selector

- (id)init {
    self = [super init];
    
    // Default values:
    _SelectedIndex = -1;
    
    return self;
}

- (id)getSelectedItem {
    return _SelectedItem;
}
- (void)setSelectedItem:(id)SelectedItem {
    _SelectedItem = SelectedItem;
    for (int i = 0; i < [_Items Count]; i++) {
        if (_Items[i] == _SelectedItem) {
            self.SelectedIndex = i;
        }
    }
}

- (int)getSelectedIndex {
    return _SelectedIndex;
}
- (void)setSelectedIndex:(int)SelectedIndex {
    _SelectedIndex = SelectedIndex;
}
@end
