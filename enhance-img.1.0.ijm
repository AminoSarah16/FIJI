/*takes a tif, opens it, enhances and saves it as 8-bit
 * Sarah V. Schweighofer, Jan 2022
*/


// choose source directory
filepath = getDirectory("Choose_Source_Directory "); //gets saved as dictionnary
filelist = getFileList(filepath);


for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	//if you find your_string anywhere in the filename - user can change this to any string wanted
	your_string = ".*_3..*";
	if (matches(filename, your_string)) {	//Tom
		file = filepath + "/" + filename;
		open(file);
		setMinAndMax(0, 30000);
		run("Apply LUT");
		run("8-bit");
		run("Grays");
		
		title = getTitle();
		print(title);
		
		save_title = replace(title, "_3.tif", "_3-enhanced");
		saveAs("Tiff", filepath + save_title + ".tif"); // saves as multipage tiff
		saveAs("Jpeg", filepath + save_title + ".jpg"); // saves as jpg
		close ("*");
	}
	// break
}
