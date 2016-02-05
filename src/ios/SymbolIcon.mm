//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "SymbolIcon.h"

@implementation SymbolIcon

- (id)initWithIconString:(NSString*)s {
    self = [super init];
    _Symbol = (enum Symbol)[SymbolIcon parseSymbol:s];
    return self;
}

+ (unsigned long)parseSymbol:(NSString*)s {
    if ([s compare:@"Accept"] == 0)
        return Accept;
    else if ([s compare:@"Cancel"] == 0)
        return Cancel;
    else if ([s compare:@"Edit"] == 0)
        return Edit;
    else if ([s compare:@"Save"] == 0)
        return Save;
    else if ([s compare:@"Add"] == 0)
        return Add;
    else if ([s compare:@"Mail"] == 0)
        return Mail;
    else if ([s compare:@"MailReply"] == 0)
        return MailReply;
    else if ([s compare:@"Go"] == 0)
        return Go;
    else if ([s compare:@"OpenLocal"] == 0)
        return OpenLocal;
    else if ([s compare:@"Bookmarks"] == 0)
        return Bookmarks;
    else if ([s compare:@"Find"] == 0)
        return Find;
    else if ([s compare:@"Refresh"] == 0)
        return Refresh;
    else if ([s compare:@"Stop"] == 0)
        return Stop;
    else if ([s compare:@"Camera"] == 0)
        return Camera;
    else if ([s compare:@"Delete"] == 0)
        return Delete;
    else if ([s compare:@"Play"] == 0)
        return Play;
    else if ([s compare:@"Pause"] == 0)
        return Pause;
    else if ([s compare:@"Back"] == 0)
        return Back;
    else if ([s compare:@"Forward"] == 0)
        return Forward;
    else if ([s compare:@"Undo"] == 0)
        return Undo;
    else if ([s compare:@"Redo"] == 0)
        return Redo;
    else if ([s compare:@"Page"] == 0)
        return Symbol_Page;
    else
        return 0;
}

@end
