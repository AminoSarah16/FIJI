/*takes images, opens them, and analyses the intensity outside of a given ROI
 * then saves the results-table
 * Sarah Schweighofer, Mar 2022
 * MPI-NAT, Göttingen
*/


// choose source directory
filepath = getDirectory("Choose_Source_Directory "); //gets saved as dictionnary
filelist = getFileList(filepath);

savepath = getDirectory("Choose_Save_Directory ");

// savepath = getDirectory("Choose_Destination_Directory ");

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	//if you find your_string anywhere in the filename - user can change this to any string wanted
	your_string = ".*_2.*";
	if (matches(filename, your_string)) {	
		file = filepath + "/" + filename;
		open(file);
		title = getTitle();
		print(title);


		//open theTom image with the mito mask, put the mask onto the cytC image and measrure the "Background"
		//open the second to-be-quantified image
		filename2 = replace(filename, "_2.tif", "_3_with-mask.tif");
		second_channel = filepath + "/output/" + filename2;
		open(second_channel);
		title2 = getTitle();
		print(title2);
		
	
		// inverts the ROI to take everything but the ROI as new ROI:
		run("Make Inverse");
		
		roiManager("add");
		
		//select the original again
		selectWindow(title);
		roiManager("Select", 0);
		waitForUser;
		
		run("Set Measurements...", "area mean modal min perimeter shape display redirect=None decimal=3");
		run("Measure");

		//close all images
		close ("*");
		//select all ROIs and clear them
		roiManager("Select All");
		roiManager("delete");
	}
}

Table.save(savepath + "results_cytC-background.csv","Results");	