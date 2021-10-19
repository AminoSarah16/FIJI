filepath = "P:/Private/practice/quantification_of_imaging_experiments/ring_analysis/ring_analysis_Ilastik/batch/"; //this needs to be changed and needs to have backslash at the end!
filelist = getFileList(filepath);

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	if(endsWith(filename, "Bak.STED_BG-20._contr-enh_binary.tiff")) {
		open(filepath + "/" + filename);
		title = getTitle();
		print(title);

		// Magenta for Bak
		run("Magenta");
		run("Invert LUT");
		save_title1 = replace(title, "binary", "binary_inv");
		saveAs("Tiff", filepath + save_title1);

		new_title = replace(title, "Bak", "Bax");
		print(new_title);
		open(filepath + "/" + new_title);
		//and Green for Bax
		run("Green");
		run("Invert LUT");
		save_title2 = replace(new_title, "binary", "binary_inv");
		saveAs("Tiff", filepath + save_title2);

		run("Merge Channels...", "c2=[" + save_title2 +"] c6=[" + save_title1 + "] create keep");
		save_title3 = replace(title, "Bak.STED_BG-20._contr-enh_binary.tiff", "binary_merge");
		saveAs("Tiff", filepath + save_title3); // saves as multipage tiff
		saveAs("Jpeg", filepath + save_title3 + ".jpg"); // saves as jpg
		close ("*");
	}
	// break
}
