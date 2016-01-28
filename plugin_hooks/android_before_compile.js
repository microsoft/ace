var path = require('path');
var fs = require('fs-extra');

module.exports = function (context) {
    // Find the destination folder, which has a dynamic name (packagename-build).
	var dest = path.join(__dirname, '../../../platforms/android');

    // TODO: This was copying to a distinct spot, but that causes problems.
    //       By copying to the same spot as the rest of the code, however,
    //       we need to do extra work to get rid of stale files.
    //       Or perhaps we can delete everything with the right hook, and
    //       the necessary files will get copied back.
    
    // See if the app has native android files
	var nativeAndroidAppFolder = path.join(__dirname, '../../../native/android');

	try {
		fs.accessSync(nativeAndroidAppFolder, fs.R_OK);
	}
	catch (ex) {
		// The folder doesn't exist or is not accessible
		return;
	}

    // Do the copy
	fs.copySync(nativeAndroidAppFolder, dest);
};
