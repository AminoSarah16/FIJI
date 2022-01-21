/*takes a pixel-classified image from Ilastik with two classes, opens it, binarizes it to 0 and 255 for FIJI and then analyzes particles to sum up the total area
 * Sarah Schweighofer, Dec 2021
*/


// choose source directory
filepath = getDirectory("Choose_Source_Directory "); //gets saved as dictionnary
filelist = getFileList(filepath);

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	//if you find your_string anywhere in the filename - user can change this to any string wanted
	your_string = ".*Segmentation.*";
	if (matches(filename, your_string)) {	
		file = filepath + "/" + filename;
		open(file);
		title = getTitle();
		print(title);
		setAutoThreshold("Default");
		run("Threshold...");
		setThreshold(0, 1);
		setOption("BlackBackground", false);
		run("Convert to Mask");
		run("Erode");
		run("Fill Holes");
		run("Erode");
		run("Dilate");
		run("Erode");
		run("Erode");

		// to get the final title simply replace the original channel-name with whatever
		save_title = replace(title, ".tiff", "_mask.tiff");
		saveAs("Tiff", filepath + save_title);
		
		run("Analyze Particles...", "display clear include summarize add in_situ");


		// in order to mark the cell area on the originally enhanced, we apply the ROI from the ROI manager on the enhanced image
		original = replace(file, "_Simple Segmentation.tiff", ".tif");
		open(original);
		title2 = getTitle();

		roiManager("Show All");
		// RoiManager.setPosition(0);
		roiManager("Set Color", "yellow");
		roiManager("Set Line Width", 2);
		run("Flatten");

		// and save it with the overlayed mask
		save_title2 = replace(title2, ".tif", "_with-mask.tif");
		saveAs("Tiff", filepath + save_title2);
		
		close ("*");
	}		
	
}
Table.save(filepath + "Summary_cell-area.csv","Summary");	