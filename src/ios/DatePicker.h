#import "IHaveProperties.h"
#import "IFireEvents.h"
#import "CustomActionSheet.h"

@interface DatePicker : UITableViewCell <IHaveProperties, IFireEvents>
{
    id _Header;
    UIButton* _dropDownButton;
    UIDatePicker* _datePicker;
    CustomActionSheet* _sheet;
    NSDateFormatter* _formatter;
    NSDate* _date;
    int _dateChangedHandlers;
    int _timeChangedHandlers;
    AceHandle* _handle;
}

-(void)OnDropDownOpened:(id)sender;

@end
