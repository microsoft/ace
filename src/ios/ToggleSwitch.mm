//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "ToggleSwitch.h"
#import "UIViewHelper.h"
#import "OutgoingMessages.h"
#import "Thickness.h"

@implementation ToggleSwitch

- (id)init {
    self = [super init];

    self.padding = UIEdgeInsetsMake(0, 0, 0, 0);

    _header = [[UILabel alloc] init];
    _switch = [[UISwitch alloc] init];

    [self addSubview:_header];
    [self addSubview:_switch];

    // Initialize this wrapping view to the size of the switch
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _switch.frame.size.width, _switch.frame.size.height);

    // Touches on the header should toggle the switch
    _header.userInteractionEnabled = true;
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeaderTouch:)];
    [_header addGestureRecognizer:gesture];

    return self;
}

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if (![UIViewHelper setProperty:self propertyName:propertyName propertyValue:propertyValue]) {
        if ([propertyName compare:@"ToggleSwitch.IsOn"] == 0) {
            [_switch setOn:[(NSNumber*)propertyValue boolValue] animated:true];
        }
        else if ([propertyName hasSuffix:@".Header"]) {
            if ([propertyValue isKindOfClass:[NSString class]] || propertyValue == nil) {
                _header.text = (NSString*)propertyValue;
            }
            else {
                _header.text = [propertyValue description];
            }
        }
        else if ([propertyName hasSuffix:@".Padding"]) {
            Thickness* padding = [Thickness fromObject:propertyValue];
            self.padding = UIEdgeInsetsMake(padding.top, padding.left, padding.bottom, padding.right);
            [self layoutSubviews];
        }
        else {
            throw [NSString stringWithFormat:@"Unhandled property for %@: %@", [self class], propertyName];
        }
    }
}

- (void)onHeaderTouch:(id)sender {
    [_switch setOn:!_switch.on animated:true];
}

- (void)onIsOnChanged:(id)sender {
    [OutgoingMessages raiseEvent:@"isonchanged" handle:_handle eventData:[NSNumber numberWithBool:_switch.on]];
}

// IFireEvents.addEventHandler
- (void) addEventHandler:(NSString*) eventName handle:(AceHandle*)handle {
    if ([eventName compare:@"isonchanged"] == 0) {
        if (_isOnChangedHandlers == 0) {
            // Set up the message sending, which goes to all handlers
            _handle = handle;
            [_switch addTarget:self action:@selector(onIsOnChanged:) forControlEvents:UIControlEventValueChanged];
        }
        _isOnChangedHandlers++;
    }
}

// IFireEvents.removeEventHandler
- (void) removeEventHandler:(NSString*) eventName {
    if ([eventName compare:@"isonchanged"] == 0) {
        _isOnChangedHandlers--;
        if (_isOnChangedHandlers == 0) {
            // Stop sending messages because nobody is listening
            [_switch removeTarget:self action:@selector(onIsOnChanged:) forControlEvents:UIControlEventValueChanged];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_header.text == nil) {
        // Whatever size was given to this this wrapping view should be given entirely to the switch
        // (but respecting any padding)
        _switch.frame = CGRectMake(self.padding.left, self.padding.top, 
            self.frame.size.width - self.padding.left - self.padding.right, 
            self.frame.size.height - self.padding.top - self.padding.bottom);
    }
    else {
        // Do the normal header + switch layout
        
        // TODO: Depends on phone?
        //       Seems like 20 is the right value for iPhone 6s,
        //       But 15 is the right value for iPhone 6.
        #define LEFTMARGIN 20
        #define RIGHTMARGIN 20

        _switch.frame = CGRectMake(self.frame.size.width - _switch.frame.size.width - RIGHTMARGIN - self.padding.right,
                                   ((self.frame.size.height - self.padding.top - self.padding.bottom - _switch.frame.size.height) / 2) + self.padding.top,
                                   _switch.frame.size.width, 
                                   _switch.frame.size.height);

        _header.frame = CGRectMake(LEFTMARGIN + self.padding.left,
                                   self.padding.top,
                                   self.frame.size.width - LEFTMARGIN - self.padding.left - self.padding.right,
                                   self.frame.size.height - self.padding.top - self.padding.bottom);
    }
}

@end
