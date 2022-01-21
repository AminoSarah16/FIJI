file="X:/Harriet/images/CRISPR4.2_single-clones/CRISPR4.2_single-clones.lif";

run("Bio-Formats Importer", "open=file autoscale color_mode=Default open_files open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
//opens every image of the series without having to pick them

for(i=0; i < nImages; i++) {
	selectImage(i+1); //activates the next image (Image_ids beginn with 1, that's why it's i+1)
	run("Gaussian Blur...", "sigma=2");
	setMinAndMax(0, 188);
	run("Apply LUT");
	saveAs("tiff",getTitle()); //getTitle shows the whole path (f.e. X: ...clone5_roi3)
	
}
close("*");

//og=ohne Gaussian blur