//
// Defines a repository for XAML resources, such as styles, that your app uses.
//
function ResourceDictionary() {
    ace.Dictionary.call(this, "Windows.UI.Xaml.ResourceDictionary");
};

// Inheritance
ResourceDictionary.prototype = Object.create(ace.Dictionary.prototype);

module.exports = ResourceDictionary;
