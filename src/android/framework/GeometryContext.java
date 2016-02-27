//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.graphics.PointF;

public class GeometryContext {
    PathGeometry _pathGeometry;
    PathFigureCollection _figures;
    PathFigure _currentFigure;
    PathSegmentCollection _segments;
    boolean _currentIsClosed;

    SegmentType _currentSegmentType;
    PointCollection _currentSegmentPoints;
    boolean _currentSegmentIsStroked;
    boolean _currentSegmentIsSmoothJoin;

    FillRule s_defaultFillRule;
    boolean s_defaultValueForPathFigureIsClosed;
    boolean s_defaultValueForPathFigureIsFilled;
    PointF s_defaultValueForPathFigureStartPoint = new PointF(0, 0);
    boolean s_defaultValueForPathSegmentIsStroked;
    boolean s_defaultValueForPathSegmentIsSmoothJoin;
    boolean s_defaultValueForArcSegmentIsLargeArc;
    SweepDirection s_defaultValueForArcSegmentSweepDirection;
    double s_defaultValueForArcSegmentRotationAngle;

    public GeometryContext(Geometry g) {
        _pathGeometry = (PathGeometry)g;
    }

    public void close() {
        this.finishSegment();
    }

    void beginFigure(PointF startPoint, boolean isFilled, boolean isClosed) {
        // Is this the first figure?
        if (_currentFigure == null) {
            // If so, have we allocated the collection?
            if (_figures == null) {
                _figures = new PathFigureCollection(null);
                _pathGeometry.figures = _figures;
            }
        }

        this.finishSegment();

        // Clear the old reference to the segment collection
        _segments = null;

        _currentFigure = new PathFigure();
        _currentIsClosed = isClosed;

        if (startPoint.x != s_defaultValueForPathFigureStartPoint.x
         || startPoint.y != s_defaultValueForPathFigureStartPoint.y) {
            _currentFigure.setStartPoint(startPoint);
        }

        if (isClosed != s_defaultValueForPathFigureIsClosed) {
            _currentFigure.setIsClosed(isClosed);
        }

        if (isFilled != s_defaultValueForPathFigureIsFilled) {
            _currentFigure.setIsFilled(isFilled);
        }

        _figures.add(_currentFigure);

        _currentSegmentType = SegmentType.None;
    }

    void lineTo(PointF point, boolean isStroked, boolean isSmoothJoin) {
        this.prepareToAddPoints(1, isStroked, isSmoothJoin, SegmentType.PolyLine);
        _currentSegmentPoints.add(point);
    }

    void quadraticBezierTo(PointF point1, PointF point2, boolean isStroked, boolean isSmoothJoin) {
        this.prepareToAddPoints(2, isStroked, isSmoothJoin, SegmentType.PolyQuadraticBezier);
        _currentSegmentPoints.add(point1);
        _currentSegmentPoints.add(point2);
    }

    void bezierTo(PointF point1, PointF point2, PointF point3,
                  boolean isStroked, boolean isSmoothJoin) {
        this.prepareToAddPoints(3, isStroked, isSmoothJoin, SegmentType.PolyBezier);
        _currentSegmentPoints.add(point1);
        _currentSegmentPoints.add(point2);
        _currentSegmentPoints.add(point3);
    }

    void polyLineTo(PointF[] points, boolean isStroked, boolean isSmoothJoin) {
        this.genericPolyTo(points, isStroked, isSmoothJoin, SegmentType.PolyLine);
    }

    void polyQuadraticBezierTo(PointF[] points, boolean isStroked, boolean isSmoothJoin) {
        this.genericPolyTo(points, isStroked, isSmoothJoin, SegmentType.PolyQuadraticBezier);
    }

    void polyBezierTo(PointF[] points, boolean isStroked, boolean isSmoothJoin) {
        this.genericPolyTo(points, isStroked, isSmoothJoin, SegmentType.PolyBezier);
    }

    void arcTo(PointF point, PointF size, double rotationAngle, boolean isLargeArc,
               SweepDirection sweepDirection, boolean isStroked, boolean isSmoothJoin) {
        this.finishSegment();

        // Is this the first segment?
        if (_segments == null) {
            _segments = new PathSegmentCollection(null);
            _currentFigure.setSegments(_segments);
        }

        ArcSegment segment = new ArcSegment();
        segment.setPoint(point);
        segment.setSize(size);

        if (isLargeArc != s_defaultValueForArcSegmentIsLargeArc) {
            segment.setIsLargeArc(isLargeArc);
        }

        if (sweepDirection != s_defaultValueForArcSegmentSweepDirection) {
            segment.setSweepDirection(sweepDirection);
        }

        if (rotationAngle != s_defaultValueForArcSegmentRotationAngle) {
            segment.setRotationAngle(rotationAngle);
        }

        if (isStroked != s_defaultValueForPathSegmentIsStroked) {
            segment.setIsStroked(isStroked);
        }

        if (isSmoothJoin != s_defaultValueForPathSegmentIsSmoothJoin) {
            segment.setIsSmoothJoin(isSmoothJoin);
        }

        _segments.add(segment);

        _currentSegmentType = SegmentType.Arc;
    }

    void setClosedState(boolean isClosed) {
        if (isClosed != _currentIsClosed) {
            _currentFigure.setIsClosed(isClosed);
            _currentIsClosed = isClosed;
        }
    }

    void setFigureCount(int figureCount) {
        // TODO: This ignores the count
        _figures = new PathFigureCollection(null);
        _pathGeometry.figures = _figures;
    }

    void SetSegmentCount(int segmentCount) {
        // TODO: This ignores the count
        _segments = new PathSegmentCollection(null);
        _currentFigure.setSegments(_segments);
    }

    void genericPolyTo(PointF[] points, boolean isStroked, boolean isSmoothJoin, SegmentType segmentType) {
        int count = points.length;
        this.prepareToAddPoints(count, isStroked, isSmoothJoin, segmentType);

        for (int i = 0; i < count; i++) {
            _currentSegmentPoints.add(points[i]);
        }
    }

    void prepareToAddPoints(int count, boolean isStroked, boolean isSmoothJoin, SegmentType segmentType) {
        if (_currentSegmentType != segmentType ||
            _currentSegmentIsStroked != isStroked ||
            _currentSegmentIsSmoothJoin != isSmoothJoin) {
            this.finishSegment();

            _currentSegmentType = segmentType;
            _currentSegmentIsStroked = isStroked;
            _currentSegmentIsSmoothJoin = isSmoothJoin;
        }

        if (_currentSegmentPoints == null) {
           _currentSegmentPoints = new PointCollection(null);
        }
    }

    void finishSegment() {
        if (_currentSegmentPoints != null) {
            int count = _currentSegmentPoints.size();

            // Is this the first segment?
            if (_segments == null) {
                _segments = new PathSegmentCollection(null);
                _currentFigure.setSegments(_segments);
            }

            PathSegment segment;

            switch (_currentSegmentType) {
                case PolyLine:
                    if (count == 1) {
                        LineSegment lSegment = new LineSegment();
                        lSegment.setPoint((PointF)_currentSegmentPoints.get(0));
                        segment = lSegment;
                    }
                    else {
                        PolyLineSegment pSegment = new PolyLineSegment();
                        pSegment.setPoints(_currentSegmentPoints);
                        segment = pSegment;
                    }
                    break;
                case PolyBezier:
                    if (count == 3) {
                        BezierSegment bSegment = new BezierSegment();
                        bSegment.setPoint1((PointF)_currentSegmentPoints.get(0));
                        bSegment.setPoint2((PointF)_currentSegmentPoints.get(1));
                        bSegment.setPoint3((PointF)_currentSegmentPoints.get(2));
                        segment = bSegment;
                    }
                    else {
                        PolyBezierSegment pSegment = new PolyBezierSegment();
                        pSegment.setPoints(_currentSegmentPoints);
                        segment = pSegment;
                    }
                    break;
                case PolyQuadraticBezier:
                    if (count == 2) {
                        QuadraticBezierSegment qSegment = new QuadraticBezierSegment();
                        qSegment.setPoint1((PointF)_currentSegmentPoints.get(0));
                        qSegment.setPoint2((PointF)_currentSegmentPoints.get(1));
                        segment = qSegment;
                    }
                    else {
                        PolyQuadraticBezierSegment pSegment = new PolyQuadraticBezierSegment();
                        pSegment.setPoints(_currentSegmentPoints);
                        segment = pSegment;
                    }
                    break;
                default:
                    segment = null;
                    break;
            }

            if (_currentSegmentIsStroked != s_defaultValueForPathSegmentIsStroked) {
                segment.setIsStroked(_currentSegmentIsStroked);
            }

            if (_currentSegmentIsSmoothJoin != s_defaultValueForPathSegmentIsSmoothJoin) {
                segment.setIsSmoothJoin(_currentSegmentIsSmoothJoin);
            }

            _segments.add(segment);

            _currentSegmentPoints = null;
            _currentSegmentType = SegmentType.None;
        }
    }
}
