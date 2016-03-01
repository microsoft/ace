//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "TableViewCell.h"
#import "Utils.h"

@implementation TableViewCell

- (id)init {
    // TODO: Change style on the fly?
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Default"];
    
    // TODO: Expose as enum:
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return self;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    return self;
}

- (void)setImage:(ImageSource*)newValue {
    _Image = newValue;

    UIImage* image = [Utils getImage:newValue.UriSource];
    self.imageView.image = image;    
    
    //TODO:
    self.imageView.frame = CGRectMake(2, 2, 41, 41);
}

- (void)setText:(NSString*)Text {
    _Text = Text;
    self.textLabel.text = Text;
}

- (void)setDetailText:(NSString*)DetailText {
    _DetailText = DetailText;
    self.detailTextLabel.text = DetailText;
}

@end
