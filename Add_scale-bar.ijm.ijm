// This is a macro to add a scale bar, to an image, then flatten it and save as tiff. Scalebar settings can either be changed in the dialoge window or directly in the script.

run("Scale Bar...", "width=2 height=8 font=16 color=White background=None location=[Lower Right] bold hide overlay");
//if you want to bring up the menu to adjust the scale bar manually use the following line:
// run("Scale Bar...")
run("Flatten");
saveAs("Tiff", "P:/Private/practice/imaging/IF/selected/IF74_correl_LI50/IF74_random_cells/C3-IF74_spl1_random-cell-IMG0012_crop1.1_Bak_scl2.tif");
