/*prompts the user to open a directory with tiffs, where they are ordered to become a stack (movie).
 * the script then opens these in an ordered fashion and saves the stack as tiff and avi
 * Sarah V. Schweighofer, Jul 2022, MPINAT, Göttingen
*/

//user needs to give a savetitle!!
// CHANGE THIS!!!!
save_title = "LI35_spl1_pos02_Halo-Bax_stack.tiff";

// choose source directory and sort the filelist
filepath = getDirectory("Choose_Source_Directory ");
filelist = getFileList(filepath);


for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	print(filename);

	file = filepath + "/" + filename;
	print(file);
	open(file);

}	

// produce the stack
run("Images to Stack", "use");
// save stack as tiff
saveAs("Tiff", filepath + save_title);			

//close all open images
close ("*");
