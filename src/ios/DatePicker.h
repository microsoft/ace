//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "IHaveProperties.h"
#import "IFireEvents.h"
#import "CustomActionSheet.h"

@interface DatePicker : UITableViewCell <IHaveProperties, IFireEvents>
{
    id _Header;
    UIButton* _dropDownButton;
    UIDatePicker* _datePicker;
    CustomActionSheet* _sheet;
    NSDateFormatter* _displayFormatter;
    NSDateFormatter* _incomingFormatter;
    NSDate* _date;
    int _dateChangedHandlers;
    int _timeChangedHandlers;
    AceHandle* _handle;
}

@property UIEdgeInsets padding;

-(void)OnDropDownOpened:(id)sender;

@end
