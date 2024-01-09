/*opens large images with ubiquitin staining
 * applies no filters, then threshold between 230 to 255 px
 * then analyze particles from 2px to infinity
*/


// choose source directory
filepath = "P:/Private/practice/quantification_of_imaging_experiments/ubiquitin_in_apoptosis/rawdata";
//filepath = getDirectory("Choose_Source_Directory "); //gets saved as dictionnary
filelist = getFileList(filepath);

savepath = "P:/Private/practice/quantification_of_imaging_experiments/ubiquitin_in_apoptosis/results/";
// savepath = getDirectory("Choose_Save_Directory ");

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	//if you find your_string anywhere in the filename - user can change this to any string wanted
	// should be the Tom channel
	//your_string = ".*_3.*";
	your_string = ".*IF95.*";
	if (matches(filename, your_string)) {	
		file = filepath + "/" + filename;
		open(file);
		title = getTitle();
		print(title);

		channel1 = "Tom";
		channel2 = "ubiquitin";

		run("Split Channels");

		for (k = 1; k < 3; k++) {
			//when the image is split into its 3 channels, FIJI calls them C1 to C3. Now we need to save them
			if (k == 1) {
				selectWindow("C" + k + "-" + title);
				channelname1 = savepath + title + "_" + channel1;
				saveAs("Tiff", channelname1); // saves as multipage tiff
				close();
			}
			
			if (k == 2) {
				selectWindow("C" + k + "-" + title);
				channelname2 = savepath + title + "_" + channel2;
				saveAs("Tiff", savepath + title + "_" + channel2); // saves as multipage tiff

				//waitForUser;
				
				//now set the threshold on the ubiquitin channel;
				setThreshold(230, 255, "raw");
				setOption("BlackBackground", true);
				run("Convert to Mask");

				//waitForUser;

				run("Analyze Particles...", "size=2-Infinity pixel show=Masks add");  //do not check options for display nor clear results table

				//waitForUser;

				// in order to mark the ubi spots on the original image, we open the original
				open(channelname2 +".tif");
				title1 = getTitle();
				print(title1);
				//waitForUser;
				selectWindow(title1);
				//waitForUser;
				
				run("Set Measurements...", "area mean min perimeter fit shape area_fraction display redirect=None decimal=3");

				numROIs = roiManager("count");
				// loop through ROIs
				for(l=0; l<numROIs;l++) { 
					roiManager("Select", l);
					results=roiManager("Measure");
				}

				//waitForUser;

				// in order to apply the ROI from the ROI manager on the original ubi channel
				//combine all ROIs to one and add as separate ROI to manager, then select only this last one
				// first save ROI set
				roiManager("Select All");
				roi_set_title = replace(title1, ".tif", "rois.roi");
				roi_savepath = savepath + roi_set_title;
				roiManager("Save", roi_savepath);

				// now combine all ROIs into one
				roiManager("Select All");
				roiManager("Combine");  //computation heavy!
				roiManager("add");
				count = roiManager("count");

				//and select only this last one combined ROI
				roiManager("Show None");
				roiManager("select", count-1);
		
				// give this big combined ROI a yellow outline
				roiManager("Set Color", "yellow");
				roiManager("Set Line Width", 2);

				// and save it with the overlayed mask
				save_title = replace(title1, ".tif", "_with-mask.tiff");
				saveAs("Tiff", savepath + save_title);
				
				run("Flatten");
				// and save it with the overlayed mask flattened
				save_title2 = replace(title1, ".tif", "_with-mask_flat.tif");
				saveAs("Tiff", savepath + save_title2);

				//close all images
				close ("*");

				//select all ROIs and clear them
				roiManager("Select All");
				roiManager("delete");
				
				
				//close();
			}
		}
	}
}

Table.save(savepath + "results.csv","Results");

