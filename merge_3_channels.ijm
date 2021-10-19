filepath = "P:/Private/practice/imaging/IF/IF78_BaxK-WT/IF78_BaxK-on-WT_STEDycon/obfs only/IF78_spl6/renamed/tifs/"; //this needs to be changed and needs to have backslash at the end!
filelist = getFileList(filepath);

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	if(endsWith(filename, "cytC.STED.tiff")) {
		open(filepath + "/" + filename);
		title = getTitle();
		print(title);
		
		new_title = replace(title, "cytC.STED.tiff", "Bak.STED_BG-20._contr-enh_Gauss2.tiff");
		print(new_title);
		open(filepath + "/" + new_title);

		new_title2 = replace(new_title, "Bak", "Bax");
		print(new_title2);
		open(filepath + "/" + new_title2);
		
		run("Merge Channels...", "c2=[" + new_title2 +"] c3=[" + title + "] c6=[" + new_title + "] create ignore");
		// CMY c5=C (Bak), c6=M (Tom), c7 =Y (Bax)
		//Gray-Green-Magenta c2=green (Bax), c4=gray (Tom), c6=magenta (Bak)
		//Gray-Green-Magenta c2=green (Bax), c3=blue (Tom), c6=magenta (Bak)
		
		// run("Merge Channels...", "c5=SVS_IF75_BaxK_spl3_pos2_BaK.STED_BG-20._contr-enh.tiff c6=SVS_IF75_BaxK_spl3_pos2_Tom20.STEDcontr-enh.tiff c7=SVS_IF75_BaxK_spl3_pos2_Bax.STED_BG-20._contr-enh.tiff create ignore");
		
		save_title = replace(title, "Tom20", "merge");
		saveAs("Tiff", filepath + save_title); // saves as multipage tiff
		saveAs("Jpeg", filepath + save_title + ".jpg"); // saves as jpg
		close ("*");
	}
	// break
}
