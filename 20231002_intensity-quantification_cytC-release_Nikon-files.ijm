/*takes 16-bit tiffs of mitchonrial Tom20 stain, exported from .nd2 image format.
 * opens them, converts them to 8-bit, applies the mitochondria Analyzer plugin, inverts the binary image and analyzes the particles
 * whihc is the Tom20 intensity
 * then it opens the Mic60/cytC counterpart and analyses the intensity in this channel from the mask deducted from the Tom channel
 * then saves the results-table
 * for paper revision to show that after 18h there is really cytC release
 * Sarah Schweighofer, Oct 2023
 * 
 * use with P:\Private\practice\quantification_of_imaging_experiments\cytC-release-under-Act+ABT737-treat\test\test
*/


// choose source directory
filepath = getDirectory("Choose_Source_Directory "); //gets saved as dictionnary
filelist = getFileList(filepath);

savepath = getDirectory("Choose_Save_Directory ");

// savepath = getDirectory("Choose_Destination_Directory ");

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	//if you find your_string anywhere in the filename - user can change this to any string wanted
	// should be the Tom channel
	//your_string = ".*_3.*";
	your_string = ".*_Tom.*";
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
		
		//waitForUser;

		////make sure the mito mask is forground
		//run("Invert");
		//waitForUser;

		run("Analyze Particles...", "size=0.20-Infinity show=Masks add");  //do not check options for display nor clear results table

		//waitForUser;

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


		//measure the intensity on the original 16-bit file
		open(file);
		roiManager("select", count-1);

		run("Set Measurements...", "area mean modal min perimeter shape display redirect=None decimal=3");
		run("Measure");

		

		//open the second to-be-quantified image
		// change according to the naming of the channels
		//second_channel = replace(file, "_3", "_2");
		second_channel = replace(file, "_Tom", "_cytC");
		open(second_channel);
		title2 = getTitle();
		print(title2);

		roiManager("select", count-1);
		//run("Set Measurements...", "area mean modal min perimeter shape display redirect=None decimal=3");
		run("Measure");
		
		//waitForUser;
		
		// and save it with the overlayed mask
		selectWindow(title2);
		//need to convert to 8-bit
		run("8-bit");
		
		// and save it with the overlayed mask
		save_title3 = replace(title2, ".tif", "_with-mask.tiff");
		saveAs("Tiff", savepath + save_title3);
		
		run("Flatten");
		// and save it with the overlayed mask flattened
		save_title4 = replace(title2, ".tif", "_with-mask_flat.tif");
		saveAs("Tiff", savepath + save_title4);
		
		//close all images
		close ("*");
		
		//select all ROIs and clear them
		roiManager("Select All");
		roiManager("delete");

	}
}

Table.save(savepath + "results.csv","Results");	