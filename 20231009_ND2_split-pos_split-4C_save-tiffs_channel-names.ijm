/*takes a multi-position 5C .nd2 image, opens it via the bioformats importer, splits channels for each image of the series, saves them as tiffs individually
 * for paper revision to show that after 18h there is really cytC release
 * Sarah Schweighofer, Oct 2023
*/

//define the names of the three channels here:
channel1 = "cytC"
channel2 = "Tom"
channel3 = "BAX"
channel4 = "BAK"
//channel5 = "brightf."

// choose source directory
filepath = getDirectory("Choose_Source_Directory "); //gets saved as dictionnary
filelist = getFileList(filepath);

savepath = getDirectory("Choose_Destination_Directory ");

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	//if you find your_string anywhere in the filename - user can change this to any string wanted
	your_string = ".*lrg.*";
	if (matches(filename, your_string)) {	
	
		//nd2 images need to be opened with the bioformats importer
		file = filepath + "/" + filename;
		run("Bio-Formats Importer", "open=file autoscale color_mode=Default open_files open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		title = getTitle();
		print(title);
		run("Split Channels");

		for (k = 1; k < 5; k++) {
			//when the image is split into its 5 channels, FIJI calls them C1 to C3. Now we need to save them:
			if (k == 1) {
				selectWindow("C" + k + "-" + title);
				saveAs("Tiff", savepath + title + "_" + channel1); // saves as multipage tiff
				close();
			}
			
			if (k == 2) {
				selectWindow("C" + k + "-" + title);
				saveAs("Tiff", savepath + title + "_" + channel2); // saves as multipage tiff
				close();
			}
			
			if (k == 3) {
				selectWindow("C" + k + "-" + title);
				saveAs("Tiff", savepath + title + "_" + channel3); // saves as multipage tiff
				close();
			}
			
			if (k == 4) {
				selectWindow("C" + k + "-" + title);
				saveAs("Tiff", savepath + title + "_" + channel4); // saves as multipage tiff
				close();
			}
			
//			if (k == 5) {
//				selectWindow("C" + k + "-" + title);
//				saveAs("Tiff", savepath + title + "_" + channel5); // saves as multipage tiff
//				close();
//			}
		}
	}		
	//close ("*");
}

