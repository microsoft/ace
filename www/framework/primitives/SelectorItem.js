//
// A container for a selectable item.
//
function SelectorItem(nativeTypeName) {
    if (!nativeTypeName) {
        throw new Error("You should instantiate a subclass instead");
    }
    // The caller wants an arbitrary UIElement, but with the strongly-typed members from this class
    ace.UIElement.call(this, nativeTypeName);
};

// Inheritance
SelectorItem.prototype = Object.create(ace.ContentControl.prototype);

module.exports = SelectorItem;
