//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "GeometryParser.h"

@implementation GeometryParser

const bool AllowSign    = true;
const bool AllowComma   = true;
const bool IsFilled     = true;
const bool IsClosed     = true;
const bool IsStroked    = true;
const bool IsSmoothJoin = true;

- (bool) More {
    return _index < _pathLength;
}

// Skip whitespace plus one comma if allowed
- (bool) SkipWhiteSpace:(bool) allowComma {
    bool commaFound = false;

    while ([self More]) {
        char ch = [_pathString characterAtIndex:_index];
        switch (ch) {
            case ' ' :
            case '\n':
            case '\r':
            case '\t':
                // Whitespace
                break;

            case ',':
                if (allowComma) {
                    commaFound = true;
                    allowComma = false; // one comma only
                }
                else {
                    throw @"Invalid token: Extra comma";
                }
                break;

            default:
                // Don't bother asking if (' '...'z'] is whitespace
                if ((ch > ' ' && ch <= 'z') || ![
                  [NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:ch
                ]) {
                    return commaFound;
                }
                break;
        }

        _index++;
    }

    return commaFound;
}

// Read the next non-whitespace character
// Returns true if not at end of string
- (bool) ReadToken {
    [self SkipWhiteSpace:!AllowComma];

    // Check for end of string
    if ([self More]) {
        _token = [_pathString characterAtIndex:_index++];
        return true;
    }
    else {
        return false;
    }
}

- (bool) IsNumber:(bool) allowComma {
    bool commaFound = [self SkipWhiteSpace:allowComma];

    if ([self More]) {
        _token = [_pathString characterAtIndex:_index];

        // Valid start of a number
        if ((_token == '.') || (_token == '-') || (_token == '+') || ((_token >= '0') && (_token <= '9'))
            || (_token == 'I')  // Infinity
            || (_token == 'N')) // NaN
        {
            return true;
        }
    }

    // Only allowed between numbers
    if (commaFound) {
        throw @"Invalid token: Comma in the wrong spot";
    }

    return false;
}

- (void) SkipDigits:(bool) signAllowed {
    // Allow for a sign
    if (signAllowed && [self More] && (([_pathString characterAtIndex:_index] == '-') || [_pathString characterAtIndex:_index] == '+')) {
        _index++;
    }

    while ([self More] && ([_pathString characterAtIndex:_index] >= '0') && ([_pathString characterAtIndex:_index] <= '9')) {
        _index++;
    }
}

- (double) ReadNumber:(bool) allowComma {
    if (![self IsNumber:allowComma]) {
        throw @"Invalid token: Non-number where a number was expected";
    }

    bool simple = true;
    int start = _index;

    // Allow for a sign
    if ([self More] && (([_pathString characterAtIndex:_index] == '-') || [_pathString characterAtIndex:_index] == '+')) {
        _index++;
    }

    // Check for Infinity (or -Infinity)
    if ([self More] && ([_pathString characterAtIndex:_index] == 'I')) {
        _index = MIN(_index + 8, _pathLength); // "Infinity" has 8 characters
        simple = false;
    }
    // Check for NaN
    else if ([self More] && ([_pathString characterAtIndex:_index] == 'N')) {
        _index = MIN(_index + 3, _pathLength); // "NaN" has 3 characters
        simple = false;
    }
    else {
        [self SkipDigits:!AllowSign];

        // Optional period, followed by more digits
        if ([self More] && ([_pathString characterAtIndex:_index] == '.')) {
            simple = false;
            _index++;
            [self SkipDigits: !AllowSign];
        }

        // Exponent
        if ([self More] && (([_pathString characterAtIndex:_index] == 'E') || ([_pathString characterAtIndex:_index] == 'e'))) {
            simple = false;
            _index++;
            [self SkipDigits: AllowSign];
        }
    }

    if (simple && (_index <= (start + 8))) // 32-bit integer
    {
        int sign = 1;

        if ([_pathString characterAtIndex:start] == '+') {
            start++;
        }
        else if ([_pathString characterAtIndex:start] == '-') {
            start++;
            sign = -1;
        }

        int value = 0;

        while (start < _index) {
            value = value * 10 + ([_pathString characterAtIndex:start] - '0');
            start++;
        }

        return value * sign;
    }
    else {
        NSString* subString = [_pathString substringWithRange:NSMakeRange(start, _index - start)];
        try {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            return [[numberFormatter numberFromString:subString] doubleValue];
        }
        catch (...) {
            throw @"Unexpected token";
        }
    }
}

- (bool) ReadBool {
    [self SkipWhiteSpace:AllowComma];

    if ([self More]) {
        _token = [_pathString characterAtIndex:_index++];

        if (_token == '0') {
            return false;
        }
        else if (_token == '1') {
            return true;
        }
    }

    throw @"Invalid token";
}

// Read a relative point
- (CGPoint) ReadPoint:(char) cmd allowComma:(bool) allowcomma {
    double x = [self ReadNumber:allowcomma];
    double y = [self ReadNumber:AllowComma]; //TODO

    if (cmd >= 'a') // 'A' < 'a'. lower case for relative
    {
        x += _lastPoint.x;
        y += _lastPoint.y;
    }

    return CGPointMake(x, y);
}

// Reflect _secondLastPoint over _lastPoint to get a new point for a smooth curve
- (CGPoint) Reflect {
    return CGPointMake(2 * _lastPoint.x - _secondLastPoint.x,
                       2 * _lastPoint.y - _secondLastPoint.y);
}

- (void) EnsureFigure {
    if (!_figureStarted) {
        [_context BeginFigure:_lastStart isFilled:IsFilled isClosed:!IsClosed];
        _figureStarted = true;
    }
}

- (void) parseToContext:(GeometryContext*)context pathString:(NSString*)pathString startIndex:(int)startIndex {
    _context = context;
    _pathString = pathString;
    _pathLength = (int)[pathString length];
    _index = startIndex;

    _secondLastPoint = CGPointMake(0, 0);
    _lastPoint = CGPointMake(0, 0);
    _lastStart = CGPointMake(0, 0);

    _figureStarted = false;

    bool first = true;
    char last_cmd = ' ';

    // Empty path is allowed
    while ([self ReadToken]) {
        char cmd = _token;

        if (first) {
            if ((cmd != 'M') && (cmd != 'm'))  // Path starts with M|m
            {
                throw @"Invalid token: Path must start with M or m";
            }

            first = false;
        }

        switch (cmd) {
            case 'm': case 'M':
                // XAML allows multiple points after M/m
                _lastPoint = [self ReadPoint:cmd allowComma: !AllowComma];

                [context BeginFigure:_lastPoint isFilled:IsFilled isClosed:!IsClosed];
                _figureStarted = true;
                _lastStart = _lastPoint;
                last_cmd = 'M';

                while ([self IsNumber:AllowComma]) {
                    _lastPoint = [self ReadPoint:cmd allowComma: !AllowComma];
                    [context LineTo:_lastPoint isStroked:IsStroked isSmoothJoin: !IsSmoothJoin];
                    last_cmd = 'L';
                }
                break;

            case 'l': case 'L':
            case 'h': case 'H':
            case 'v': case 'V':
                [self EnsureFigure];

                do {
                    switch (cmd) {
                        case 'l': _lastPoint    = [self ReadPoint:cmd allowComma: !AllowComma]; break;
                        case 'L': _lastPoint    = [self ReadPoint:cmd allowComma: !AllowComma]; break;
                        case 'h': _lastPoint.x += [self ReadNumber: !AllowComma]; break;
                        case 'H': _lastPoint.x  = [self ReadNumber: !AllowComma]; break;
                        case 'v': _lastPoint.y += [self ReadNumber: !AllowComma]; break;
                        case 'V': _lastPoint.y  = [self ReadNumber: !AllowComma]; break;
                    }
                    [context LineTo:_lastPoint isStroked:IsStroked isSmoothJoin: ! IsSmoothJoin];
                }
                while ([self IsNumber:AllowComma]);

                last_cmd = 'L';
                break;

            case 'c': case 'C': // cubic Bezier
            case 's': case 'S': // smooth cublic Bezier
                [self EnsureFigure];

                do {
                    CGPoint p;

                    if (cmd == 's' || cmd == 'S') {
                        if (last_cmd == 'C') {
                            p = [self Reflect];
                        }
                        else {
                            p = _lastPoint;
                        }
                        _secondLastPoint = [self ReadPoint:cmd allowComma: !AllowComma];
                    }
                    else {
                        p = [self ReadPoint:cmd allowComma: !AllowComma];
                        _secondLastPoint = [self ReadPoint:cmd allowComma: AllowComma];
                    }

                    _lastPoint = [self ReadPoint:cmd allowComma: AllowComma];

                    [context BezierTo:p point2:_secondLastPoint point3:_lastPoint isStroked:IsStroked isSmoothJoin: ! IsSmoothJoin];

                    last_cmd = 'C';
                }
                while ([self IsNumber:AllowComma]);

                break;

            case 'q': case 'Q': // quadratic Bezier
            case 't': case 'T': // smooth quadratic Bezier
                [self EnsureFigure];

                do {
                    if (cmd == 't' || cmd == 'T') {
                        if (last_cmd == 'Q') {
                            _secondLastPoint = [self Reflect];
                        }
                        else {
                            _secondLastPoint = _lastPoint;
                        }

                        _lastPoint = [self ReadPoint:cmd allowComma: !AllowComma];
                    }
                    else {
                        _secondLastPoint = [self ReadPoint:cmd allowComma: !AllowComma];
                        _lastPoint = [self ReadPoint:cmd allowComma: AllowComma];
                    }

                    [context QuadraticBezierTo:_secondLastPoint point2:_lastPoint isStroked:IsStroked isSmoothJoin: ! IsSmoothJoin];

                    last_cmd = 'Q';
                }
                while ([self IsNumber:AllowComma]);

                break;

            case 'a': case 'A':
                [self EnsureFigure];

                do {
                    double w        = [self ReadNumber: !AllowComma];
                    double h        = [self ReadNumber:AllowComma];
                    double rotation = [self ReadNumber:AllowComma];
                    bool large      = [self ReadBool];
                    bool sweep      = [self ReadBool];

                    _lastPoint = [self ReadPoint:cmd allowComma: AllowComma];

                    [context ArcTo:_lastPoint
                              size:CGPointMake(w, h)
                     rotationAngle:rotation
                        isLargeArc:large
                    sweepDirection:sweep ? Clockwise : Counterclockwise
                         isStroked:IsStroked
                      isSmoothJoin:!IsSmoothJoin];
                }
                while ([self IsNumber:AllowComma]);

                last_cmd = 'A';
                break;

            case 'z':
            case 'Z':
                [self EnsureFigure];
                [context SetClosedState:IsClosed];

                _figureStarted = false;
                last_cmd = 'Z';

                _lastPoint = _lastStart; // Set reference point to be first point of current figure
                break;

            default:
                throw @"Invalid token";
                break;
        }
    }
}

@end
