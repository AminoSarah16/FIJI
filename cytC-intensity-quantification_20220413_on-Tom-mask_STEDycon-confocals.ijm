/*takes a mito images, opens them, converts them to 8-bit, applies the mitochondria Analyzer plugin, inverts the binary image and analyzes the particles
 * then it opens the Mic60/cytC counterpart and analyses the intensity in this channel from the mask deducted from the Tom channel
 * then saves the results-table
 * Sarah Schweighofer, Jan 2022
*/


// choose source directory
SourceDir = getDirectory("Choose Source Directory ");
// filepath = "P:/Private/practice/imaging/IF/IF79_BaxK-on-WT_Bcl2-sampler/IF79_STEDycon/obfs_only/"; //this needs to be changed and needs to have backslash at the end!
subDirlist = getFileList(SourceDir);

savepath = getDirectory("Choose_Save_Directory ");

// savepath = getDirectory("Choose_Destination_Directory ");

for (i = 0; i < subDirlist.length; i++) {
	subdir = SourceDir + subDirlist[i];  //ATTENTION! NEED to change here where the subdir is located!
	print(subdir);
	filelist = getFileList(subdir);
	for (j = 0; j < filelist.length; j++) {
		filename = filelist [j];
		
	
		//if you find your_string anywhere in the filename - user can change this to any string wanted
		your_string = ".*_Tom.Confocal-enh2x.*";
		if (matches(filename, your_string)) {	
			file = subdir + "/" + filename;
			open(file);
			title = getTitle();
			print(title);
	
			//run an Otsu threshold with dark background and no range reset
			setAutoThreshold("Otsu dark no-reset");
			run("Convert to Mask");
			
	
			run("Analyze Particles...", "size=0.20-Infinity show=Masks add");  //do not check options for display nor clear results table
	
			// in order to mark the cell area on the image, we apply the ROI from the ROI manager on the enhanced image
			selectWindow(title);
	
	
			//combine all ROIs to one and add as separate ROI to manager, then select only this last one
			roiManager("Combine");  //computation heavy!
			roiManager("add");
			count = roiManager("count");
	
			roiManager("Show None");
			roiManager("select", count-1);
	
			
			roiManager("Set Color", "yellow");
			roiManager("Set Line Width", 2);
			
	
			// and save it with the overlayed mask
			save_title = replace(title, ".tif", "_with-mask.tiff");
			saveAs("Tiff", savepath + save_title);
			
			run("Flatten");
			// and save it with the overlayed mask flattened
			save_title2 = replace(title, ".tif", "_with-mask_flat.tif");
			saveAs("Tiff", savepath + save_title2);
			close ("*");
	//
	//
	//		//measure the intensity on the original file
	//		open(file);
	//		roiManager("select", count-1);
	//
	//		run("Set Measurements...", "area mean modal min perimeter shape display redirect=None decimal=3");
	//		run("Measure");
	
			
	
			//open the second to-be-quantified image
			second_channel = replace(file, "Tom.Confocal-enh2x.tiff", "cytC.Confocal.tiff");
			open(second_channel);
			title2 = getTitle();
			print(title2);
	
			roiManager("select", count-1);
			//run("Set Measurements...", "area mean modal min perimeter shape display redirect=None decimal=3");
			run("Measure");
	
			//close all images
			close ("*");
			
			//select all ROIs and clear them
			roiManager("Select All");
			roiManager("delete");
		}
	}
}

Table.save(savepath + "results.csv","Results");	