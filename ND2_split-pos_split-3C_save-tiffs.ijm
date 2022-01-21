/*takes a multi-position 3C .nd2 image, opens it via the bioformats importer, splits channels for each image of the series, saves them as tiffs individually
 * Sarah Schweighofer, Dec 2021
*/


// choose source directory
filepath = getDirectory("Choose_Source_Directory "); //gets saved as dictionnary
filelist = getFileList(filepath);

savepath = getDirectory("Choose_Destination_Directory ");

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	//if you find your_string anywhere in the filename - user can change this to any string wanted
	your_string = ".*pos.*";
	if (matches(filename, your_string)) {	
	
		//nd2 images need to be opened with the bioformats importer
		file = filepath + "/" + filename;
		run("Bio-Formats Importer", "open=file autoscale color_mode=Default open_files open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		
		number_of_images = nImages;  //counts the number of open images
		print(number_of_images);
		for (j = 0; j < number_of_images; j++) {
			title = getTitle();
			print(title);
			run("Split Channels");

			for (k = 1; k < 4; k++) {
				//when the image is split into its 3 channels, FIJI calls them C1 to C3. Now we need to save them:
				selectWindow("C" + k + "-" + title);
				saveAs("Tiff", savepath + title + "_" + k); // saves as multipage tiff
				close();
			}
		}		
		//close ("*");
	}
}
