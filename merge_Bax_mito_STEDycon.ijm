// DO NOT FORGET TO CREATE THE SAVEPATH FIRST
// no idea how that works in FIJI


filepath = "P:/Private/practice/imaging/IF/IF71_correl-LI47_cytC-release/IF71_STEDycon/all_STEDycon_images/renamed/tifs/";
savepath = "P:/Private/practice/imaging/IF/IF71_correl-LI47_cytC-release/IF71_STEDycon/all_STEDycon_images/renamed/tifs/merge/"
filelist = getFileList(filepath);
Bax_name_part = "Bax.STEDcontrx2,5"

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];

	// open a file of the one channel
	if(endsWith(filename, Bax_name_part + ".tiff")) {
		open(filepath + "/" + filename);
		title = getTitle();
		// print(title);

		//then replace the keyword in the title with the keyword for the second channel
		new_title = replace(title, Bax_name_part, "Tom22.STED");
		// print(new_title);

		//then open this second channel
		open(filepath + "/" + new_title);

		//c2 = green, c6 = magenta
		run("Merge Channels...", "c2=[" + title +"] c6=[" + new_title + "] ignore");

		//to get the final titel simply replace the keyord for the channel in orginial title with the word merge
		save_title = replace(title, Bax_name_part + ".tiff", "merge.STED");
		saveAs("Jpeg", savepath + save_title + ".jpg");
		close ("*");
	}
	// break
}
