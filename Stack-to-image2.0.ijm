run("RGB Color");
run("Scale Bar...", "width=2 height=12 font=42 color=White background=None location=[Lower Right] hide");
saveAs("Tiff");

open();
title = getTitle();
run("Stack to Images");

if(startsWith(filename, title)) {
	filelist.append()
}

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	saveAs("Tiff", "P:/Private/practice/imaging/LI/selected/LI26_OMP+Bax/LI26_spl3_CRISPR4.1_U2OS-wt_g1_Snap-OMP25_Snap-SiR600nM_GFP-Bax_cl1/LI26_spl3_cl1_part1_STED_merge_crop1-0010.tif");