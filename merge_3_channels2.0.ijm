filepath = getDirectory("Choose Source Directory ");
filelist = getFileList(filepath);

namepart1 = "Tom20.STED-enh99.9.tiff" // the image which is opened first - cytC or Tom20; in any case the confocal channel
namepart2 = "BaxK.STED_BG-20._enh99.9_Gauss2.tiff" // use the Bak image
namepart3 = "DNA.STED-enh99.9.tiff"

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	if(endsWith(filename, namepart1)) {
		open(filepath + "/" + filename);
		title1 = getTitle();
		print(title1);
			
		title2 = replace(title1, namepart1, namepart2);
		print(title2);
		open(filepath + "/" + title2);
	
		title3 = replace(title1, namepart1, namepart3);
		print(title3);
		open(filepath + "/" + title3);
			
		run("Merge Channels...", "c2=[" + title2 +"] c3=[" + title1 + "] c6=[" + title3 + "] create ignore");
		// CMY c5=C (Bak), c6=M (Tom), c7 =Y (Bax)
		//Gray-Green-Magenta c2=green (Bax), c4=gray (Tom), c6=magenta (Bak)
		//Blue-Green-Magenta c2=green (Bax), c3=blue (Tom), c6=magenta (Bak)
			
		// run("Merge Channels...", "c5=SVS_IF75_BaxK_spl3_pos2_BaK.STED_BG-20._contr-enh.tiff c6=SVS_IF75_BaxK_spl3_pos2_Tom20.STEDcontr-enh.tiff c7=SVS_IF75_BaxK_spl3_pos2_Bax.STED_BG-20._contr-enh.tiff create ignore");
			
		save_title = replace(title1, "Tom20", "merge");
		saveAs("Tiff", filepath + save_title); // saves as multipage tiff
		saveAs("Jpeg", filepath + save_title + ".jpg"); // saves as jpg
		close ("*");
	}
	// break
}
