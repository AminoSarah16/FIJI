/*prompts the user to open a directory with tiffs, where an enhanced image with both Bax and Bak channels is available.
 * User choses one ring and draws a line around it
 * the script then edits the selection to a 5pixel wide line, adds it to ROI manager
 * Then opens the corresponding raw data file
 * chooses Bax and Bak channels separately
 * draws a line profile of the selected structure from the ROI manager on the raw data files
 * saves the line profile as csv
 * also saves the ROI with the same name as the image file
 * Sarah Schweighofer, Mar 2022, MPINAT, Göttingen
*/


// choose source directory
filepath_obf = getDirectory("Choose_Source_Directory "); //CHOOSE THE LOCATION OF THE ORIGINAL HERE!
filepath = filepath_obf + "/tifs"
filelist = getFileList(filepath);

// choose save directory
// savepath = getDirectory("Choose_Destination_Directory ");

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	print(filename);
	
	//if you find your_string anywhere in the filename - user can change this to any string wanted
	your_string = "_merge.STED-enh2x.tiff.jpg";
	if(endsWith(filename, your_string)) {
		file = filepath + "/" + filename;
		print(file);
		open(file);
		title = getTitle();
	
		//select rings
		waitForUser("ROI", "Please select ROIs add them to the ROI manager (press t). Click OK when done.");
		
		// we apply the ROI from the ROI manager on the original raw data
		original_title = replace(filename, your_string, ".obf");
		original_file = filepath_obf + original_title;
		run("Bio-Formats Importer", "open=original_file autoscale color_mode=Default open_files open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		
		Bax = original_title + " - Bax.STED";
		
		Bak = original_title + " - Bak.STED";
		
		//now we look at the ROIs on the original image
		count = roiManager("count");		
		for (j = 0; j < count; j++) {
			//rename the ROIs
			roiManager("select", j);
			roiManager("Set Line Width", 4);
			roiManager("Rename", title+"ROI"+j+1); //i starts with 0 but we want to start counting with 1
			
			
			//look at the ROIs on the Bax image and plot profile and get values
			selectImage(Bax);
			roiManager("select", j);
			run("Plot Profile");
  			Bax_values = Plot.getValues(Bax_microns, Bax_intensities);
			
			//same for Bak
			selectImage(Bak);
			roiManager("select", j);
			run("Plot Profile");
  			Bax_values = Plot.getValues(Bak_microns, Bak_intensities);
			
			
			// add new table
			Table.create("line_profiles");
			// set a whole column
			Table.setColumn("Bax Intensities", Bax_intensities);
			// set another column
			Table.setColumn("Bak Intensities", Bak_intensities);
			
			saveAs("Results", "P:/Private/practice/quantification_of_imaging_experiments/manual_ring_quantification/Plot_Values_" + original_title + "_ROI" + j + ".csv");
			selectWindow("Plot_Values_" + original_title + "_ROI" + j+1 + ".csv"); 
         	run("Close" );
		}
		//now save the ROI set as zip so that it can be opened on the corresponding image again
		roiManager("Save", "P:/Private/practice/quantification_of_imaging_experiments/manual_ring_quantification/" + original_title + "RoiSet.zip");
		
		//clear the ROI manager
		selectWindow("ROI Manager"); 
        run("Close" );
		
		//close all open images
		close ("*");
	}
}