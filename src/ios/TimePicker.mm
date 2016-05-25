//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "TimePicker.h"

@implementation TimePicker

-(id) init {
    self = [super init];

    _datePicker.datePickerMode = UIDatePickerModeTime;
    [_displayFormatter setDateFormat:@"h:mm a"];
    [_dropDownButton setTitle:[_displayFormatter stringFromDate:_date] forState:UIControlStateNormal];

    return self;
}

@end
