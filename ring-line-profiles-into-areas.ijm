/* user manually opens a tiff and an ROI file.
 * imports the according ROI file with the line-profiles
 * the script then edits the selection to areas of circles
 * then measures all sorts of properties, esp. circularity
 * also saves the area ROI and the masks image file
 * Sarah Schweighofer, Sep 2022, MPINAT, Göttingen
*/


			
			
// select all ROIS, combine all ROIs to one and add them to the ROI manager
count=roiManager("Count");
array = newArray(count);
	for (i=0; i<array.length; i++) {
	array[i] = i;
	}
roiManager("select", array);
roiManager("Combine");
roiManager("Add");

//select the newly created ROI, consisting of all ROIs
a=roiManager("Count");
print(a);
roiManager("Select",a-1);
run("Fill", "slice"); //fill means fill the selction with foreground color, just to make it easy for the threshold
// invert the selection, so that the whole image without the circles is selected and make it black
run("Make Inverse");
//roiManager("Add");
//a=roiManager("Count");
//print(a);
//roiManager("Select",a-1);
setBackgroundColor(0, 0, 0);
run("Clear"); //, "slice" //clear means fill the selection with background color
waitForUser;
// make the image 8 bit and then binarize with a threshold, which should then only give the circles
run("8-bit");
setAutoThreshold("Default dark");
setOption("BlackBackground", true);
run("Convert to Mask");
waitForUser;
// run binary operator fill holes to make areas out of cirlce
run("Fill Holes");
waitForUser;
//create particles out of the binary mask
run("Analyze Particles...", "display clear summarize add");
waitForUser;

