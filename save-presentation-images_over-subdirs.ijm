/* This script takes a merged tiff file with specified name ending, opens it, let's the user choose a crop, saves the crop as ROI and the original with the ROI marked
 * Sarah V. Schweighofer, MPIBPC January 2022
 */


// choose source directory
SourceDir = getDirectory("Choose Source Directory ");
// filepath = "P:/Private/practice/imaging/IF/IF79_BaxK-on-WT_Bcl2-sampler/IF79_STEDycon/obfs_only/"; //this needs to be changed and needs to have backslash at the end!
subDirlist = getFileList(SourceDir);

namepart1 = "merge.tif" // the image which is opened first - cytC or Tom20; in any case the confocal channel

for (i = 0; i < subDirlist.length; i++) {
	subdir = SourceDir + subDirlist[i] + "renamed/" + "tifs/";
	print(subdir);
	filelist = getFileList(subdir);
	for (j = 0; j < filelist.length; j++) {
		filename = filelist [j];
		
	
		if(endsWith(filename, namepart1)) {
			open(subdir + "/" + filename);
			title = getTitle();
			print(title);

			// set the right pixel size - here 15nm
			run("Set Scale...", "distance=5333 known=80 unit=µm global");

			//makeRectangle(1542, 342, 2502, 2370);
			waitForUser;

			roiManager("Add");

			run("Duplicate...", "duplicate");

			}
		// break
	}
}

			
