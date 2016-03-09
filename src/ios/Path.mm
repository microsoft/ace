//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Path.h"
#import "Color.h"
#import "PathGeometry.h"
#import "PathFigure.h"
#import "PathSegment.h"
#import "LineSegment.h"
#import "PolyLineSegment.h"
#import "ArcSegment.h"
#import "BezierSegment.h"
#import "PolyBezierSegment.h"
#import "QuadraticBezierSegment.h"
#import "PolyQuadraticBezierSegment.h"
#import "LinearGradientBrush.h"
#import "GradientStop.h"
#import "GeometryConverter.h"

@implementation Path

- (id) init {
    self = [super init];

    self.backgroundColor = [UIColor clearColor];

    // Default property values
    self.strokeStartLineCap = @"Flat";
    self.strokeEndLineCap = @"Flat";
    self.strokeThickness = 1.0;

    return self;
}

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
  if ([propertyName hasSuffix:@".Data"]) {
    if ([propertyValue isKindOfClass:[Geometry class]]) {
      self.data = (Geometry*)propertyValue;
    }
    else {
      self.data = [GeometryConverter parse:(NSString*)propertyValue];
    }
    // Redraw
    [self setNeedsDisplay];
  }
  else {
    [super setProperty:propertyName value:propertyValue];
  }
}

-(void) drawRect: (CGRect)rect {
    // TODO: Respect Shape stretch and Geometry bounds
    bool hasGradientFill = false;

    //TODO: Otherwise the top/left strokes get cut off
    int shift = 1;

    //TODO: Placeholder:
    int scale = 1;

    // Get colors for stroke and fill
    CGColorRef strokeColor = [Color fromObject:self.stroke withDefault:[UIColor clearColor]].CGColor;
    CGGradientRef gradientFill = nil;
    CGColorRef fillColor = nil;
    if ([self.fill isKindOfClass:[LinearGradientBrush class]]) {
      hasGradientFill = true;

      NSMutableArray* colors = [[NSMutableArray alloc] init];
      CGFloat offsets[] = { 0, 1 };

      // TODO on startPoint/endPoint
      LinearGradientBrush* lgb = (LinearGradientBrush*)self.fill;
      for (int i = 0; i < lgb.gradientStops.Count; i++) {
          // DesignerMode: Allow bad colors
          if (((GradientStop*)lgb.gradientStops[i]).color == nil && DESIGNERMODE)
            [colors addObject:(__bridge id)[UIColor clearColor].CGColor];
          else
            [colors addObject:(__bridge id)((GradientStop*)lgb.gradientStops[i]).color.CGColor];
          //TODO: [offsets addObject:[NSNumber numberWithDouble:((GradientStop*)lgb.gradientStops[i]).offset]];
      }

      CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
      gradientFill = CGGradientCreateWithColors(baseSpace, (__bridge CFArrayRef) colors, offsets);
      CGColorSpaceRelease(baseSpace);
      baseSpace = NULL;
    }
    else {
      fillColor = [Color fromObject:self.fill withDefault:[UIColor clearColor]].CGColor;
    }

    // TODO on different start vs. end line caps
    CGLineCap lineCap = kCGLineCapButt;
    if (self.strokeStartLineCap != nil) {
        if ([self.strokeStartLineCap compare:@"Flat" options:NSCaseInsensitiveSearch] == 0)
            lineCap = kCGLineCapButt;
        else if ([self.strokeStartLineCap compare:@"Square" options:NSCaseInsensitiveSearch] == 0)
            lineCap = kCGLineCapSquare;
        else if ([self.strokeStartLineCap compare:@"Round" options:NSCaseInsensitiveSearch] == 0)
            lineCap = kCGLineCapRound;
        else
            throw @"Unsupported line cap (Triangle)";
    }

    CGLineJoin lineJoin = kCGLineJoinMiter;
    if (self.strokeLineJoin != nil) {
        if ([self.strokeLineJoin compare:@"Bevel" options:NSCaseInsensitiveSearch] == 0)
            lineJoin = kCGLineJoinBevel;
        else if ([self.strokeLineJoin compare:@"Miter" options:NSCaseInsensitiveSearch] == 0)
            lineJoin = kCGLineJoinMiter;
        else if ([self.strokeLineJoin compare:@"Round" options:NSCaseInsensitiveSearch] == 0)
            lineJoin = kCGLineJoinRound;
        else
            throw @"Unsupported line join";
    }

    if ([_data isKindOfClass:[PathGeometry class]]) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClearRect(context, rect);

        CGContextSaveGState(context); //TODO: Needed?

        // Once-per-Path Stroke settings:
        CGContextSetLineCap(context, lineCap);
        CGContextSetStrokeColorWithColor(context, strokeColor);
        CGContextSetLineWidth(context, self.strokeThickness);
        CGContextSetLineJoin(context, lineJoin);
        CGContextSetMiterLimit(context, self.strokeMiterLimit);
        if (!hasGradientFill) {
            CGContextSetFillColorWithColor(context, fillColor);
        }

        // Loop thru figures
        PathFigureCollection* figures = ((PathGeometry*)_data).figures;
        for (int i = 0; i < [figures Count]; i++) {
            PathFigure* figure = figures[i];

            CGPoint previousPoint = figure.startPoint;

            CGPoint startPoint = CGPointMake(figure.startPoint.x, figure.startPoint.y);
            CGContextMoveToPoint(context, (startPoint.x * scale) + shift, (startPoint.y * scale) + shift);

            // Loop thru segments
            PathSegmentCollection* segments = figure.Segments;
            for (int j = 0; j < [segments Count]; j++) {
                PathSegment* segment = segments[j];

                if ([segment isKindOfClass:[LineSegment class]]) {
                    CGPoint currentPoint = ((LineSegment*)segment).Point;
                    CGContextAddLineToPoint(context, (currentPoint.x * scale) + shift, (currentPoint.y * scale) + shift);
                    previousPoint = currentPoint;
                }
                else if ([segment isKindOfClass:[PolyLineSegment class]]) {
                    PointCollection* points = ((PolyLineSegment*)segment).Points;
                    for (int k = 0; k < points.Count; k++) {
                        CGPoint currentPoint = [points[k] CGPointValue];
                        CGContextAddLineToPoint(context, (currentPoint.x * scale) + shift, (currentPoint.y * scale) + shift);
                        previousPoint = currentPoint;
                    }
                }
                else if ([segment isKindOfClass:[ArcSegment class]]) {
                    ArcSegment* arc = (ArcSegment*)segment;
                    CGPoint currentPoint = arc.Point;
                    CGContextAddArc(context, (currentPoint.x * scale) + shift, (currentPoint.y * scale) + shift,
                                    arc.Size.x /*TODO*/,
                                    arc.RotationAngle - 2,
                                    arc.RotationAngle,
                                    arc.SweepDirection);
                    previousPoint = currentPoint;
                }
                else if ([segment isKindOfClass:[BezierSegment class]]) {
                    CGPoint controlPoint1 = ((BezierSegment*)segment).Point1;
                    CGPoint controlPoint2 = ((BezierSegment*)segment).Point2;
                    CGPoint currentPoint = ((BezierSegment*)segment).Point3;
                    CGContextAddCurveToPoint(context, (controlPoint1.x * scale) + shift, (controlPoint1.y * scale) + shift, (controlPoint2.x * scale) + shift, (controlPoint2.y * scale) + shift, (currentPoint.x * scale) + shift, (currentPoint.y * scale) + shift);
                    previousPoint = currentPoint;
                }
                else if ([segment isKindOfClass:[PolyBezierSegment class]]) {
                    PointCollection* points = ((PolyBezierSegment*)segment).Points;
                    for (int k = 0; k < points.Count; k++) {
                        CGPoint controlPoint1 = [points[k] CGPointValue];
                        k++;
                        CGPoint controlPoint2 = [points[k] CGPointValue];
                        k++;
                        CGPoint currentPoint = [points[k] CGPointValue];
                        CGContextAddCurveToPoint(context, (controlPoint1.x * scale) + shift, (controlPoint1.y * scale) + shift, (controlPoint2.x * scale) + shift, (controlPoint2.y * scale) + shift, (currentPoint.x * scale) + shift, (currentPoint.y * scale) + shift);
                        previousPoint = currentPoint;
                    }
                }
                else if ([segment isKindOfClass:[QuadraticBezierSegment class]]) {
                    CGPoint controlPoint = ((QuadraticBezierSegment*)segment).Point1;
                    CGPoint currentPoint = ((QuadraticBezierSegment*)segment).Point2;
                    CGContextAddQuadCurveToPoint(context, (controlPoint.x * scale) + shift, (controlPoint.y * scale) + shift, (currentPoint.x * scale) + shift, (currentPoint.y * scale) + shift);
                    previousPoint = currentPoint;
                }
                else if ([segment isKindOfClass:[PolyQuadraticBezierSegment class]]) {
                    PointCollection* points = ((PolyQuadraticBezierSegment*)segment).Points;
                    for (int k = 0; k < points.Count; k++) {
                        CGPoint controlPoint = [points[k] CGPointValue];
                        k++;
                        CGPoint currentPoint = [points[k] CGPointValue];
                        CGContextAddQuadCurveToPoint(context, (controlPoint.x * scale) + shift, (controlPoint.y * scale) + shift, (currentPoint.x * scale) + shift, (currentPoint.y * scale) + shift);
                        previousPoint = currentPoint;
                    }
                }
                else {
                    throw [NSString stringWithFormat:@"NYI: segment of type %@", [segment class]];
                }
            }

            if (figure.IsClosed) {
                CGContextAddLineToPoint(context, (figure.startPoint.x * scale) + shift, (figure.startPoint.y * scale) + shift);
            }
        }

        // Draw it
        if (self.fill != nil) {
            if (hasGradientFill) {
                // TODO: This isn't quite right because it seems to lose stroke settings
                // TODO on EvenOdd
                CGPathRef path = CGContextCopyPath(context);

                CGContextStrokePath(context);
                CGContextAddPath(context, path);
                CGContextClip(context);

                CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
                CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));

                // TODO: Gradient is based on Path bounds rather than content bounds
                CGContextDrawLinearGradient(context, gradientFill, startPoint, endPoint, 0);
                CGGradientRelease(gradientFill);
                gradientFill = NULL;
            }
            else if (((PathGeometry*)_data).fillRule == EvenOdd) {
                CGContextDrawPath(context, kCGPathEOFillStroke);
            }
            else {
                CGContextDrawPath(context, kCGPathFillStroke);
            }
        }
        else {
            CGContextStrokePath(context);
        }

        CGContextRestoreGState(context); //TODO needed?
    } // end of if PathGeometry
    else if (_data != nil) {
      throw @"Unsupported geometry type";
    }
}

- (void)layoutSubviews {
    // Update bounds for latest geometry bounds right before drawRect is called
    //TODO: Not correct due to miter corners, etc...
    CGRect bounds = _data.bounds;
    CGRect r = CGRectMake(self.frame.origin.x, self.frame.origin.y,
      bounds.size.width + self.strokeThickness, bounds.size.height + self.strokeThickness);
    self.frame = r;
}

@end
