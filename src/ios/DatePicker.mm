//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "DatePicker.h"
#import "UIViewHelper.h"
#import "OutgoingMessages.h"
#import "Thickness.h"

@implementation DatePicker

- (id)init {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    self.padding = UIEdgeInsetsMake(0, 0, 0, 0);

    // Default property values
    _date = [NSDate date];

    _displayFormatter = [[NSDateFormatter alloc] init];
    [_displayFormatter setDateFormat:@"MMMM d, yyyy"];

    _dropDownButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_dropDownButton setTitle:[_displayFormatter stringFromDate:_date] forState:UIControlStateNormal];
    [_dropDownButton addTarget:self action:@selector(OnDropDownOpened:) forControlEvents:UIControlEventTouchUpInside];
    _dropDownButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _dropDownButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 16);

    [self.contentView addSubview:_dropDownButton];

    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker addTarget:self action:@selector(dateIsChanged:) forControlEvents:UIControlEventValueChanged];

    return self;
}

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if (![UIViewHelper setProperty:self propertyName:propertyName propertyValue:propertyValue]) {
        // This implementation is shared by TimePicker, hence the suffix checks
        if ([propertyName hasSuffix:@".Header"]) {
            //TODO: Conversion and need to clear subview/text if switching value:
            if ([propertyValue isKindOfClass:[NSString class]])
                self.textLabel.text = (NSString*)propertyValue;
            else if ([propertyValue isKindOfClass:[UIView class]])
                [self addSubview:_Header];
            else
                self.textLabel.text = [propertyValue description];
        }
        else if ([propertyName hasSuffix:@".Date"] || [propertyName hasSuffix:@".Time"]) {
            // The date/time is marshaled from JavaScript as a string.
            // Convert to an NSDate and set _date accordingly.
            if (_incomingFormatter == nil) {
                _incomingFormatter = [[NSDateFormatter alloc] init];
                [_incomingFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
            }

            _date = [_incomingFormatter dateFromString:(NSString*)propertyValue];

            // Update the display
            [_dropDownButton setTitle:[_displayFormatter stringFromDate:_date] forState:UIControlStateNormal];
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

// IFireEvents.addEventHandler
- (void) addEventHandler:(NSString*) eventName handle:(AceHandle*)handle {
    if ([eventName compare:@"datechanged"] == 0) {
        if (_dateChangedHandlers == 0) {
            _handle = handle;
        }
        _dateChangedHandlers++;
    }
    else if ([eventName compare:@"timechanged"] == 0) {
        if (_timeChangedHandlers == 0) {
            _handle = handle;
        }
        _timeChangedHandlers++;
    }
}

// IFireEvents.removeEventHandler
- (void) removeEventHandler:(NSString*) eventName {
    if ([eventName compare:@"datechanged"] == 0) {
        _dateChangedHandlers--;
    }
    else if ([eventName compare:@"timechanged"] == 0) {
        _timeChangedHandlers--;
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    #define BUILT_IN_HEIGHT_PADDING 24
    
    // Apply any left/top/bottom padding to the label
    [self.textLabel sizeToFit];
    self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x + self.padding.left,
                                0,
                                self.textLabel.frame.size.width,
                                self.textLabel.frame.size.height + self.padding.top + self.padding.bottom + BUILT_IN_HEIGHT_PADDING);
                                
    // Align the button, using the label as a guide
    CGRect labelRect = self.textLabel.frame;

    // Apply any right padding to the button
    _dropDownButton.frame = CGRectMake(
                                       labelRect.origin.x + labelRect.size.width,
                                       labelRect.origin.y - (labelRect.size.height / 2),
                                       self.frame.size.width - labelRect.origin.x - labelRect.size.width - self.padding.right,
                                       labelRect.size.height * 2);

    // Base the total size on the label, since it has the padding
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
        self.frame.size.width,
        labelRect.size.height);
}

-(void)OnDropDownOpened:(id)sender {
    if (_sheet == nil) {
        _sheet = [[CustomActionSheet alloc] init];
        _sheet.Child = _datePicker;
    }

    _datePicker.date = _date;

    [_sheet Show];
}

- (void)dateIsChanged:(id)sender {
    _date = [_datePicker date];
    NSString* formattedDate = [_displayFormatter stringFromDate:_date];
    
    // Update the display
    [_dropDownButton setTitle:formattedDate forState:UIControlStateNormal];

    // Raise the event (and send the data)
    if (_dateChangedHandlers > 0) {
        [OutgoingMessages raiseEvent:@"datechanged" handle:_handle eventData:formattedDate];
    }
    if (_timeChangedHandlers > 0) {
        NSTimeInterval totalSeconds = [_date timeIntervalSince1970];
        double totalMilliseconds = totalSeconds * 1000;
        [OutgoingMessages raiseEvent:@"timechanged" handle:_handle eventData:[NSNumber numberWithDouble:totalMilliseconds]];
    }
}

@end
