/* This script takes a tiff file with specified name ending, opens its sisters and merges them to a LUT at will
 * Sarah V. Schweighofer, MPIBPC November 2021
 */


// choose source directory
SourceDir = getDirectory("Choose Source Directory ");
// filepath = "P:/Private/practice/imaging/IF/IF79_BaxK-on-WT_Bcl2-sampler/IF79_STEDycon/obfs_only/"; //this needs to be changed and needs to have backslash at the end!
subDirlist = getFileList(SourceDir);

namepart1 = "Cox8A.STED-enh99.9.tiff" // the image which is opened first - cytC or Tom20; in any case the confocal channel - ALSO Change at the bottom in the save_title variable!!
namepart2 = "DNA.STED_BG-20._enh99.9.tiff"
namepart3 = "Tom.STED-enh99.9.tiff"

for (i = 0; i < subDirlist.length; i++) {
	subdir = SourceDir + subDirlist[i] + "renamed/" + "tifs/";  //ATTENTION! NEED to change here where the subdir is located!
	print(subdir);
	filelist = getFileList(subdir);
	for (j = 0; j < filelist.length; j++) {
		filename = filelist [j];
		
	
		if(endsWith(filename, namepart1)) {
			open(subdir + "/" + filename);
			title1 = getTitle();
			print(title1);
			
			title2 = replace(title1, namepart1, namepart2);
			print(title2);
			open(subdir + "/" + title2);
	
			title3 = replace(title1, namepart1, namepart3);
			print(title3);
			open(subdir + "/" + title3);
			
			run("Merge Channels...", "c2=[" + title2 +"] c3=[" + title1 + "] c6=[" + title3 + "] create ignore");
			// CMY c5=C (Bak), c6=M (Tom), c7 =Y (Bax)
			//Gray-Green-Magenta c2=green (Bax), c4=gray (Tom), c6=magenta (Bak)
			//Blue-Green-Magenta c2=green (Bax), c3=blue (Tom), c6=magenta (Bak)
			
			save_title = replace(title1, "Cox8A.STED-enh99.9", "merge");
			saveAs("Tiff", subdir + save_title); // saves as multipage tiff
			saveAs("Jpeg", subdir + save_title + ".jpg"); // saves as jpg
			close ("*");
		}
		// break
	}
}
