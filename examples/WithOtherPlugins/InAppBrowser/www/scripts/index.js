var _nativePage;

function initializeUI() {
    //    
    // (1) Build the native UI in JavaScript rather than markup:
    //
    _nativePage = new ace.Page();
    var appbar = new ace.CommandBar();    
    var button1 = new ace.AppBarButton();
    var button2 = new ace.AppBarButton();
    var button3 = new ace.AppBarButton();

    // For the title setting to work on Android, ShowTitle must be
    // set to true in the Android section of config.xml.
    _nativePage.setTitle("Ace + InAppBrowser");

    button1.setLabel("Self");
    button2.setLabel("Dialog");
    button3.setLabel("System");
    
    button1.addEventListener("click", function() { onButtonClick(0); });
    button2.addEventListener("click", function() { onButtonClick(1); });
    button3.addEventListener("click", function() { onButtonClick(2); });
    
    appbar.getPrimaryCommands().add(button1);
    appbar.getPrimaryCommands().add(button2);
    appbar.getPrimaryCommands().add(button3);
    
    _nativePage.setBottomAppBar(appbar);
    
    //    
    // (2) Surround the WebView with native UI:
    //

    // Replace the WebView with the loaded native page
    ace.getHostPage().setContent(_nativePage);

    // Reparent the WebView inside the native page
    _nativePage.setContent(ace.getHostWebView());
}

function onButtonClick(index) {
    if (index == 0) {
        // Update the page title
        _nativePage.setTitle("You've unloaded your JavaScript!");
        
        // Open in the Cordova WebView (if the whitelist allows it)
        cordova.InAppBrowser.open('http://ace.run', '_self');
    }
    else if (index == 1) {
        // Open "on top" of the existing UI
        cordova.InAppBrowser.open('http://ace.run', '_blank');
        
        // Give the dialog a chance to be created    
        setTimeout(function () {
            if (ace.platform == "iOS") {
                // Grab the InAppBrowser from the displayed modal dialog
                var inappbrowser = ace.ios.getCurrentModalContent();

                // Build some native UI
                var grid = buildSecondNativePage();

                // Place the InAppBrowser inside the native UI
                ace.Grid.setRow(inappbrowser, 1);
                ace.Grid.setColumn(inappbrowser, 1);
                grid.getChildren().add(inappbrowser);

                // Replace the modal content with the new native content
                ace.ios.setCurrentModalContent(grid);
            }
            else if (ace.platform == "Android") {
                // Grab the InAppBrowser plugin class
                ace.external.getPluginAsync("InAppBrowser", function (inappbrowser) {
                    // This Java class has a dialog private field (at least currently!)
                    inappbrowser.getPrivateField("dialog", function (dialog) {

                        // Build some native UI
                        var grid = buildSecondNativePage();

                        // Grab one of the Android views by its id, 
                        // then traverse up to the root view (specific to this plugin)
                        dialog.invoke("findViewById", 1, function (actionButtonContainer) {
                            actionButtonContainer.invoke("getParent", function (toolbar) {
                                toolbar.invoke("getParent", function (mainView) {
                                    // Replace the modal content with the new native content
                                    dialog.invoke("setContentView", grid);

                                    // Place the old root view inside the native UI
                                    ace.Grid.setRow(mainView, 1);
                                    ace.Grid.setColumn(mainView, 1);
                                    grid.getChildren().add(mainView);
                                });
                            });
                        });
                    });
                });
            }
        }, 0);
    }
    else if (index == 2) {
        // Open with the system's web browser (leaving this app)
        cordova.InAppBrowser.open('http://ace.run', '_system');
    }
}

function buildSecondNativePage() {
    // Build a 3x3 grid
    var grid = new ace.Grid();

    // Only seen on Android, due to internal button margins
    grid.setBackground("purple");

    for (var r = 0; r < 3; r++) {

        // Define each row, with the middle one 3x as tall
        var rowDef = new ace.RowDefinition();
        rowDef.setHeight(r == 1 ? "3*" : "*");
        grid.getRowDefinitions().add(rowDef);

        for (var c = 0; c < 3; c++) {

            if (r == 0) {
                // Define each column, with the middle one 3x as wide
                var colDef = new ace.ColumnDefinition();
                colDef.setWidth(c == 1 ? "3*" : "*");
                grid.getColumnDefinitions().add(colDef);
            }            

            // Put a button in all cells except the middle one
            if (r != 1 || c != 1) {
                var b = new ace.Button();
                b.setContent("[" + r + "," + c + "]");
                b.setBackground("orange");
                ace.Grid.setRow(b, r);
                ace.Grid.setColumn(b, c);
                grid.getChildren().add(b);
            }
        }
    }
    
    return grid;
}

// To debug code on page load in Ripple or on Android devices/emulators: launch your app, set breakpoints,
// and then run "window.location.reload()" in the JavaScript Console.
(function () {
    "use strict";

    document.addEventListener( 'deviceready', onDeviceReady.bind( this ), false );

    function onDeviceReady() {
        // Handle the Cordova pause and resume events
        document.addEventListener( 'pause', onPause.bind( this ), false );
        document.addEventListener( 'resume', onResume.bind( this ), false );

        // Cordova has been loaded. Perform any initialization that requires Cordova here.
        initializeUI();
    };

    function onPause() {
        // This application has been suspended. Save application state here.
    };

    function onResume() {
        // This application has been reactivated. Restore application state here.
    };
} )();
