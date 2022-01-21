/* This script takes a tiff file with specified name ending and runs a rolling ball background subtraction
 * sigma can be adjusted by hard coding
 * Sarah V. Schweighofer, MPIBPC November 2021
 * !!! careful, the roll ball algorithm is quite computing heavy. so don't kill it, it just takes a while!!!
 */


// choose source directory
SourceDir = getDirectory("Choose Source Directory ");
// filepath = "P:/Private/practice/imaging/IF/IF79_BaxK-on-WT_Bcl2-sampler/IF79_STEDycon/obfs_only/"; //this needs to be changed and needs to have backslash at the end!
subDirlist = getFileList(SourceDir);

for (i = 0; i < subDirlist.length; i++) {
	subdir = SourceDir + subDirlist[i] + "renamed/" ;  //ATTENTION! NEED to change here where the subdir is located!
	print(subdir);
	filelist = getFileList(subdir);
	for (j = 0; j < filelist.length; j++) {
		filename = filelist [j];
	
		
		//change the name parts according to which of the images are supposed to be roll-balled
		// if two different channels are needed to be rollballed, choose both with:
			
		if(endsWith(filename, "Bax.STED.tiff") || endsWith(filename, "Bak.STED.tiff")) {
			
		// if only one channel needs to be rollballed, use this line:
		//if(endsWith(filename, "Tom20.STED.tiff")) {  
			
			//then it opens the image
			open(subdir + "/" + filename);
			title = getTitle();
			print(title);
	
			// runs the rolly bally; rolling=xx sets the sigma; sliding means that the structuring object is a sliding paraboloid
			radius = 20; // set your radius here in pixels
			run("Subtract Background...", "rolling=" + radius + " sliding");
	
			// the rollballed image gets saved with a new name
			save_title = replace(title, "STED", "STED_BG-20");  //BG for background and 20 for the sliding paraboloid size
			saveAs("Tiff", subdir + save_title);
			close ("*");
	
		}
	}
}
