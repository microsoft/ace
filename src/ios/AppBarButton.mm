//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "AppBarButton.h"
#import "SymbolIcon.h"
#import "BitmapIcon.h"

@implementation AppBarButton

// Must override, otherwise just Button is instantiated
- (id)init {
    // Required for getting the right visual behavior:
    self = [AppBarButton buttonWithType:UIButtonTypeSystem];
    return self;
}

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if ([propertyName hasSuffix:@".Label"]) {
        _Label = (NSString*)propertyValue;
    }
    else if ([propertyName hasSuffix:@".Icon"]) {
        if ([propertyValue isKindOfClass:[NSString class]]) {
            if ([SymbolIcon parseSymbol:(NSString*)propertyValue] == 0) {
                BitmapIcon* bi = [[BitmapIcon alloc] init];
                bi.UriSource = (NSString*)propertyValue;
                [self setIcon:bi];
            }
            else {
                [self setIcon:[[SymbolIcon alloc] initWithIconString:(NSString*)propertyValue]];
            }
        }
        else
            [self setIcon:(IconElement*)propertyValue];
    }
    else {
        [super setProperty:propertyName value:propertyValue];
    }
}

- (IconElement *)Icon {
    return _Icon;
}

- (void)setIcon:(IconElement *)Icon {
    _Icon = Icon;

    if ([Icon isKindOfClass:[SymbolIcon class]]) {
        enum Symbol symbol = ((SymbolIcon*)Icon).Symbol;

        _hasSystemIcon = true;
        switch (symbol)
        {
            case Accept:
                _systemIcon = UIBarButtonSystemItemDone;
                break;
            case Cancel:
                _systemIcon = UIBarButtonSystemItemCancel;
                break;
            case Edit:
                _systemIcon = UIBarButtonSystemItemEdit;
                break;
            case Save:
                _systemIcon = UIBarButtonSystemItemSave;
                break;
            case Add:
                _systemIcon = UIBarButtonSystemItemAdd;
                break;
            case Mail:
                _systemIcon = UIBarButtonSystemItemCompose;
                break;
            case MailReply:
                _systemIcon = UIBarButtonSystemItemReply;
                break;
            case Go:
                _systemIcon = UIBarButtonSystemItemAction;
                break;
            case OpenLocal:
                _systemIcon = UIBarButtonSystemItemOrganize;
                break;
            case Bookmarks:
                _systemIcon = UIBarButtonSystemItemBookmarks;
                break;
            case Find:
                _systemIcon = UIBarButtonSystemItemSearch;
                break;
            case Refresh:
                _systemIcon = UIBarButtonSystemItemRefresh;
                break;
            case Stop:
                _systemIcon = UIBarButtonSystemItemStop;
                break;
            case Camera:
                _systemIcon = UIBarButtonSystemItemCamera;
                break;
            case Delete:
                _systemIcon = UIBarButtonSystemItemTrash;
                break;
            case Play:
                _systemIcon = UIBarButtonSystemItemPlay;
                break;
            case Pause:
                _systemIcon = UIBarButtonSystemItemPause;
                break;
            case Back:
                _systemIcon = UIBarButtonSystemItemRewind;
                break;
            case Forward:
                _systemIcon = UIBarButtonSystemItemFastForward;
                break;
            case Undo:
                _systemIcon = UIBarButtonSystemItemUndo;
                break;
            case Redo:
                _systemIcon = UIBarButtonSystemItemRedo;
                break;
            case Symbol_Page:
                _systemIcon = UIBarButtonSystemItemPageCurl;
                break;
            default:
                _hasSystemIcon = false;
                break;
        }

        // This is for using the AppBarButton outside of a CommandBar
        if (symbol == Back)
            [self setTitle:@"Back" forState:UIControlStateNormal];
        else if (symbol == Refresh)
            [self setTitle:@"Refresh" forState:UIControlStateNormal];
        else if (symbol == Stop)
            [self setTitle:@"Stop" forState:UIControlStateNormal];
        else // TODO on all the rest
            [self setTitle:@"[X]" forState:UIControlStateNormal];
    }
    else if ([Icon isKindOfClass:[BitmapIcon class]]) {
        // TODO: Handle case where AppBarButton is outside of toolbar
        // For inside toolbar, nothing to do here.
    }
    else
        throw @"Unhandled icon type";
}

@end
