file="X:/Harriet/images/CRISPR4.2_single-clones/CRISPR4.2_single-clones.lif";

run("Bio-Formats Importer", "open=file autoscale color_mode=Default open_files open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
//opens every image of the series without having to pick them

path= getTitle();
print(path)
filepath= path - file;
print(filepath)