/*takes a 4C .nd2 image, opens it via the bioformats importer, splits channels, saves them as tiffs individually
 * Sarah Schweighofer, Dec 2021
*/


// choose source directory
filepath = getDirectory("Choose_Source_Directory "); //gets saved as dictionnary
filelist = getFileList(filepath);

savepath = getDirectory("Choose_Destination_Directory ");

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	if(endsWith(filename, "lrg-img.nd2") || endsWith(filename, "lrg-img2.nd2")) {
		//nd2 images need to be opened with the bioformats importer
		file = filepath + "/" + filename;
		run("Bio-Formats Importer", "open=file autoscale color_mode=Default open_files open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		title = getTitle();
		print(title);
		run("Split Channels");
		
		for (j = 1; j < 5; j++) {
			//when the image is split into its 4 channels, FIJI calls them C1 to C4. Now we need to save them:
			selectWindow("C" + j + "-" + title);
			
			saveAs("Tiff", savepath + title + "_" + j); // saves as multipage tiff
		}		
		close ("*");
	}
}
