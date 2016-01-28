function onDateChanged(picker) {
    // Display the date from the JavaScript Date object
    picker.findName("textBlock").setText(picker.getDate().toLocaleDateString());
}

function onTimeChanged(picker) {
    // Display the time from the JavaScript Date object
    picker.findName("textBlock").setText(picker.getTime().toLocaleTimeString());
}

function addToListBox(listBox) {
    // Add prime numbers
    var obj = new ace.NativeObject(ace.valueOn({ android: "mypackage.MyAlgorithm", ios: "MyAlgorithm" }));
    var collection = listBox.getItems();
    obj.invoke("setStartingNumber", 1000);
    for (var i = 0; i < 100; i++) {
        obj.invoke("getNextPrime", function (result) {
            collection.add(result);
        });
    }
}