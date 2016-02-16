//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.view.View;
import android.widget.FrameLayout;
import java.util.ArrayList;
import run.ace.*;

public class Grid extends FrameLayout implements IHaveProperties, IRecieveCollectionChanges {
    public static final int RowProperty = 2;
    public static final int ColumnProperty = 3;
    public static final int RowSpanProperty = 4;
    public static final int ColumnSpanProperty = 5;

	UIElementCollection _children;
    RowDefinitionCollection _rowDefinitions;
    ColumnDefinitionCollection _columnDefinitions;

	public Grid(android.content.Context context) {
		super(context);
	}

	// IHaveProperties.setProperty
	public void setProperty(String propertyName, Object propertyValue) {
		if (!ViewGroupHelper.setProperty(this, propertyName, propertyValue)) {
			if (propertyName.equals("Panel.Children")) {
				if (propertyValue == null) {
					_children.removeListener(this);
					_children = null;
				}
				else {
					_children = (UIElementCollection)propertyValue;
					// Listen to collection changes
					_children.addListener(this);
				}
			}
			else if (propertyName.equals("Grid.RowDefinitions")) {
                _rowDefinitions = (RowDefinitionCollection)propertyValue;
            }
			else if (propertyName.equals("Grid.ColumnDefinitions")) {
                _columnDefinitions = (ColumnDefinitionCollection)propertyValue;
            }
			else {
				throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
			}
		}
	}

	// IRecieveCollectionChanges.add
	public void add(Object collection, Object item) {
		assert collection == _children;
        // TODO: Buttons are always on top :(
		this.addView((View)item);
	}

	// IRecieveCollectionChanges.removeAt
	public void removeAt(Object collection, int index) {
		assert collection == _children;
		this.removeViewAt(index);
	}

    public static int GetRow(View element) {
        return (Integer)Utils.getTag(element, "grid_rowproperty", 0);
    }

    public static int GetColumn(View element) {
        return (Integer)Utils.getTag(element, "grid_columnproperty", 0);
    }

    public static int GetRowSpan(View element) {
        return (Integer)Utils.getTag(element, "grid_rowspanproperty", 1);
    }

    public static int GetColumnSpan(View element) {
        return (Integer)Utils.getTag(element, "grid_columnspanproperty", 1);
    }

    @Override
    protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
        int numRows = this._rowDefinitions == null ? 0 : this._rowDefinitions.size();
        int numCols = this._columnDefinitions == null ? 0 : this._columnDefinitions.size();

        double totalStarHeight = bottom - top;
        double numStarHeightChunks = 0;
        double totalStarWidth = right - left;
        double numStarWidthChunks = 0;

        UIElementCollection children = this._children;

        if (children == null) {
            return;
        }

        int count = children.size();

        // First get actual child sizes for the sake of Auto rows and columns
        ArrayList<Integer> rowAutoHeights = null;
        ArrayList<Integer> colAutoWidths = null;

        if (count > 0) {
            if (numRows > 0) {
                rowAutoHeights = new ArrayList(numRows);
                for (int i = 0; i < numRows; i++) {
                    rowAutoHeights.add(0);
                }

                for (int i = 0; i < count; i++) {
                    View child = (View)children.get(i);
                    if (child != null && child.getVisibility() != GONE) {
                        int rowSpan = Grid.GetRowSpan(child);
                        rowSpan = Math.max(1, rowSpan);
                        if (rowSpan == 1) {
                            int row = Math.min(Grid.GetRow(child), numRows - 1);
                            int h = rowAutoHeights.get(row);
                            //TODO: Shouldn't this be MAX(h, ...height)?
                            rowAutoHeights.set(row, h + child.getMeasuredHeight());
                        }
                    }
                }
            }
            if (numCols > 0) {
                colAutoWidths = new ArrayList(numCols);
                for (int i = 0; i < numCols; i++) {
                    colAutoWidths.add(0);
                }

                for (int i = 0; i < count; i++) {
                    View child = (View)children.get(i);
                    if (child != null && child.getVisibility() != GONE) {
                        int colSpan = Grid.GetColumnSpan(child);
                        colSpan = Math.max(1, colSpan);
                        if (colSpan == 1) {
                            int col = Math.min(Grid.GetColumn(child), numCols - 1);
                            int w = colAutoWidths.get(col);
                            //TODO: Shouldn't this be MAX(w, ...width)?
                            colAutoWidths.set(col, w + child.getMeasuredWidth());
                        }
                    }
                }
            }
        }

        // Now calculate pixel and auto sizes, and see how many chunks we need to divide * into
        for (int i = 0; i < numRows; i++) {
            RowDefinition rd = (RowDefinition) this._rowDefinitions.get(i);
            if (rd.Height == null) {
                numStarHeightChunks += 1;
            }
            else if (rd.Height.type == GridUnitType.Star) {
                numStarHeightChunks += rd.Height.gridValue;
            }
            else if (rd.Height.type == GridUnitType.Pixel) {
                rd.CalculatedHeight = rd.Height.gridValue;
                totalStarHeight -= rd.CalculatedHeight;
            }
            else // if (rd.Height.type == GridUnitType.Auto)
            {
                if (rowAutoHeights != null) {
                    rd.CalculatedHeight = rowAutoHeights.get(i);
                }
                else {
                    rd.CalculatedHeight = 0;
                }
                totalStarHeight -= rd.CalculatedHeight;
            }
        }
        for (int i = 0; i < numCols; i++) {
            ColumnDefinition cd = (ColumnDefinition) this._columnDefinitions.get(i);
            if (cd.Width == null) {
                numStarWidthChunks += 1;
            }
            else if (cd.Width.type == GridUnitType.Star) {
                numStarWidthChunks += cd.Width.gridValue;
            }
            else if (cd.Width.type == GridUnitType.Pixel) {
                cd.CalculatedWidth = cd.Width.gridValue;
                totalStarWidth -= cd.CalculatedWidth;
            }
            else // if (cd.Width.type == GridUnitType.Auto)
            {
                if (colAutoWidths != null) {
                    cd.CalculatedWidth = colAutoWidths.get(i);
                } else {
                    cd.CalculatedWidth = 0;
                }
                totalStarWidth -= cd.CalculatedWidth;
            }
        }

        // Now divvy up the star chunks and calculate positions
        {
            double starHeight = totalStarHeight / numStarHeightChunks;
            double currentTop = 0;
            for (int i = 0; i < numRows; i++) {
                RowDefinition rd = (RowDefinition) this._rowDefinitions.get(i);
                if (rd.Height == null) {
                    rd.CalculatedHeight = 1 * starHeight;
                } else if (rd.Height.type == GridUnitType.Star) {
                    rd.CalculatedHeight = rd.Height.gridValue * starHeight;
                }

                rd.CalculatedTop = currentTop;
                currentTop += rd.CalculatedHeight;
            }
        }
        {
            double starWidth = totalStarWidth / numStarWidthChunks;
            double currentLeft = 0;
            for (int i = 0; i < numCols; i++) {
                ColumnDefinition cd = (ColumnDefinition) this._columnDefinitions.get(i);
                if (cd.Width == null) {
                    cd.CalculatedWidth = 1 * starWidth;
                } else if (cd.Width.type == GridUnitType.Star) {
                    cd.CalculatedWidth = cd.Width.gridValue * starWidth;
                }

                cd.CalculatedLeft = currentLeft;
                currentLeft += cd.CalculatedWidth;
            }
        }

        // Now place the children
        for (int i = 0; i < count; i++) {
            View child = (View)children.get(i);
            if (child != null) {
                double finalLeft = 0;
                double finalTop = 0;
                double finalWidth = 0;
                double finalHeight = 0;

                int rowSpan = Grid.GetRowSpan(child);
                rowSpan = Math.max(1, rowSpan);
                if (numRows == 0)
                    rowSpan = 1;

                for (int span = 0; span < rowSpan; span++) {
                    RowDefinition rd;
                    if (numRows > 0) {
                        int row = Math.min(Grid.GetRow(child), numRows - 1);

                        // Guard against nonsense spans that are too big
                        if (row + span >= numRows)
                            break;
                        rd = (RowDefinition) this._rowDefinitions.get(row + span);
                    }
                    else {
                        rd = new RowDefinition();
                        rd.CalculatedHeight = bottom - top;
                        rd.CalculatedTop = 0;
                    }

                    finalHeight += rd.CalculatedHeight;
                    if (span == 0)
                        finalTop = rd.CalculatedTop;
                }

                int colSpan = Grid.GetColumnSpan(child);
                colSpan = Math.max(1, colSpan);
                if (numCols == 0)
                    colSpan = 1;

                for (int span = 0; span < colSpan; span++) {
                    ColumnDefinition cd;
                    if (numCols > 0) {
                        int column = Math.min(Grid.GetColumn(child), numCols - 1);

                        // Guard against nonsense spans that are too big
                        if (column + span >= numCols)
                            break;
                        cd = (ColumnDefinition) this._columnDefinitions.get(column);
                    }
                    else {
                        cd = new ColumnDefinition();
                        cd.CalculatedWidth = right - left;
                        cd.CalculatedLeft = 0;
                    }

                    finalWidth += cd.CalculatedWidth;
                    if (span == 0)
                        finalLeft = cd.CalculatedLeft;
                }

                // Place the child
                child.layout((int)finalLeft, (int)finalTop, (int)(finalLeft + finalWidth), (int)(finalTop + finalHeight));
            }
        }
    }
}
