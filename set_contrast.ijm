filepath = "P:/Private/practice/quantification_of_imaging_experiments/ring_analysis/ring_analysis_Ilastik/batch/"; //this needs to be changed and needs to have backslash at the end!
filelist = getFileList(filepath);

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	if(endsWith(filename, "Segmentation.tiff")) {
		open(filepath + "/" + filename);
		title = getTitle();
		print(title);
		run("Brightness/Contrast...");
		setMinAndMax(1, 2);
		run("Apply LUT");
		save_title = replace(title, "Simple Segmentation", "binary");  //BG for background and 20 for the sliding paraboloid size
		saveAs("Tiff", filepath + save_title);
		close ("*");
	}
	// break
}
