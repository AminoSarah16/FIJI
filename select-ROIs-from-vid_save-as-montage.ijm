/* This script takes an already open multichannel-multi-timepoint tiff file, let's the user choose unlimited amount of crops, saves the crops as ROIs and a montage with the timepoints marked
 * Sarah V. Schweighofer, MPIBPC March 2022
 */


// choose save directory
savepath = getDirectory("Choose_Destination_Directory ");


title = getTitle();
print(title);

		
// set the right pixel size - here 20nm
run("Set Scale...", "distance=1 known=20 unit=nm global");

//makeRectangle
waitForUser("ROI", "Please select ROIs add them to the ROI manager (press t). Tip: Hold Shift key while dragging in order for them to be square, but release and click anywhere in between to not combine the ROIs. You can also make sure that all the ROIs have the same size: Edit > Selection > Specify.Click OK when done.");
