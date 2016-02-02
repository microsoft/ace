function fullscreen_ui_init() {
    document.getElementById("navigateToProgrammaticGrid").addEventListener('click', navigateToProgrammaticGrid, false);

    // Global navigated handler:
    ace.addEventListener("navigated", function (root, url) {
        console.log("NAVIGATED: " + url);
        if (url == "ios://ios_sample.xib") {
            // So we have a back button:
            ace.Frame.showNavigationBar();
        }
    });

    // Global navigating handler:
    ace.addEventListener("navigating", function (oldContent, newContent) {
        console.log("NAVIGATING: " + oldContent + " -> " + newContent);
    });
}

function navigateToProgrammaticGrid() {
  var GRID_SIZE = 6;

  var grid = new ace.Grid();

  // Define the grid
  for (var i = 0; i < GRID_SIZE; i++) {
    var rd = new ace.RowDefinition();
    var cd = new ace.ColumnDefinition();
    grid.getRowDefinitions().add(rd);
    grid.getColumnDefinitions().add(cd);
  }

  // Add ToggleSwitches
  for (var i = 0; i < GRID_SIZE; i++) {
    for (var j = 0; j < GRID_SIZE; j++) {
      var ts = new ace.ToggleSwitch();
      if (i == j) {
        ts.setIsOn(true);
      }

      // Toggling any switch navigates backward
      ts.addEventListener("isonchanged", function() { ace.goBack(); });

      ace.Grid.setRow(ts, i);
      ace.Grid.setColumn(ts, j);
      grid.getChildren().add(ts);
    }
  }

  // Navigate to the Grid
  ace.navigate(grid);
}

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
