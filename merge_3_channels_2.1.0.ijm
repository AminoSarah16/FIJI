/*takes three channels, opens them, merges them and saves them
 * Sarah V. Schweighofer, Jan 2022
*/


// choose source directory
filepath = getDirectory("Choose_Source_Directory "); //gets saved as dictionnary
filelist = getFileList(filepath);


for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];
	
	//if you find your_string anywhere in the filename - user can change this to any string wanted
	your_string = ".*_3.tif.*";
	if (matches(filename, your_string)) {	//Tom
		file = filepath + "/" + filename;
		open(file);
		setMinAndMax(0, 30000);
		run("Apply LUT");
		
		title = getTitle();
		print(title);
		
		new_title = replace(title, "_3", "_2"); //cytC
		print(new_title);
		open(filepath + "/" + new_title);
		setMinAndMax(5000, 30000);
		run("Apply LUT");

		new_title2 = replace(new_title, "_2", "_1"); //DAPI
		print(new_title2);
		open(filepath + "/" + new_title2);
		setMinAndMax(5000, 30000);
		run("Apply LUT");
		
		run("Merge Channels...", "c2=[" + new_title +"] c3=[" + new_title2 + "] c6=[" + title + "] create ignore");
		// CMY c5=C (Bak), c6=M (Tom), c7 =Y (Bax)
		//Gray-Green-Magenta c2=green (Bax), c4=gray (Tom), c6=magenta (Bak)
		//Gray-Green-Magenta c2=green (Bax), c3=blue (Tom), c6=magenta (Bak)
		
		// run("Merge Channels...", "c5=SVS_IF75_BaxK_spl3_pos2_BaK.STED_BG-20._contr-enh.tiff c6=SVS_IF75_BaxK_spl3_pos2_Tom20.STEDcontr-enh.tiff c7=SVS_IF75_BaxK_spl3_pos2_Bax.STED_BG-20._contr-enh.tiff create ignore");
		
		save_title = replace(title, "_3.tif", "_merge5-30000");
		saveAs("Tiff", filepath + save_title + ".tif"); // saves as multipage tiff
		saveAs("Jpeg", filepath + save_title + ".jpg"); // saves as jpg
		close ("*");
	}
	// break
}
