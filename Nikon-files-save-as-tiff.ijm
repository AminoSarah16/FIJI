filepath = "P:/Private/practice/imaging/TC-snapshots/96-well_on-Nikon/20201209_mEGFP-cytC_single-clones/single-wells_captured";
output_filepath = filepath + "/tiffs";
// print(output_filepath);

filelist = getFileList(filepath);

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];

	open(filepath + "/" + filename);
	title = getTitle();
	print(title);
	//run("Brightness/Contrast...");
	setMinAndMax(300, 1100);
	run("Apply LUT");
	// run("Close");
	run("Gaussian Blur...", "sigma=2");
	saveAs("Tiff", output_filepath + "/" + filename);
	close ("*");
	
}