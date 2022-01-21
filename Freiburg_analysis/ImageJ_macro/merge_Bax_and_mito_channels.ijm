filepath = "P:/Private/practice/imaging/Image-processing/Freiburg_analysis/IF41_replicate3/results/";
filelist = getFileList(filepath);

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	if(endsWith(filename, "Alexa 594_STED {2}.jpg")) {
		open(filepath + "/" + filename);
		title = getTitle();
		// print(title);
		new_title = replace(title, "Alexa 594", "STAR RED");
		// print(new_title);
		open(filepath + "/" + new_title);
		
		run("Merge Channels...", "c2=[" + new_title +"] c6=[" + title + "] ignore");
		
		save_title = replace(title, "Alexa 594", "_merge");
		saveAs("Jpeg", filepath + save_title + ".jpg");
		close ("*");
	}
	break
}
