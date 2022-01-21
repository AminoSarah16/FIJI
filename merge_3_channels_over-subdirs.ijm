/* This script takes a tiff file with specified name ending, opens its sisters and merges them to a LUT at will
 * Sarah V. Schweighofer, MPIBPC November 2021
 */


// choose source directory
SourceDir = getDirectory("Choose Source Directory ");
// filepath = "P:/Private/practice/imaging/IF/IF79_BaxK-on-WT_Bcl2-sampler/IF79_STEDycon/obfs_only/"; //this needs to be changed and needs to have backslash at the end!
subDirlist = getFileList(SourceDir);

namepart1 = "Tom20.STED._enh99.9.tiff" // the image which is opened first - cytC or Tom20; in any case the confocal channel
namepart2 = "Bak.STED_BG-20._enh99.9_Gauss2.tiff" // use the Bak image

for (i = 0; i < subDirlist.length; i++) {
	subdir = SourceDir + subDirlist[i] + "renamed/"; //ATTENTION! NEED to change here where the subdir is located!
	print(subdir);
	filelist = getFileList(subdir);
	for (j = 0; j < filelist.length; j++) {
		filename = filelist [j];
		
	
		if(endsWith(filename, namepart1)) {
			open(subdir + "/" + filename);
			title = getTitle();
			print(title);
			
			new_title = replace(title, namepart1, namepart2);
			print(new_title);
			open(subdir + "/" + new_title);
	
			new_title2 = replace(new_title, "Bak", "Bax");
			print(new_title2);
			open(subdir + "/" + new_title2);
			
			run("Merge Channels...", "c2=[" + new_title2 +"] c3=[" + title + "] c6=[" + new_title + "] create ignore");
			// CMY c5=C (Bak), c6=M (Tom), c7 =Y (Bax)
			//Gray-Green-Magenta c2=green (Bax), c4=gray (Tom), c6=magenta (Bak)
			//Gray-Green-Magenta c2=green (Bax), c3=blue (Tom), c6=magenta (Bak)
			
			// run("Merge Channels...", "c5=SVS_IF75_BaxK_spl3_pos2_BaK.STED_BG-20._contr-enh.tiff c6=SVS_IF75_BaxK_spl3_pos2_Tom20.STEDcontr-enh.tiff c7=SVS_IF75_BaxK_spl3_pos2_Bax.STED_BG-20._contr-enh.tiff create ignore");
			
			save_title = replace(title, "Tom20", "merge");
			saveAs("Tiff", subdir + save_title); // saves as multipage tiff
			saveAs("Jpeg", subdir + save_title + ".jpg"); // saves as jpg
			close ("*");
		}
		// break
	}
}
