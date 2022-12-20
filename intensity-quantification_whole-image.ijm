/*takes images, opens them, and analyses the intensity
 * then saves the results-table
 * Sarah Schweighofer, Mar 2022
 * MPI-NAT, Göttingen
*/


// choose source directory
filepath = getDirectory("Choose_Source_Directory "); //gets saved as dictionnary
filelist = getFileList(filepath);

savepath = getDirectory("Choose_Save_Directory ");

// savepath = getDirectory("Choose_Destination_Directory ");

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	//if you find your_string anywhere in the filename - user can change this to any string wanted
	your_string = ".*_2.*";
	if (matches(filename, your_string)) {	
		file = filepath + "/" + filename;
		open(file);
		title = getTitle();
		print(title);

		run("Set Measurements...", "area mean modal min perimeter shape display redirect=None decimal=3");
		run("Measure");
		
		close ("*");
	}
}

Table.save(savepath + "results_whole-image.csv","Results");	