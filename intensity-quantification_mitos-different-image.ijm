/*takes a mito images, opens them, converts them to 8-bit, applies the mitochondria Analyzer plugin, inverts the binary image and analyzes the particles
 * then it opens the Mic60/cytC counterpart and analyses the intensity in this channel from the mask deducted from the Tom channel
 * then saves the results-table
 * Sarah Schweighofer, Jan 2022
*/


// choose source directory
filepath = getDirectory("Choose_Source_Directory "); //gets saved as dictionnary
filelist = getFileList(filepath);

savepath = getDirectory("Choose_Save_Directory ");

// savepath = getDirectory("Choose_Destination_Directory ");

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	//if you find your_string anywhere in the filename - user can change this to any string wanted
	your_string = ".*_3.*";
	if (matches(filename, your_string)) {	
		file = filepath + "/" + filename;
		open(file);
		title = getTitle();
		print(title);

		//need to convert to 8-bit
		run("8-bit");

		//Mitochondria Analyzer Plugin
		//C-Value of 2 is adjusted by user; default = 10
		run("2D Threshold", "subtract rolling=1.25 sigma enhance max=1.80 adjust gamma=0.80 method=[Weighted Mean] block=1.250 c-value=2 despeckle remove");

		//make sure the mito mask is forground
		run("Invert");

		run("Analyze Particles...", "size=0.20-Infinity show=Masks add");  //do not check options for display nor clear results table

		// in order to mark the cell area on the originally enhanced, we apply the ROI from the ROI manager on the enhanced image
		selectWindow(title);

		roiManager("Show All");
		// RoiManager.setPosition(0);
		

		
		roiManager("Set Color", "yellow");
		roiManager("Set Line Width", 2);
		

		
		run("Flatten");
		

		// and save it with the overlayed mask
		save_title = replace(title, ".tif", "_with-mask.tif");
		saveAs("Tiff", savepath + save_title);
		close ("*");


		//measure the intensity on the original 16-bit file
		open(file);
		roiManager("Combine");  //computation heavy!
		roiManager("add");
		count = roiManager("count");
		roiManager("select", count-1);
		run("Set Measurements...", "area mean modal min perimeter shape display redirect=None decimal=3");
		run("Measure");

		

		//open the second to-be-quantified image
		second_channel = replace(file, "_3", "_2");
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

Table.save(savepath + "results.csv","Results");	