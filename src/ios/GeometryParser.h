#import "GeometryContext.h"

@interface GeometryParser : NSObject
{
  NSString* _pathString;
  int _pathLength;
  int _index;
  bool _figureStarted;
  CGPoint _lastStart;
  CGPoint _lastPoint;
  CGPoint _secondLastPoint;
  char _token;
  GeometryContext* _context;
}

- (bool) More;
- (bool) SkipWhiteSpace:(bool) allowComma;
- (bool) ReadToken;
- (bool) IsNumber:(bool) allowComma;
- (void) SkipDigits:(bool) signAllowed;
- (double) ReadNumber:(bool) allowComma;
- (bool) ReadBool;
- (CGPoint) ReadPoint:(char) cmd allowComma:(bool) allowcomma;
- (CGPoint) Reflect;
- (void) EnsureFigure;

- (void) parseToContext:(GeometryContext*)context pathString:(NSString*)pathString startIndex:(int)startIndex;

@end
