var path = require('path');

function copyAndroidFiles() {
    var fs = require('fs-extra');
    
    // Find the destination folder
	var dest = path.join(__dirname, '../../../../platforms/android');

    // TODO: This was copying to a distinct spot, but that causes problems.
    //       By copying to the same spot as the rest of the code, however,
    //       we need to do extra work to get rid of stale files.
    //       Or perhaps we can delete everything with the right hook, and
    //       the necessary files will get copied back.
    
    // See if the app has native android files
	var nativeAndroidAppFolder = path.join(__dirname, '../../../../native/android');

	try {
		fs.accessSync(nativeAndroidAppFolder, fs.R_OK);
	}
	catch (ex) {
		// The folder doesn't exist or is not accessible
		return;
	}

    // Do the copy
	fs.copySync(nativeAndroidAppFolder, dest);
}

module.exports = function (context) {
    var fs = require('fs');

    // Make sure the dependencies are installed
    try {
        var stats1 = fs.statSync(path.join(__dirname, '../../../../node_modules/fs-extra/package.json'));
        // Only relevant for iOS:
        // var stats2 = fs.statSync(path.join(__dirname, '../../../../node_modules/xcode/package.json'));
        
        // We're good.
        copyAndroidFiles();
        return;
    }
    catch (err) {
        // A dependency is not yet installed, so proceed.
    }

    // Execute 'npm install' on dependencies mentioned in the plugin's package.json.
    var Q = context.requireCordovaModule('q');
    var npm = context.requireCordovaModule('npm');

    var pkg = JSON.parse(fs.readFileSync(path.join(__dirname, '../../package.json'), 'utf-8'));

    // Load npm
    return Q.ninvoke(npm, 'load', {
        loaded: false
    }).then(function() {
        // Invoke npm install on each key@value
        return Q.ninvoke(npm.commands, 'install', Object.keys(pkg.dependencies).map(function(p) {
            return p + '@' + pkg.dependencies[p];
        }));
    }).then(function() {
        // We're good.
        copyAndroidFiles();
    });
};
