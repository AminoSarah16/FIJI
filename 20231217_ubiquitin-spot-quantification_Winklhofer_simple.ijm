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
	your_string = ".*ubiquitin.*";
	if (matches(filename, your_string)) {	
		file = filepath + "/" + filename;
		open(file);
		title = getTitle();
		print(title);

		//now set the threshold on the ubiquitin channel;
		setThreshold(230, 255, "raw");
		setOption("BlackBackground", true);
		run("Convert to Mask");

		run("Analyze Particles...", "size=2-Infinity pixel show=Masks add");

		Table.save(savepath + filename + "results.csv","Results");
		run("Clear Results");

		//close all images
		close ("*");

		//select all ROIs and clear them
		roiManager("Select All");
		roiManager("delete");
	}
}			