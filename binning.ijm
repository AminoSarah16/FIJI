// DO NOT FORGET TO MANUALLY CREATE THE SAVEPATH FIRST
// no idea how that works in FIJI


filepath = "P:/Private/practice/imaging/LI/selected/LI51";
savepath = "P:/Private/practice/imaging/LI/selected/LI51/binned/"
filelist = getFileList(filepath);
print(filepath);

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	if(endsWith(filename, ".tif")) {
		open(filepath + "/" + filename);
		title = getTitle();
		// print(title);
	
		// bin 4 pixels together to 1
		run("Bin...", "x=2 y=2 bin=Average");


		saveAs("Jpeg", savepath + title + ".jpg");
		close ("*");
	}
}
