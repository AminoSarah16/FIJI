/* This script takes a tiff file with specified name ending and runs a rolling ball background subtraction
 * sigma can be adjusted by hard coding
 * Sarah V. Schweighofer, MPIBPC October 2021
 * !!! careful, the roll ball algorithm is quite computing heavy. so don't kill it, it just takes a while!!!
 */


// change filepath and namepart
filepath = getDirectory("Choose Source Directory ");
filelist = getFileList(filepath);

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];

	//change the name parts according to which of the images are supposed to be roll-balled
	// if two different channels are needed to be rollballed, choose both with:
	if(endsWith(filename, "Bax.STED.tiff") || endsWith(filename, "Bak.STED.tiff") || endsWith(filename, "BaxK.STED.tiff")) {  
		
	// if only one channel needs to be rollballed, use this line:
	//if(endsWith(filename, "Tom20.STED.tiff")) {  
		open(filepath + "/" + filename);
		title = getTitle();
		print(title);

		// runs the rolly bally; rolling=xx sets the sigma; sliding means that the structuring object is a sliding paraboloid
		radius = 20; // set your radius here in pixels
		run("Subtract Background...", "rolling=" + radius + " sliding");

		// the rollballed image gets saved with a new name
		save_title = replace(title, "STED", "STED_BG-20");  //BG for background and 20 for the sliding paraboloid size
		saveAs("Tiff", filepath + save_title);
		close ("*");

	}
	// break
}
