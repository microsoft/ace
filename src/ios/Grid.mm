//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Grid.h"
#import "UIViewHelper.h"
#import "Thickness.h"
#import "Utils.h"

@implementation Grid

- (id) init {
    self = [super init];

    self.padding = UIEdgeInsetsMake(0, 0, 0, 0);

    return self;
}

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if (![UIViewHelper setProperty:self propertyName:propertyName propertyValue:propertyValue]) {
        if ([propertyName compare:@"Panel.Children"] == 0) {
            if (propertyValue == nil) {
                [_children removeListener:self];
                _children = nil;
            }
            else {
                _children = (UIElementCollection*)propertyValue;
                // Listen to collection changes
                [_children addListener:self];
            }
        }
        else if ([propertyName compare:@"Grid.RowDefinitions"] == 0) {
            self.RowDefinitions = (RowDefinitionCollection*)propertyValue;
        }
        else if ([propertyName compare:@"Grid.ColumnDefinitions"] == 0) {
            self.ColumnDefinitions = (ColumnDefinitionCollection*)propertyValue;
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

// IRecieveCollectionChanges.add
- (void) add:(NSObject*)collection item:(NSObject*)item {
    //assert collection == _children;
    [self addSubview:(UIView*)item];
    [UIViewHelper resize:self];
}

// IRecieveCollectionChanges.removeAt
- (void) removeAt:(NSObject*)collection index:(int)index {
    //assert collection == _children;
    UIView* view = [self subviews][index];
    [view removeFromSuperview];
    [UIViewHelper resize:self];
}

- (CGSize) sizeThatFits:(CGSize)size {
    CGSize desiredSize = size;
    
    // UIViewHelper.resize must be called on each child for correct layout behavior
    unsigned long count = _children.Count;
    unsigned long numRows = self.RowDefinitions.Count;
    unsigned long numCols = self.ColumnDefinitions.Count;

    double totalStarHeight = size.height - self.padding.top - self.padding.bottom;
    double numStarHeightChunks = 0;
    double totalStarWidth = size.width - self.padding.left - self.padding.right;
    double numStarWidthChunks = 0;

    // First get actual child sizes for the sake of Auto rows and columns
    NSMutableArray* rowAutoHeights = nil;
    NSMutableArray* colAutoWidths = nil;

    for (unsigned long i = 0; i < count; i++) {
        // Start out with each child as its natural size
        [UIViewHelper resize:_children[i]];
    }

    if (count > 0) {       
        // Calculate what would be the auto height of each row
        if (numRows > 0) {
            rowAutoHeights = [NSMutableArray arrayWithCapacity:numRows];
            for (unsigned long i = 0; i < numRows; i++) {
                rowAutoHeights[i] = [NSNumber numberWithDouble:0];
            }

            for (unsigned long i = 0; i < count; i++) {
                UIView* child = (UIView*)_children[i];
                if (child != nil && !child.hidden) {
                    int rowSpan = [[child.layer valueForKey:@"Grid.RowSpan"] intValue];
                    rowSpan = MAX(1, rowSpan);
                    if (rowSpan == 1) {
                        unsigned long row = MIN([[child.layer valueForKey:@"Grid.Row"] intValue], numRows - 1);
                        double h = [rowAutoHeights[row] doubleValue];
                        float childHeight = child.frame.size.height;

                        // Apply any margin
                        Thickness* margin = [child.layer valueForKey:@"Ace.Margin"];
                        if (margin != nil) {
                            childHeight += margin.top + margin.bottom;
                        }

                        //TODO: Shouldn't this be MAX(h, childHeight)?
                        rowAutoHeights[row] = [NSNumber numberWithDouble:h + childHeight];
                    }
                }
            }
        }

        // Calculate what would be the auto width of each column
        if (numCols > 0) {
            colAutoWidths = [NSMutableArray arrayWithCapacity:numCols];
            for (unsigned long i = 0; i < numCols; i++) {
                colAutoWidths[i] = [NSNumber numberWithDouble:0];
            }

            for (unsigned long i = 0; i < count; i++) {
                UIView* child = (UIView*)_children[i];
                if (child != nil && !child.hidden) {
                    int colSpan = [[child.layer valueForKey:@"Grid.ColumnSpan"] intValue];
                    colSpan = MAX(1, colSpan);
                    if (colSpan == 1) {
                        unsigned long col = MIN([[child.layer valueForKey:@"Grid.Column"] intValue], numCols - 1);
                        double w = [colAutoWidths[col] doubleValue];
                        float childWidth = child.frame.size.width;

                        // Apply any margin
                        Thickness* margin = [child.layer valueForKey:@"Ace.Margin"];
                        if (margin != nil) {
                            childWidth += margin.left + margin.right;
                        }

                        //TODO: Shouldn't this be MAX(w, childWidth)?
                        colAutoWidths[col] = [NSNumber numberWithDouble:w + childWidth];
                    }
                }
            }
        }
    }

    // Now calculate pixel and auto sizes, and see how many chunks we need to divide * into
    for (unsigned long i = 0; i < numRows; i++) {
        RowDefinition* rd = self.RowDefinitions[i];
        if (rd->height->type == GridUnitTypePixel) {
            rd->calculatedHeight = rd->height->gridValue;
            totalStarHeight -= rd->calculatedHeight;
        }
        else if (rd->height->type == GridUnitTypeAuto) {
            if (rowAutoHeights != nil) {
                rd->calculatedHeight = [rowAutoHeights[i] doubleValue];
            }
            else {
                rd->calculatedHeight = 0;
            }
            totalStarHeight -= rd->calculatedHeight;
        }
        else {
            numStarHeightChunks += rd->height->gridValue;
        }
    }
    for (unsigned long i = 0; i < numCols; i++) {
        ColumnDefinition* cd = self.ColumnDefinitions[i];
        if (cd->width->type == GridUnitTypePixel) {
            cd->calculatedWidth = cd->width->gridValue;
            totalStarWidth -= cd->calculatedWidth;
        }
        else if (cd->width->type == GridUnitTypeAuto) {
            if (colAutoWidths != nil) {
                cd->calculatedWidth = [colAutoWidths[i] doubleValue];
            }
            else {
                cd->calculatedWidth = 0;
            }
            totalStarWidth -= cd->calculatedWidth;
        }
        else {
            numStarWidthChunks += cd->width->gridValue;
        }
    }

    // Now divvy up the star chunks and calculate positions
    double currentTop = self.padding.top;
    double currentLeft = self.padding.left;
    double starHeight = totalStarHeight / numStarHeightChunks;
    double starWidth = totalStarWidth / numStarWidthChunks;

    for (unsigned long i = 0; i < numRows; i++) {
        RowDefinition* rd = self.RowDefinitions[i];
        if (rd->height->type == GridUnitTypeStar) {
            rd->calculatedHeight = rd->height->gridValue * starHeight;
        }

        rd->calculatedTop = currentTop;
        currentTop += rd->calculatedHeight;
    }
    for (unsigned long i = 0; i < numCols; i++) {
        ColumnDefinition* cd = self.ColumnDefinitions[i];
        if (cd->width->type == GridUnitTypeStar) {
            cd->calculatedWidth = cd->width->gridValue * starWidth;
        }

        cd->calculatedLeft = currentLeft;
        currentLeft += cd->calculatedWidth;
    }

    // Size to content if auto width or height.
    // Explicit width/height is taken care of externally.
    NSNumber* explicitWidth = [self.layer valueForKey:@"Ace.Width"];
    NSNumber* explicitHeight = [self.layer valueForKey:@"Ace.Height"];    
    if (explicitWidth == nil || explicitHeight == nil) {
        // Apply the remainder of the padding (if any)
        CGFloat finalWidth = currentLeft + self.padding.right;
        CGFloat finalHeight = currentTop + self.padding.bottom;
        desiredSize = CGSizeMake(finalWidth, finalHeight);
    }

    // Now we've got the entire size
    return desiredSize;
}

- (void)layoutSubviews {
    // Update all row/column calculations for the current size
    [self sizeToFit];
    
    [super layoutSubviews];
    
    unsigned long count = _children.Count;
    unsigned long numRows = self.RowDefinitions.Count;
    unsigned long numCols = self.ColumnDefinitions.Count;

    // Place the children, based on the calculations done in sizeThatFits
    for (unsigned long i = 0; i < count; i++) {
        UIView* child = (UIView*)_children[i];
        if (child != nil) {
            double finalLeft = 0;
            double finalTop = 0;
            double finalWidth = 0;
            double finalHeight = 0;

            int rowSpan = [[child.layer valueForKey:@"Grid.RowSpan"] intValue];
            rowSpan = MAX(1, rowSpan);
            if (numRows == 0)
                rowSpan = 1;

            for (int span = 0; span < rowSpan; span++) {
                RowDefinition* rd;
                if (numRows > 0) {
                    unsigned long row = MIN([[child.layer valueForKey:@"Grid.Row"] intValue], numRows - 1);

                    // Guard against nonsense spans that are too big
                    if (row + span >= numRows)
                        break;
                    rd = self.RowDefinitions[row + span];
                }
                else {
                    rd = [[RowDefinition alloc] init];
                    rd->calculatedHeight = self.frame.size.height;
                    rd->calculatedTop = 0;
                }

                finalHeight += rd->calculatedHeight;
                if (span == 0)
                    finalTop = rd->calculatedTop;
            }

            int colSpan = [[child.layer valueForKey:@"Grid.ColumnSpan"] intValue];
            colSpan = MAX(1, colSpan);
            if (numCols == 0)
                colSpan = 1;

            for (int span = 0; span < colSpan; span++) {
                ColumnDefinition* cd;
                if (numCols > 0) {
                    unsigned long column = MIN([[child.layer valueForKey:@"Grid.Column"] intValue], numCols - 1);

                    // Guard against nonsense spans that are too big
                    if (column + span >= numCols)
                        break;
                    cd = self.ColumnDefinitions[column + span];
                }
                else {
                    cd = [[ColumnDefinition alloc] init];
                    cd->calculatedWidth = self.frame.size.width;
                    cd->calculatedLeft = 0;
                }

                finalWidth += cd->calculatedWidth;
                if (span == 0)
                    finalLeft = cd->calculatedLeft;
            }

            // Position the child, factoring in margin and alignment
            CGRect availableSpace = CGRectMake(finalLeft, finalTop, finalWidth, finalHeight);
            [Utils positionView:child availableSpace:availableSpace];
        }
    }
}

@end
