/*takes a phase-contrast Lioheart image, opens it, enhances the area of cells and saves it
 * Sarah Schweighofer, Dec 2021
 * used for LI54
*/


// choose source directory
filepath = getDirectory("Choose_Source_Directory "); //gets saved as dictionnary
filelist = getFileList(filepath);

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	//if you find your_string anywhere in the filename - user can change this to any string wanted
	your_string = ".*Phase.*";
	if (matches(filename, your_string)) {		
		file = filepath + "/" + filename;
		open(file);
		title = getTitle();
		print(title);

		// do a rolling ball background subtraction with 5
		run("Subtract Background...", "rolling=5 light sliding");

		//then duplicate the roll-balled image and do a Gaussian blur with sigma 20
		run("Duplicate...", "title=gauss20");
		selectWindow("gauss20");
		run("Gaussian Blur...", "sigma=20");

		// then subtract the uneven illumination background by subtracting the blurred image
		imageCalculator("Subtract create 32-bit", title,"gauss20");

		// then convert the image to 16bit and enhance contrast by setting no pixels to saturated
		setOption("ScaleConversions", true);
		run("16-bit");
		run("Enhance Contrast...", "saturated=0 equalize");
		
		//to get the final title simply replace the original channel-name with whatever
		save_title = replace(title, ".tif", "_enh.tif");
		saveAs("Tiff", filepath + save_title);
		
		close ("*");
	}
}
		
		