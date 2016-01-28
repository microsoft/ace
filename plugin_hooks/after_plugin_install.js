var path = require('path');
var fs = require('fs');

module.exports = function (context) {
    // Install the plugin's dependencies, because this doesn't happen automatically outside of VS
    var Q = context.requireCordovaModule('q');
    var npm = context.requireCordovaModule('npm');

    var pkg = JSON.parse(fs.readFileSync(path.join(__dirname, '../package.json'), 'utf-8'));

    return Q.ninvoke(npm, 'load', {
        loaded: false
    }).then(function() {
        return Q.ninvoke(npm.commands, 'install', Object.keys(pkg.dependencies).map(function(p) {
            return p + '@' + pkg.dependencies[p];
        }));
    }).then(function() {
        var fsextra = require('fs-extra');
        var projectFolder = path.join(__dirname, '../../..');
        
        try {
            // Place initial native folders
            fsextra.ensureDirSync(path.join(projectFolder, "native/android/src"));
            fsextra.ensureDirSync(path.join(projectFolder, "native/android/res"));
            fsextra.ensureDirSync(path.join(projectFolder, "native/android/libs"));
            fsextra.ensureDirSync(path.join(projectFolder, "native/ios"));

            // Place initial iOS header file
            var iosHeaderDestFile = path.join(projectFolder, 'native/ios/CustomCode.h');

            try {
                fsextra.accessSync(iosHeaderDestFile, fsextra.R_OK);
                // The file already exists, so do nothing
            }
            catch (ex1) {
                // The file must not exist, so copy it
                var iosHeaderSrcFile = path.join(projectFolder, 'plugins/cordova-plugin-ace/src/ios/build/CustomCode.h');
                fsextra.copySync(iosHeaderSrcFile, iosHeaderDestFile);
            }    
        }
        catch (ex2) {
            // This is for convenience, so it's not a problem if it fails.
        }
    });
};
