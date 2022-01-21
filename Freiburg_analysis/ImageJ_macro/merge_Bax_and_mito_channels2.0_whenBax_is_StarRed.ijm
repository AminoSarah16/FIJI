// TODO: comment!!!!
// you just need to replace the filepath and create the directory "merges" for the SaveAs function.
// and then of course the string replacement needs to be adjusted accordingly


filepath = "P:/Private/practice/imaging/IF/selected/IFs_Freiburg_replicates/04_U2OS_DKO_plus_Bax_BH3i/replicate3/pcDNA/extracted_tifs_from_msr" + "/";
filelist = getFileList(filepath);

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	if(endsWith(filename, "0contr_enh.jpg")) {
		open(filepath + "/" + filename);
		title = getTitle();
		print(title);
		
		// in the string title, replace the channel number 0 with 1 for the second channel  replace(string, old, new)
		intermediate = replace(title, "Alexa 594", "STAR RED");
		new_title = replace(intermediate, "0contr", "1contr");  //TODO: make applicable to all filenames
		// new_title = "abc";
		print(new_title);
		open(filepath + "/" + new_title);
		
		run("Merge Channels...", "c2=[" + new_title +"] c6=[" + title + "] ignore");
		// waitForUser("prompt");
		// give the new image the name where 0 is replaced by merge
		save_title = replace(title, "0contr", "_merge");
		saveAs("Jpeg", filepath + "merges" + "/" + save_title);
		close ("*");
	}
	
	//break
}
