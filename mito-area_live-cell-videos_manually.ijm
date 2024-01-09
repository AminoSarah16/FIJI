/* This script takes an already open tiff file (presumably from a stack), let's the user choose threshold, quantifies the area and saves the binary as well as the csv
 * Sarah V. Schweighofer, MPIBPC January 2022
 */


// choose save directory
savepath = getDirectory("Choose_Destination_Directory ");


title = getTitle();
print(title);

//let the user choose brightness and contrast settings
run("Brightness/Contrast..."); //hit apply!
waitForUser;

// save
saveAs("Tiff", savepath + title);


//apply a Gaussian to make the mito area more even
run("Gaussian Blur...", "sigma=2");

//let the user choose the threshold for binarization
run("Threshold...");
waitForUser; //hit apply!

run("Analyze Particles...", "  show=Overlay clear summarize");


// save binary with the overlayed mask
save_title2 = title + "_binary.tif";
print(save_title2);
saveAs("Tiff", savepath + save_title2);
close();