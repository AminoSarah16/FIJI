run("Bio-Formats Importer", "open=P:/Private/practice/imaging/TC-snapshots/CRISPR4.2_single-clones/CRISPR4.2_single-clones.lif autoscale color_mode=Default open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");

for (i = 0; i < nImages; i++) {
	selectImage(i+1);
	name=getTitle();
	print(name);
}
