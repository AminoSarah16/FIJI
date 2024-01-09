/*takes 16-bit tiffs of treated cells, exported from .nd2 image format.
 * opens them, converts them to 8-bit, applies a threshold to nuclei on the cytC channel, where it is super bright (monnlighting function of cytC!)
 * then applyies mitochondria Analyzer plugin on Tom channel, inverts the binary image and analyzes the particles
 * then combines the two ROIs to exclude the analysis of mitos locate on these bright nuclei
 * then it opens both channels in 16-bit and analyses the intensity in the newly created ROI
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
	your_string = ".*_cytC.*";
	if (matches(filename, your_string)) {	
		file = filepath + "/" + filename;
		open(file);
		title = getTitle();
		print(title);

		//need to convert to 8-bit
		run("8-bit");

		// now threshold on the nuclei
		print("I am thresholding the nuclei");
		setThreshold(180, 255);
		setOption("BlackBackground", true);
		run("Convert to Mask");
		
		//waitForUser;

		run("Analyze Particles...", "size=0.20-Infinity show=Masks add");
		run("Invert LUT");
		run("Fill Holes");
		
		
		//combine all ROIs of nuclei to one and add as separate ROI to manager, then select only this last one
		roiManager("Combine");  //computation heavy!
		roiManager("add");
		count = roiManager("count");

		roiManager("Show None");
		roiManager("select", count-1);

		//waitForUser;
		
		roiManager("Set Color", "yellow");
		roiManager("Set Line Width", 2);
		//save ROI
		nuclei_roi_title = replace(title, ".tif", "nuclei_roi.roi");
		nuclei_roi_savepath = savepath + nuclei_roi_title;
		roiManager("Save", nuclei_roi_savepath);
		print("I have saved the nuclei ROI");
		
		//select all ROIs and clear them
		roiManager("Select All");
		roiManager("delete");
		
		//waitForUser;
		
		//open the second to-be-quantified image
		// change according to the naming of the channels
		//second_channel = replace(file, "_3", "_2");
		second_channel = replace(file, "_cytC", "_Tom");
		open(second_channel);
		title2 = getTitle();
		print(title2);
		
		//need to convert to 8-bit
		run("8-bit");
		
		//Mitochondria Analyzer Plugin
		print("I am applying the mito analyzer");
		//C-Value of 2 is adjusted by user; default = 10
		//run("2D Threshold", "subtract rolling=1.25 sigma enhance max=1.80 adjust gamma=0.80 method=[Weighted Mean] block=1.250 c-value=2 despeckle remove");
		// for IF86_spl01:
		run("2D Threshold", "subtract rolling=3 sigma radius=0.50 enhance max=1.80 adjust gamma=0.80 method=[Weighted Mean] block=3 c-value=0.5 despeckle remove outlier=0.5");
		
		//waitForUser;

		////make sure the mito mask is forground
		//run("Invert");
		//waitForUser;

		run("Analyze Particles...", "size=0.20-Infinity show=Masks add");  //do not check options for display nor clear results table

		//waitForUser;

		//combine all ROIs to one and add as separate ROI to manager, then select only this last one
		print("I am combining all ROIs from the mito analyzer");
		roiManager("Combine");  //computation heavy!
		roiManager("add");
		count = roiManager("count");

		roiManager("Show None");
		roiManager("select", count-1);

		
		roiManager("Set Color", "yellow");
		roiManager("Set Line Width", 2);
		//save ROI
		mito_roi_title = replace(title2, ".tif", "mito_roi.roi");
		mito_roi_savepath = savepath + mito_roi_title;
		roiManager("Save", mito_roi_savepath);
		print("I have saved the mito ROI");
		//select all ROIs and clear them
		roiManager("Select All");
		roiManager("delete");
		
		//waitForUser;
		
		//now comine the two masks
		//so that only the mitochondria outside of the nucleus will be analyzed
		//open both rois and first make AND between total mito and nuclei
		// then make XOR with nuclear-mito and total mito
		roiManager("open", mito_roi_savepath);
		roiManager("open", nuclei_roi_savepath);
		
		//waitForUser;
		print("I am combining nuclei ROIs and the ones from the mito analyzer");
		roiManager("Select", newArray(0,1));
		roiManager("AND");
		roiManager("Add");
		roiManager("Select", newArray(0,2));
		roiManager("XOR");
		roiManager("Add");
		roiManager("select", 3);
		//waitForUser;
		//save ROI
		mito_no_nuc_roi_title = replace(title2, ".tif", "mito_no-nuc_roi.roi");
		mito_no_nuc_roi_savepath = savepath + mito_no_nuc_roi_title;
		roiManager("Save", mito_no_nuc_roi_savepath);
		print("I have saved the mito outside of nuclei ROI");
		//select all ROIs and clear them
		roiManager("Select All");
		roiManager("delete");
		
				
		print("I am done creating ROIs for this position");
		//close all images
		close ("*");
		
		//waitForUser;
		
		//measure the cytC intensity on the original 16-bit file
		open(file);
		title = getTitle();
		print(title);
		//open the created ROI and measure
		roiManager("open", mito_no_nuc_roi_savepath);
		roiManager("Select", mito_no_nuc_roi_savepath);
		waitForUser;
		run("Set Measurements...", "area mean modal min perimeter shape display redirect=None decimal=3");
		run("Measure");
		
		// and save channel with the overlayed mask
		selectWindow(title);
		save_title = replace(title, ".tif", "_with-mask.tiff");
		saveAs("Tiff", savepath + save_title);
		
		run("Flatten");
		// and save it with the overlayed mask flattened
		save_title2 = replace(title, ".tif", "_with-mask_flat.tif");
		saveAs("Tiff", savepath + save_title2);
		close ("*");

		//measure the Tom intensity on the original 16-bit file
		open(second_channel);
		title2 = getTitle();
		print(title2);
	
		//open the created ROI and measure
		roiManager("Select", mito_no_nuc_roi_savepath);
		waitForUser;
		run("Set Measurements...", "area mean modal min perimeter shape display redirect=None decimal=3");
		run("Measure");
		
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