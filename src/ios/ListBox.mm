//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "ListBox.h"
#import "ListBoxItem.h"
#import "OutgoingMessages.h"

@implementation ListBox

- (id)init {
    self = [super init];

    // TODO: Derive directly from UITableView?
    _tv = [[UITableView alloc] init];
    _tv.dataSource = self;
    _tv.delegate = self;
    [self addSubview:_tv];

    return self;
}

// IRecieveCollectionChanges.add
- (void) add:(NSObject*)collection item:(NSObject*)item {
    [_tv reloadData];
}

// IRecieveCollectionChanges.removeAt
- (void) removeAt:(NSObject*)collection index:(int)index {
    [_tv reloadData];
}

// Called whether user changes SelectedIndex or SelectedItem
- (void)setSelectedIndex:(int)SelectedIndex {
    [super setSelectedIndex:SelectedIndex];

    int index = self.SelectedIndex;

    if (index >= 0 && [_Items Count] > index) {
        // Select but don't scroll
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [_tv selectRowAtIndexPath:indexPath animated:false scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)setItems:(ItemCollection *)newValue {
    [super setItems:newValue];

    // Listen to collection changes
    [newValue addListener:self];

    //TODO: panel should do sizeToFit if relevant
    double defaultHeight = _Items.Count * 44;
    if (self.Header != nil)
        defaultHeight += 28;
}

- (void)ScrollIntoView:(id) param1 {
    for (int i = 0; i < [_Items Count]; i++) {
        if (_Items[i] == param1) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [_tv scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:false];
            return;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.Header == nil)
        return nil;

    if ([self.Header isKindOfClass:[NSString class]])
        return self.Header;
    else
        return [_Header description];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_Items Count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TODO";
    bool canRenderAsString = false;
    bool itemIsCell = false;
    id content = nil;
    id item = _Items[indexPath.row];

    if ([item isKindOfClass:[UITableViewCell class]]) {
        itemIsCell = true;
    }
    else if ([item isKindOfClass:[ListBoxItem class]]) {
        content = ((ListBoxItem*)item).Content;
    }
    else if ([item isKindOfClass:[NSString class]] ||
             [item isKindOfClass:[UIView class]]) {
        content = item;
    }
    else {
        content = [item description];
    }

    if ([content isKindOfClass:[NSString class]])
        canRenderAsString = true;

    UITableViewCell* cell;

    if (itemIsCell)
        cell = (UITableViewCell*)item;
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (!canRenderAsString || cell == nil) {
            // TODO: Maybe don't need to do first check anymore now that we're clearing things below (need to clear background, etc., too):
            // Forcing a new one for non-string content since the recycled container would have a stale child view
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
        }
        else {
            // Remove all subviews
            [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            // Reset selection style
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
    }

    if (canRenderAsString) {
        cell.textLabel.text = content;
    }
    else if (!itemIsCell) {
        // Handle custom elements
        CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
        frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        ((UIView*)content).frame = frame;

        // Don't enable selection of cells with views (TODO expose thru API)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell.contentView addSubview:((UIView*)content)];
    }

    if ([item isKindOfClass:[ListBoxItem class]] && ((ListBoxItem*)item).IsSelected)
    {
        // Select
        [tableView selectRowAtIndexPath:indexPath animated:false scrollPosition:UITableViewScrollPositionNone];
    }

    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO: Must handle when SelectedIndex is changed later
    if (self.SelectedIndex == indexPath.row) {
        [tableView selectRowAtIndexPath:indexPath animated:true scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    // Get selected item
    NSObject* selection = _Items[indexPath.row];
    
    // TODO: Need to enable marshaling arbitrary objects back to event handlers
    if (![selection isKindOfClass:[NSString class]] && ![selection isKindOfClass:[NSNumber class]]) {
        selection = nil;
    }
    
    if (_selectionChangedHandlers > 0) {
        [OutgoingMessages raiseEvent:@"selectionchanged" instance:self eventData:selection eventData2:[NSNumber numberWithInt:indexPath.row]];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //TODO: Temporarily make this control fill its parent
    self.frame = _tv.frame = self.superview.bounds;
}

@end
