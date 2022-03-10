/*takes a stiched Lioheart image of RFP channel, opens it, finds the sytox-orange nuclei, counts them and saves the masks and results-table
 * Sarah Schweighofer, Dec 2021
*/


// choose source directory
filepath = getDirectory("Choose_Source_Directory "); //gets saved as dictionnary
filelist = getFileList(filepath);

// savepath = getDirectory("Choose_Destination_Directory ");

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	//if you find your_string anywhere in the filename - user can change this to any string wanted
	your_string = ".*RFP.*";
	if (matches(filename, your_string)) {	
		file = filepath + "/" + filename;
		open(file);
		title = getTitle();
		print(title);

		//run an Otsu threshold with dark background and no range reset
		setThreshold(10000, 65535);
		run("Convert to Mask");

		run("Fill Holes");
		run("Open");
		run("Watershed");

		run("Analyze Particles...", "  show=Masks display clear include summarize add in_situ");

		saveAs("Tiff", file + "_mask.tiff");
		
		close ("*");
	}		
}
Table.save(filepath + "Summary_sytox.csv","Summary");	