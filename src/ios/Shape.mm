//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Shape.h"
#import "UIViewHelper.h"

@implementation Shape

- (id) init {
    self = [super init];

    // Default property values
    self.StrokeMiterLimit = 10;

    return self;
}

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
  if (![UIViewHelper setProperty:self propertyName:propertyName propertyValue:propertyValue]) {
    if ([propertyName hasSuffix:@".Stroke"]) {
      self.stroke = (Brush*)propertyValue;
    }
    else if ([propertyName hasSuffix:@".StrokeThickness"]) {
      self.strokeThickness = [(NSNumber*)propertyValue doubleValue];
    }
    else if ([propertyName hasSuffix:@".StrokeStartLineCap"]) {
      self.strokeStartLineCap = (NSString*)propertyValue;
    }
    else if ([propertyName hasSuffix:@".StrokeEndLineCap"]) {
      self.strokeEndLineCap = (NSString*)propertyValue;
    }
    else if ([propertyName hasSuffix:@".Fill"]) {
      self.fill = (Brush*)propertyValue;
    }
    else if ([propertyName hasSuffix:@".StrokeLineJoin"]) {
      self.strokeLineJoin = (NSString*)propertyValue;
    }
    else if ([propertyName hasSuffix:@".StrokeMiterLimit"]) {
      self.strokeMiterLimit = [(NSNumber*)propertyValue doubleValue];
    }
    else if ([propertyName hasSuffix:@".Stretch"]) {
      self.stretch = (NSString*)propertyValue;
    }
    else {
      throw [NSString stringWithFormat:@"Unhandled property for %@: %@", [self class], propertyName];
    }
  }
}

- (void)setStroke:(Brush*)stroke {
    _stroke = stroke;
    // Redraw
    [self setNeedsDisplay];
}

- (void)setStrokeThickness:(double)strokeThickness {
    _strokeThickness = strokeThickness;
    // Redraw
    [self setNeedsDisplay];
}

- (void)setStrokeStartLineCap:(NSString*)strokeStartLineCap {
    _strokeStartLineCap = strokeStartLineCap;
    // Redraw
    [self setNeedsDisplay];
}

- (void)setStrokeEndLineCap:(NSString*)strokeEndLineCap {
    _strokeEndLineCap = strokeEndLineCap;
    // Redraw
    [self setNeedsDisplay];
}

- (void)setFill:(Brush*)fill {
    _fill = fill;
    // Redraw
    [self setNeedsDisplay];
}

- (void)setStrokeLineJoin:(NSString*)strokeLineJoin {
    _strokeLineJoin = strokeLineJoin;
    // Redraw
    [self setNeedsDisplay];
}

- (void)setStrokeMiterLimit:(double)strokeMiterLimit {
    _strokeMiterLimit = strokeMiterLimit;
    // Redraw
    [self setNeedsDisplay];
}

- (void)setStretch:(NSString*)stretch {
    _stretch = stretch;
    // Redraw
    [self setNeedsDisplay];
}

@end
