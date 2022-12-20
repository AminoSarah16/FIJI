/*takes a stiched Lioheart image of RFP channel, opens it, finds the sytox-orange nuclei, counts them and saves the masks and results-table
 * Sarah Schweighofer, Dec 2021
*/


// choose source directory
filepath = getDirectory("Choose_Source_Directory "); //gets saved as dictionnary
filelist = getFileList(filepath);

savepath = getDirectory("Choose_Destination_Directory ");

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	//if you find your_string anywhere in the filename - user can change this to any string wanted
	your_string = ".*GFP.*";
	if (matches(filename, your_string)) {	
		file = filepath + "/" + filename;
		open(file);
		title = getTitle();
		print(title);
		
		//adjust brightness
		setMinAndMax(0, 30000);
//		waitForUser;
		run("Apply LUT");
		
		//run Gaussian blur
		run("Gaussian Blur...", "sigma=5");	
		
		// imageCalculator("Subtract create 32-bit", file, savepath + "F12_-1_2_1Z1_Stitched[GFP 469,525]_008_for-BG-subtr.tif");
		
		//run an Otsu threshold with dark background and no range reset
		setAutoThreshold("Intermodes dark no-reset");
		run("Convert to Mask");
//		
//		//run a fixed threshold with dark background and no range reset
//		setThreshold(15500, 65535);
//		run("Convert to Mask");

		//run("Analyze Particles...", "size=5-Infinity show=Masks display clear include summarize add in_situ");
		run("Analyze Particles...", "size=50-1500 circularity=0.70-1.00 show=Masks display clear include summarize add");  //TODO: make circularity more stringent, so that only "dead cells" are counted

		saveAs("Tiff", file + "_mask.tiff");
		
		close ("*");
	}		
}
Table.save(savepath + "Summary_GFP.csv","Summary");	