/* This script takes a tiff file with specified name ending, opens its sisters and merges them to a LUT at will
 * Sarah V. Schweighofer, MPIBPC November 2021
 */


// choose source directory
SourceDir = getDirectory("Choose Source Directory ");
// filepath = "P:/Private/practice/imaging/IF/IF79_BaxK-on-WT_Bcl2-sampler/IF79_STEDycon/obfs_only/"; //this needs to be changed and needs to have backslash at the end!
subDirlist = getFileList(SourceDir);

namepart1 = "Cox8A.STED._enh99.9_Gauss2.tiff" // the image which is opened first - cytC or Tom20; in any case the confocal channel
namepart2 = "BaxBak.STED_BG-20._enh99.9_Gauss2.tiff" // use the Bak image

for (i = 0; i < subDirlist.length; i++) {
	subdir = SourceDir + subDirlist[i] + "renamed/" + "tifs/";
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
	
			run("Merge Channels...", "c2=[" + new_title +"] c6=[" + title + "] create ignore");
			// CMY c5=C (Bak), c6=M (Tom), c7 =Y (Bax)
			//Gray-Green-Magenta c2=green (Bax), c4=gray (Tom), c6=magenta (Bak)
			//Gray-Green-Magenta c2=green (Bax), c3=blue (Tom), c6=magenta (Bak)
			
			// run("Merge Channels...", "c5=SVS_IF75_BaxK_spl3_pos2_BaK.STED_BG-20._contr-enh.tiff c6=SVS_IF75_BaxK_spl3_pos2_Tom20.STEDcontr-enh.tiff c7=SVS_IF75_BaxK_spl3_pos2_Bax.STED_BG-20._contr-enh.tiff create ignore");
			
			save_title = replace(title, "Cox8A.STED._enh99.9_Gauss2.tiff", "merge");
			saveAs("Tiff", subdir + save_title + ".tif"); // saves as multipage tiff
			saveAs("Jpeg", subdir + save_title + ".jpg"); // saves as jpg
			close ("*");
		}
		// break
	}
}
