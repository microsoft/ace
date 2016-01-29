function docked_ui_init() {
    document.getElementById("dockTabs").addEventListener('click', dockTabs, false);
    document.getElementById("dockGrid").addEventListener('click', dockGrid, false);
    document.getElementById("dockRestore").addEventListener('click', dockRestore, false);
}

function dockTabs() {
    // Surround the WebView with native UI
    ace.load("native://docked-tabs.xaml", function (page) {
        // Replace the WebView with the loaded native page
        // (For the title setting in XAML to work on Android, ShowTitle must be
        //  set to true in the Android section of config.xml.)
        ace.getHostPage().setContent(page);

        // Reparent the WebView inside the native page
        page.setContent(ace.getHostWebView());

        // Save the native page so we can set its title as tabs are clicked
        _nativePage = page;
    });
}

function dockGrid() {
    // Surround the WebView with native UI
    ace.load("native://docked-grid.xaml", function (grid) {
        // Replace the WebView with the loaded Grid
        ace.getHostPage().setContent(grid);

        var webView = ace.getHostWebView();

        webView.remove(function () {
            // Place the WebView inside the Grid
            ace.Grid.setRow(webView, 1);
            ace.Grid.setColumn(webView, 1);
            grid.getChildren().add(webView);
        });
    });
}

function dockRestore() {
    // Reset the content to a fullscreen WebView
    ace.getHostPage().setContent(ace.getHostWebView());
}

function onTabClick(tab, index) {
    // Update the page title
    _nativePage.setTitle(tab.getLabel());

    // Show the correct HTML based on the native tab click
    for (var i = 0; i < 5; i++) {
        if (i == index) {
            document.getElementById("div-" + i).style.display = "block";
        }
        else {
            document.getElementById("div-" + i).style.display = "none";
        }
    }
}
