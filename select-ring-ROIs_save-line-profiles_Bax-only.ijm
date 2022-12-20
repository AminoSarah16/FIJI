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
savepath = "P:/Private/practice/quantification_of_imaging_experiments/manual_ring_quantification/"

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	print(filename);
	
	//if you find your_string anywhere in the filename - user can change this to any string wanted
	your_string = "_BaxK.STED_BG-20._enh99.9_Gauss2.tiff";
	if(endsWith(filename, your_string)) {
		file = filepath + "/" + filename;
		print(file);
		open(file);
		title = getTitle();
			
		//select rings
		waitForUser("ROI", "Please select freehand tool and draw ROIs. Then add them to the ROI manager by pressing t. Click OK when done.");
		
		// open the original raw data
		original_title = replace(filename, your_string, ".obf");
		original_file = filepath_obf + original_title;
		run("Bio-Formats Importer", "open=original_file autoscale color_mode=Default open_files open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		
		Bax = original_title + " - BaxK.STED";
		
//		Bak = original_title + " - Bak.STED";
//		
		//now we look at the ROIs on the original images
		count = roiManager("count");
		
		//only if user chose at least one ROI, we want to execute the following code:
		if(count > 0) {		
			for (j = 0; j < count; j++) {
				//rename the ROIs
				roiManager("select", j);
				roiManager("Set Line Width", 5);
				roiManager("Rename", title+"ROI"+j+1); //i starts with 0 but we want to start counting with 1
				
				
				//look at the ROIs on the Bax image and plot profile and get values
				selectImage(Bax);
				roiManager("select", j);
				run("Plot Profile");
	  			Bax_values = Plot.getValues(Bax_microns, Bax_intensities);
				
//				//same for Bak
//				selectImage(Bak);
//				roiManager("select", j);
//				run("Plot Profile");
//	  			Bax_values = Plot.getValues(Bak_microns, Bak_intensities);
				
				
				// create new results table
				Table.create("line_profiles");
				// set length column
				Table.setColumn("µm", Bax_microns);
				// set Bax column
				Table.setColumn("Bax Intensities", Bax_intensities);
//				// set Bak column
//				Table.setColumn("Bak Intensities", Bak_intensities);
				
				saveAs("Results", savepath + "Plot_Values_" + original_title + "_ROI" + j+1 + ".csv");
				selectWindow("Plot_Values_" + original_title + "_ROI" + j+1 + ".csv"); 
	         	//close the table
	         	run("Close" );
	         	
	         	//save the ROI in its boundingbox as jpg
	         	selectImage(title);
	         	roiManager("select", j);
				roiManager("Set Line Width", 30);
				run("To Bounding Box");
				run("Duplicate...", "duplicate");
				// save ROIs as is
				save_title = replace(title, ".tif", "_ROI" + j+1 + ".jpg");  //i starts with 0 but we want to start counting with 1
				saveAs("Jpeg", savepath + save_title);
				
				// in order to save the ROIs with their original line width I need to set it back
				roiManager("select", j);
				roiManager("Set Line Width", 5);
			}
			
			//now save the ROI set as zip so that it can be opened on the corresponding image again
			roiManager("Save", savepath + original_title + "RoiSet.zip");
			
			//clear the ROI manager
			selectWindow("ROI Manager");
			run("Close" );
		}
		
		
		//close all open images
		close ("*");
	}
}