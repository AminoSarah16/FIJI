filepath = "P:/Private/practice/imaging/IF/IF77_Opa1-KO/obfs_only/IF77_spl2_loop-cl1-20/renamed/tifs/";
filelist = getFileList(filepath);

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	if(endsWith(filename, "BaxK.STED_BG-20._contr-enh.tiff")) {
		open(filepath + "/" + filename);
		title = getTitle();
		// print(title);
		new_title = replace(title, "BaxK.STED_BG-20._contr-enh.tiff", "Tom20.STEDcontr-enh.tiff");
		// print(new_title);
		open(filepath + "/" + new_title);
		
		run("Merge Channels...", "c2=[" + title +"] c6=[" + new_title + "] create ignore");
		// c2 = green; c6 = magenta
		
		save_title = replace(title, "BaxK.STED_BG-20.", "merge");
		saveAs("Tiff", filepath + save_title); // saves as multipage tiff
		saveAs("Jpeg", filepath + save_title + ".jpg");
		close ("*");
	}
	//break
}
