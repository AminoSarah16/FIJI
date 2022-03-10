/* This script takes an already open multichannel tiff file, let's the user choose unlimited amount of crops, saves the crops as ROIs and the original with the ROI marked
 * Sarah V. Schweighofer, MPIBPC January 2022
 */


// choose save directory
savepath = getDirectory("Choose_Destination_Directory ");


title = getTitle();
print(title);

		
// set the right pixel size - here 15nm
run("Set Scale...", "distance=5333 known=80 unit=µm global");

//makeRectangle
waitForUser("ROI", "Please select ROIs add them to the ROI manager (press t). Tip: Hold Shift key while dragging in order for them to be square, but release and click anywhere in between to not combine the ROIs. You can also make sure that all the ROIs have the same size: Edit > Selection > Specify.Click OK when done.");

//now we duplicate every of the drawn rectangle
count = roiManager("count");		
for (i = 0; i < count; i++) {
	print(i);
	selectImage(title);
	//rename the ROIs
	roiManager("select", i);
	roiManager("Rename", "crop"+i+1); //i starts with 0 but we want to start counting with 1
	//crop the ROIs from the original
	run("Duplicate...", "duplicate");
	// save ROIs as is
	save_title = replace(title, ".tif", "_crop" + i+1 + ".tif");  //i starts with 0 but we want to start counting with 1
	saveAs("Tiff", savepath + save_title);

	//add scale bar without text
	run("Scale Bar...", "width=1 height=4 font=14 color=White background=None location=[Lower Right] bold hide overlay");
	save_title2 = replace(save_title, ".tif", "_scale1µm.tif");
	saveAs("Tiff", savepath + save_title2);

	//add scale bar with text
	run("Scale Bar...", "width=1 height=4 font=14 color=White background=None location=[Lower Right] bold overlay");
	save_title3 = replace(save_title, ".tif", "_scale.tif");
	saveAs("Tiff", savepath + save_title3);
	close();
}

roiManager("Save", savepath + "RoiSet.zip");

//then all of the selections are shown on the original file and obtain properties
selectImage(title);
run("Flatten");		//flatten all the channels first
roiManager("Show All");
roiManager("Set Color", "yellow");
roiManager("Set Line Width", 4);

// save original with the overlayed mask
save_title = replace(title, ".tif", "_with-mask.tiff");
saveAs("Tiff", savepath + save_title);

//then save all together flattened as jpg
run("Flatten");
save_title2 = replace(title, ".tif", "_with-mask_flat");
saveAs("Jpg", savepath + save_title2);
close ("*");





			
