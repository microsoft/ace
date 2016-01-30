function overlay_ui_init() {
    document.getElementById("overlayXaml").addEventListener('click', toggleXamlButtons, false);
    document.getElementById("overlayJS").addEventListener('click', toggleJSButtons, false);
    document.getElementById("overlayPlatformSpecific").addEventListener('click', togglePlatformSpecificUI, false);
}

var popup1 = null;
var popup2 = null;
var popup3 = null;

function toggleXamlButtons() {
    if (popup1 == null) {
        popup1 = new ace.Popup();
        // Purposely overlap HTML to show off translucency
        popup1.setPosition(140, 0);
        popup1.setBackground("#4f00");

        // Load markup containing a StackPanel with Buttons
        ace.load("native://overlay-buttons.xaml", function (root) {
            // Place the root StackPanel inside the popup
            popup1.setContent(root);

            // Attach click event handlers to the Buttons,
            // leveraging fields generated for each name
            root.button1.addEventListener('click', function () { addButton(root); });
            root.button2.addEventListener('click', showFullscreenPopup);

            // Show the popup
            popup1.show();
        });
    }
    else {
        popup1.hide();
        popup1 = null;
    }
}

function toggleJSButtons() {
    if (popup2 == null) {
        popup2 = new ace.Popup();
        popup2.setPosition(5, 205);
        popup2.setBackground("#4f00");

        // Create the StackPanel and its Buttons
        var stackPanel = new ace.StackPanel();
        var button1 = new ace.Button();
        var button2 = new ace.Button();

        // Set the content of each Button
        button1.setContent("Add Button");
        button2.setContent("Show Fullscreen Popup");

        // Change the background colors
        button1.setBackground("#600f");
        button2.setBackground("#60f0");

        // Add the Buttons to the StackPanel
        stackPanel.getChildren().add(button1);
        stackPanel.getChildren().add(button2);

        // Place the root StackPanel inside the popup
        popup2.setContent(stackPanel);

        // Attach click event handlers to the Buttons
        button1.addEventListener('click', function () { addButton(stackPanel); });
        button2.addEventListener('click', showFullscreenPopup);

        // Show the popup
        popup2.show();
    }
    else {
        popup2.hide();
        popup2 = null;
    }
}

function togglePlatformSpecificUI() {
    if (popup3 == null) {
        popup3 = new ace.Popup();
        popup3.setPosition(140, 205);

        if (ace.platform == "iOS") {
            // Create a UISegmentedControl
            var uiSegmentedControl = new ace.NativeObject("UISegmentedControl");

            // Add four segments
            uiSegmentedControl.invoke("insertSegmentWithTitle:atIndex:animated:", "One", 0, false);
            uiSegmentedControl.invoke("insertSegmentWithTitle:atIndex:animated:", "Two", 1, false);
            uiSegmentedControl.invoke("insertSegmentWithTitle:atIndex:animated:", "Three", 2, false);
            uiSegmentedControl.invoke("insertSegmentWithTitle:atIndex:animated:", "Four", 3, false);

            // Select the last segment
            uiSegmentedControl.invoke("setSelectedSegmentIndex", 3);
            
            // Size the control
            uiSegmentedControl.invoke("sizeToFit");

            popup3.setContent(uiSegmentedControl);
        }
        else if (ace.platform == "Android") {

            // This is just like the cross-platform StackPanel and
            // Buttons, but done with raw Android controls

            // Create the LinearLayout and its Buttons
            var linearLayout = new ace.NativeObject("android.widget.LinearLayout");
            var button1 = new ace.NativeObject("android.widget.Button");
            var button2 = new ace.NativeObject("android.widget.Button");

            // Make the LinearLayout vertical rather than horizontal
            ace.NativeObject.getField("android.widget.LinearLayout", "VERTICAL", function (vertical) {
                linearLayout.invoke("setOrientation", vertical);

                // Set the text of each Button
                button1.invoke("setText", "Add Button");
                button2.invoke("setText", "Show Fullscreen Popup");

                // Change the background colors
                ace.NativeObject.invoke("android.graphics.Color", "parseColor", "#660000ff", function (color) {
                    ace.NativeObject.invoke("android.content.res.ColorStateList", "valueOf", color, function (tintList) {
                        button1.invoke("setBackgroundTintList", tintList);

                        ace.NativeObject.invoke("android.graphics.Color", "parseColor", "#6600ff00", function (color2) {
                            ace.NativeObject.invoke("android.content.res.ColorStateList", "valueOf", color2, function (tintList2) {
                                button2.invoke("setBackgroundTintList", tintList2);

                                // Add the Buttons to the LinearLayout
                                linearLayout.invoke("addView", button1);
                                linearLayout.invoke("addView", button2);
                            });
                        });

                    });
                });
            });

            // Place the root LinearLayout inside the popup
            popup3.setContent(linearLayout);

            // Attach click event handlers to the Buttons
            button1.addEventListener("setOnClickListener", function () { addAndroidButton(linearLayout); });
            button2.addEventListener("setOnClickListener", showFullscreenPopup);
        }

        // Show the popup
        popup3.show();
    }
    else {
        popup3.hide();
        popup3 = null;
    }
}

function addButton(stackPanel) {
    var b = new ace.Button();
    b.setContent("New Button");
    stackPanel.getChildren().add(b);
}

function addAndroidButton(linearLayout) {
    var b = new ace.Button();
    b.setContent("New Button");
    linearLayout.invoke("addView", b);
}

function showFullscreenPopup() {
    ace.load("native://overlay-buttons.xaml", function (root) {
        var popup = new ace.Popup();
        popup.setBackground("LemonChiffon");
        popup.setContent(root);
        popup.show();

        // Attach click event handlers to the Buttons,
        // leveraging fields generated for each name
        root.button1.addEventListener('click', function () { addButton(root); });
        root.button2.addEventListener('click', function () { popup.hide(); });

        // Modify the UI a bit
        root.button2.setContent("Hide");
    });
}
