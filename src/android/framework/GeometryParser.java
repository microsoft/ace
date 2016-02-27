//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.graphics.PointF;

public class GeometryParser {
    static final boolean AllowSign    = true;
    static final boolean AllowComma   = true;
    static final boolean IsFilled     = true;
    static final boolean IsClosed     = true;
    static final boolean IsStroked    = true;
    static final boolean IsSmoothJoin = true;

    String _pathString;
    int _pathLength;
    int _index;
    boolean _figureStarted;
    PointF _lastStart;
    PointF _lastPoint;
    PointF _secondLastPoint;
    char _token;
    GeometryContext _context;

    boolean more() {
        return (_index < _pathLength);
    }

    // Skip whitespace plus one comma if allowed
    boolean skipWhiteSpace(boolean allowComma) {
        boolean commaFound = false;

        while (this.more()) {
            char ch = _pathString.charAt(_index);
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
                        throw new RuntimeException("Invalid token: Extra comma");
                    }
                    break;

                default:
                    // Don't bother asking if (' '...'z'] is whitespace
                    if ((ch > ' ' && ch <= 'z') || !Character.isWhitespace(ch)) {
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
    boolean readToken() {
        this.skipWhiteSpace(!AllowComma);

        // Check for end of string
        if (this.more()) {
            _token = _pathString.charAt(_index++);
            return true;
        }
        else {
            return false;
        }
    }

    boolean isNumber(boolean allowComma) {
        boolean commaFound = this.skipWhiteSpace(allowComma);

        if (this.more()) {
            _token = _pathString.charAt(_index);

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
            throw new RuntimeException("Invalid token: Comma in the wrong spot");
        }

        return false;
    }

    void skipDigits(boolean signAllowed) {
        // Allow for a sign
        if (signAllowed && this.more() && (_pathString.charAt(_index) == '-' || _pathString.charAt(_index) == '+')) {
            _index++;
        }

        while (this.more() && _pathString.charAt(_index) >= '0' && _pathString.charAt(_index) <= '9') {
            _index++;
        }
    }

    float readNumber(boolean allowComma) {
        if (!this.isNumber(allowComma)) {
            throw new RuntimeException("Invalid token: Non-number where a number was expected");
        }

        boolean simple = true;
        int start = _index;

        // Allow for a sign
        if (this.more() && (_pathString.charAt(_index) == '-' || _pathString.charAt(_index) == '+')) {
            _index++;
        }

        // Check for Infinity (or -Infinity)
        if (this.more() && (_pathString.charAt(_index) == 'I')) {
            _index = Math.min(_index + 8, _pathLength); // "Infinity" has 8 characters
            simple = false;
        }
        // Check for NaN
        else if (this.more() && (_pathString.charAt(_index) == 'N')) {
            _index = Math.min(_index + 3, _pathLength); // "NaN" has 3 characters
            simple = false;
        }
        else {
            this.skipDigits(!AllowSign);

            // Optional period, followed by more digits
            if (this.more() && (_pathString.charAt(_index) == '.')) {
                simple = false;
                _index++;
                this.skipDigits(!AllowSign);
            }

            // Exponent
            if (this.more() && ((_pathString.charAt(_index) == 'E') || (_pathString.charAt(_index) == 'e'))) {
                simple = false;
                _index++;
                this.skipDigits(AllowSign);
            }
        }

        if (simple && (_index <= (start + 8))) // 32-bit integer
        {
            int sign = 1;

            if (_pathString.charAt(start) == '+') {
                start++;
            }
            else if (_pathString.charAt(start) == '-') {
                start++;
                sign = -1;
            }

            int value = 0;

            while (start < _index) {
                value = value * 10 + (_pathString.charAt(start) - '0');
                start++;
            }

            return value * sign;
        }
        else {
            String subString = _pathString.substring(start, _index - 1);
            try {
                return Float.parseFloat(subString);
            }
            catch (Exception ex) {
                throw new RuntimeException("Unexpected token");
            }
        }
    }

    boolean readBool() {
        this.skipWhiteSpace(AllowComma);

        if (this.more()) {
            _token = _pathString.charAt(_index++);

            if (_token == '0') {
                return false;
            }
            else if (_token == '1') {
                return true;
            }
        }

        throw new RuntimeException("Invalid token");
    }

    // Read a relative point
    PointF readPoint(char cmd, boolean allowcomma) {
        float x = this.readNumber(allowcomma);
        float y = this.readNumber(AllowComma); //TODO

        if (cmd >= 'a') // 'A' < 'a'. lower case for relative
        {
            x += _lastPoint.x;
            y += _lastPoint.y;
        }

        return new PointF(x, y);
    }

    // Reflect _secondLastPoint over _lastPoint to get a new point for a smooth curve
    PointF reflect() {
        return new PointF(2 * _lastPoint.x - _secondLastPoint.x,
                          2 * _lastPoint.y - _secondLastPoint.y);
    }

    void ensureFigure() {
        if (!_figureStarted) {
            _context.beginFigure(_lastStart, IsFilled, !IsClosed);
            _figureStarted = true;
        }
    }

    public void parseToContext(GeometryContext context, String pathString, int startIndex) {
        _context = context;
        _pathString = pathString;
        _pathLength = pathString.length();
        _index = startIndex;

        _secondLastPoint = new PointF(0, 0);
        _lastPoint = new PointF(0, 0);
        _lastStart = new PointF(0, 0);

        _figureStarted = false;

        boolean first = true;
        char last_cmd = ' ';

        // Empty path is allowed
        while (this.readToken()) {
            char cmd = _token;

            if (first) {
                if ((cmd != 'M') && (cmd != 'm'))  // Path starts with M|m
                {
                    throw new RuntimeException("Invalid token: Path must start with M or m");
                }

                first = false;
            }

            switch (cmd) {
                case 'm': case 'M':
                    // XAML allows multiple points after M/m
                    _lastPoint = this.readPoint(cmd, !AllowComma);
                    context.beginFigure(_lastPoint, IsFilled, !IsClosed);
                    _figureStarted = true;
                    _lastStart = _lastPoint;
                    last_cmd = 'M';

                    while (this.isNumber(AllowComma)) {
                        _lastPoint = this.readPoint(cmd, !AllowComma);
                        context.lineTo(_lastPoint, IsStroked, !IsSmoothJoin);
                        last_cmd = 'L';
                    }
                    break;

                case 'l': case 'L':
                case 'h': case 'H':
                case 'v': case 'V':
                    this.ensureFigure();

                    do {
                        switch (cmd) {
                            case 'l': _lastPoint    = this.readPoint(cmd, !AllowComma); break;
                            case 'L': _lastPoint    = this.readPoint(cmd, !AllowComma); break;
                            case 'h': _lastPoint.x += this.readNumber(!AllowComma); break;
                            case 'H': _lastPoint.x  = this.readNumber(!AllowComma); break;
                            case 'v': _lastPoint.y += this.readNumber(!AllowComma); break;
                            case 'V': _lastPoint.y  = this.readNumber(!AllowComma); break;
                        }
                        context.lineTo(_lastPoint, IsStroked, ! IsSmoothJoin);
                    }
                    while (this.isNumber(AllowComma));

                    last_cmd = 'L';
                    break;

                case 'c': case 'C': // cubic Bezier
                case 's': case 'S': // smooth cublic Bezier
                    this.ensureFigure();

                    do {
                        PointF p;

                        if (cmd == 's' || cmd == 'S') {
                            if (last_cmd == 'C') {
                                p = this.reflect();
                            }
                            else {
                                p = _lastPoint;
                            }
                            _secondLastPoint = this.readPoint(cmd, !AllowComma);
                        }
                        else {
                            p = this.readPoint(cmd, !AllowComma);
                            _secondLastPoint = this.readPoint(cmd, AllowComma);
                        }

                        _lastPoint = this.readPoint(cmd, AllowComma);

                        context.bezierTo(p, _secondLastPoint, _lastPoint, IsStroked, ! IsSmoothJoin);

                        last_cmd = 'C';
                    }
                    while (this.isNumber(AllowComma));

                    break;

                case 'q': case 'Q': // quadratic Bezier
                case 't': case 'T': // smooth quadratic Bezier
                    this.ensureFigure();

                    do {
                        if (cmd == 't' || cmd == 'T') {
                            if (last_cmd == 'Q') {
                                _secondLastPoint = this.reflect();
                            }
                            else {
                                _secondLastPoint = _lastPoint;
                            }

                            _lastPoint = this.readPoint(cmd, !AllowComma);
                        }
                        else {
                            _secondLastPoint = this.readPoint(cmd, !AllowComma);
                            _lastPoint = this.readPoint(cmd, AllowComma);
                        }

                        context.quadraticBezierTo(_secondLastPoint, _lastPoint, IsStroked, ! IsSmoothJoin);

                        last_cmd = 'Q';
                    }
                    while (this.isNumber(AllowComma));

                    break;

                case 'a': case 'A':
                    this.ensureFigure();

                    do {
                        float w        = this.readNumber(!AllowComma);
                        float h        = this.readNumber(AllowComma);
                        float rotation = this.readNumber(AllowComma);
                        boolean large  = this.readBool();
                        boolean sweep  = this.readBool();

                        _lastPoint = this.readPoint(cmd, AllowComma);

                        context.arcTo(_lastPoint, new PointF(w, h), rotation, large,
                            sweep ? SweepDirection.Clockwise : SweepDirection.Counterclockwise,
                            IsStroked, !IsSmoothJoin);
                    }
                    while (this.isNumber(AllowComma));

                    last_cmd = 'A';
                    break;

                case 'z':
                case 'Z':
                    this.ensureFigure();
                    context.setClosedState(IsClosed);

                    _figureStarted = false;
                    last_cmd = 'Z';

                    _lastPoint = _lastStart; // Set reference point to be first point of current figure
                    break;

                default:
                    throw new RuntimeException("Invalid token");
            }
        }
    }
}
